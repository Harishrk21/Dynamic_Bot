// index.js
const express = require('express');
const dotenv = require('dotenv');
const { getAppointmentDetailsByAppointmentId,getAppointmentDetailsByUserID, getMeetLink, getTemplateMessage, insertAppointment, updateAppointment, updateJsonData, updateAvailableSlots, getClientID, getWelcomeMessage, getMainMenu, getFromList, insertUserData, getUserData, updateUserField, getPocFromPoc, getAvailableDates, getAvailableTimes, increaseAvailableSlots } = require('./dbController');
const { connectDB } = require('./db');
const { sendWhatsAppMessage, sendInteractiveMessage,sendCancelInteractiveMessage, sendRadioButtonMessage, sendBackButtonMessage } = require('./utils');
const { isValidEmail, isValidPhoneNumber } = require('./validate');

dotenv.config();
const app = express();
const port = process.env.PORT || 3000;
connectDB();
app.use(express.json());

app.get('/', (req, res) => {
    res.send('Server is running! Welcome to the Meister Solutions.');
});


let userData;

app.get('/webhook', (req, res) => {
    const VERIFY_TOKEN = process.env.VERIFY_TOKEN || 'your_verify_token';
    const mode = req.query['hub.mode'];
    const token = req.query['hub.verify_token'];
    const challenge = req.query['hub.challenge'];

    if (mode === 'subscribe' && token === VERIFY_TOKEN) {
        console.log('WEBHOOK_VERIFIED');
        res.status(200).send(challenge);
    } else {
        res.sendStatus(403);
    }
});

app.post('/webhook', async(req, res) => {
    const body = req.body;
    let title = [];
    let Response_id = [];

    if (body.object) {
        const changes = body.entry && body.entry[0].changes && body.entry[0].changes[0].value.messages;
        const displayPhoneNumber = body.entry[0].changes[0].value.metadata.display_phone_number;
        const phoneNumberId = body.entry[0].changes[0].value.metadata.phone_number_id;

        process.env.PHONE_NUMBER_ID = phoneNumberId;

        if (changes && changes[0]) {
            const from = changes[0].from;
            const messageBody = changes[0].text ? changes[0].text.body : null;
            console.log(`Received message: ${messageBody} from: ${from}`);

            const messageType = changes[0].text ? changes[0].type : null;
            console.log(`Received message type: ${messageType}`);

            if (messageType === 'text') {
                // Get client ID based on the display phone number
                const clientId = await getClientID(displayPhoneNumber);

                // Check user status (new or returning)
                userData = await getUserData(from);

                if (userData) {
                    // User exists - check for missing fields and prompt accordingly
                    if (!userData.User_Name) {
                        await updateUserField(from, 'User_Name', messageBody);
                        await sendWhatsAppMessage(from, "Thank you! Please enter your email:");
                    } else if (!userData.User_Email) {
                        // Validate the email before updating
                        if (isValidEmail(messageBody)) {
                            await updateUserField(from, 'User_Email', messageBody);
                            await sendWhatsAppMessage(from, "Thank you! Please share your location:");
                        } else {
                            // Invalid email format - prompt user to enter a valid email
                            await sendWhatsAppMessage(from, "The email you entered is invalid. Please enter a valid email address:");
                        }
                    } else if (!userData.User_Location) {
                        await updateUserField(from, 'User_Location', messageBody);
                        await sendWhatsAppMessage(from, "Thank you for completing your details.");

                        // Show main menu after completing registration
                        const welcomeMessage = await getWelcomeMessage(clientId);
                        await sendWhatsAppMessage(from, `Hi ${userData.User_Name}, ${welcomeMessage}`);

                        const mainMenuItems = await getMainMenu(clientId, 0);
                        const headerMessage = mainMenuItems[0].HEADER_MESSAGE;
                        const menuNames = mainMenuItems.map(item => ({ id: item.CLIENT_ID + '~' + item.MENU_ID + '~' + item.MENU_ID + '|' + item.CLIENT_ID + '~' + item.MENU_ID + '~' + item.MENU_ID, title: item.MENU_NAME }));
                        await sendInteractiveMessage(from, headerMessage, menuNames);
                    } else {
                        // Fully registered user - display main menu
                        const welcomeMessage = await getWelcomeMessage(clientId);
                        await sendWhatsAppMessage(from, `Hi ${userData.User_Name}, ${welcomeMessage}`);

                        const mainMenuItems = await getMainMenu(clientId, 0);
                        const headerMessage = mainMenuItems[0].HEADER_MESSAGE;
                        const menuNames = mainMenuItems.map(item => ({ id: item.CLIENT_ID + '~' + item.MENU_ID + '~' + item.MENU_ID + '|' + item.CLIENT_ID + '~' + item.MENU_ID + '~' + item.MENU_ID, title: item.MENU_NAME }));
                        await sendInteractiveMessage(from, headerMessage, menuNames);

                        // Initialize Appointment_ID right after collecting full user data
                        console.log(`user Id: ${userData.User_ID}`);
                        /* const Appointment_ID = await insertAppointment(clientId, userData.User_ID);
                         sessionMap[from] = Appointment_ID;
                         console.log(`Appointment id: ${Appointment_ID}`); */
                    }
                } else {
                    // New user - insert user record and ask for name
                    await insertUserData(from);
                    await sendWhatsAppMessage(from, "Welcome! Please enter your name:");
                }
            } else {
                // Extract the title from the JSON data
                message = body.entry[0].changes[0].value.messages[0];
                if (message.interactive) {
                    const interactiveType = message.interactive.type;
                    if (interactiveType === 'button_reply' && message.interactive.button_reply) {
                        title = message.interactive.button_reply.title;
                        Response_id = message.interactive.button_reply.id.split('|');
                    } else if (interactiveType === 'list_reply' && message.interactive.list_reply) {
                        title = message.interactive.list_reply.title;
                        Response_id = message.interactive.list_reply.id.split('|');
                    }
                }

                console.log(`Title: ${title} ID: ${Response_id}`);
                previousId = Response_id[1];
                Response_id = Response_id[0].split('~');
                clientId = Response_id[0];
                menuId = Response_id[1];
                selectId = Response_id[2];
                Appointment_ID = Response_id[3];

                try {

                    if (title.toLowerCase() === 'book appointment') {
                        Appointment_ID = await insertAppointment(clientId, userData.User_ID);
                        console.log(`Appointment id: ${Appointment_ID}`);
                    }
                    // Get the main menu for initial interaction
                    const mainMenuItems = await getMainMenu(clientId, menuId);

                    if (mainMenuItems.length === 0) {
                        sendWhatsAppMessage(from, "No menu options available.");
                        return;
                    } else if (mainMenuItems.length === 1 && mainMenuItems[0].ACTION) {
                        const actionMenuNames = await handleAction(mainMenuItems[0].ACTION.split('~'), clientId, mainMenuItems[0].MENU_ID, title, selectId, from, Appointment_ID)

                        // Retrieve the first menu item's HEADER_MESSAGE (assuming only one HEADER_MESSAGE for the main menu)
                        let headerMessage = mainMenuItems[0].HEADER_MESSAGE;
                        if (actionMenuNames !== null) {
                            // Extract MENU_NAME items for interactive message
                            const menuNames = actionMenuNames.map(item => ({ id: item.CLIENT_ID + '~' + item.MENU_ID + '~' + item.ITEM_ID + '~' + Appointment_ID + '|' + clientId + '~' + menuId + '~' + selectId, title: item.MENU_NAME }));
                            await sendRadioButtonMessage(from, headerMessage, menuNames);
                            const backmessage = [{
                                id: previousId + '~' + Appointment_ID + '|' + mainMenuItems[0].CLIENT_ID + '~' + mainMenuItems[0].MENU_ID + '~' + mainMenuItems[0].ITEM_ID,
                                title: 'Back'
                            }];
                            await sendBackButtonMessage(from, backmessage);
                        }
                    } else {

                        // Retrieve the first menu item's HEADER_MESSAGE (assuming only one HEADER_MESSAGE for the main menu)
                        const headerMessage = mainMenuItems[0].HEADER_MESSAGE;
                        // Extract MENU_NAME items for interactive message
                        const menuNames = mainMenuItems.map(item => ({ id: item.CLIENT_ID + '~' + item.MENU_ID + '~' + item.ITEM_ID + '~' + Appointment_ID + '|' + clientId + '~' + menuId + '~' + selectId, title: item.MENU_NAME }));
                        await sendRadioButtonMessage(from, headerMessage, menuNames);
                        const backmessage = [{
                            id: previousId + '~' + Appointment_ID + '|' + mainMenuItems[0].CLIENT_ID + '~' + mainMenuItems[0].MENU_ID + '~' + mainMenuItems[0].ITEM_ID,
                            title: 'Back'
                        }];
                        await sendBackButtonMessage(from, backmessage);
                    }

                } catch (error) {
                    console.error("Error fetching main menu:", error);
                    sendWhatsAppMessage(from, "Sorry, an error occurred while fetching the menu.");
                }
            }
            res.sendStatus(200);
        } else {
            res.sendStatus(200);
        }
    } else {
        res.sendStatus(404);
    }
});

// This will be used to store dynamic variables
let dynamicVariables = {};
async function handleAction(iAction, iClientId, iMenuId, iUserValue, iSelectId, from, Appointment_ID) {
    const iLang = 'ENG';
    console.log(`handleAction: iAction:${iAction} ,iClientID:${iClientId} ,iMenuId:${iMenuId}, iUserValue:${iUserValue} iSelectId: ${iSelectId} appointment_id: ${Appointment_ID}`);
    let dynamicVarName;
    if (iUserValue != 'Back') {
        dynamicVarName = iAction[0].split('~')[0];
        dynamicVariables[dynamicVarName] = iUserValue;
        console.log(`${dynamicVarName} = ${dynamicVariables[dynamicVarName]}`);
    } else {
        dynamicVarName = iAction[0].split('~')[0];
        dynamicVariables[dynamicVarName] = dynamicVariables[dynamicVarName];
        console.log(`back : ${dynamicVarName} = ${dynamicVariables[dynamicVarName]}`);
    }
    if (Appointment_ID) {
        if (dynamicVarName === 'Poc_name') {
            await updateAppointment('POC_ID', iSelectId, Appointment_ID);
        } else if (dynamicVarName !== 'Department' && dynamicVarName !== 'Confirm_Status' && dynamicVarName !== 'Emergency_Reason' && dynamicVarName !== 'Appointment_Function') {
            await updateAppointment(iAction[0], dynamicVariables[dynamicVarName], Appointment_ID);
        }
    } 
if(dynamicVarName !== 'Appointment_Function') {
    await updateJsonData(Appointment_ID, dynamicVarName, dynamicVariables[dynamicVarName]);}

    if (iAction[1] === 'LIST') {
        return await getFromList(iClientId, iMenuId, iAction[2], iLang);
    } else if (iAction[1] === 'POC') {
        return await getPocFromPoc(iClientId, iMenuId, dynamicVariables['Department']);
    } else if (iAction[1] === 'FETCH_AVAILABLE_DATES_DIRECT') {
        dynamicVariables['Poc_ID'] = iSelectId;
        return await getAvailableDates(iClientId, iMenuId, iSelectId);
    } else if (iAction[1] === 'FETCH_AVAILABLE_DATES_CHECKUP') {
        let poc_details = await getPocFromPoc(iClientId, iMenuId, dynamicVariables['Appointment_Type']);
        poc_details = poc_details[0];
        dynamicVariables['Poc_ID'] = poc_details.ITEM_ID;
        await updateAppointment('POC_ID',dynamicVariables['Poc_ID'], Appointment_ID);
        console.log(`Poc_ID: ${dynamicVariables['Poc_ID']}`);
        return await getAvailableDates(iClientId, iMenuId, dynamicVariables['Poc_ID']);
    } else if (iAction[1] === 'FETCH_AVAILABLE_TIMES_DIRECT') {
        return await getAvailableTimes(iClientId, iMenuId, iSelectId, dynamicVariables['Appointment_Date']);
    } else if (iAction[1] === 'CONFIRM') {
        let confirmationMessage = await getTemplateMessage(iClientId, iAction[1]);

        // Replace each placeholder with corresponding data
        confirmationMessage = confirmationMessage.replace('[User_Name]', userData.User_Name || '');
        confirmationMessage = confirmationMessage.replace('[User_Email]', userData.User_Email || '');
        confirmationMessage = confirmationMessage.replace('[User_Location]', userData.User_Location || '');
        confirmationMessage = confirmationMessage.replace('[Appointment_Type]', dynamicVariables['Appointment_Type'] || '');
        confirmationMessage = confirmationMessage.replace('[Department]', dynamicVariables['Department'] || '');
        confirmationMessage = confirmationMessage.replace('[POC]', dynamicVariables['Poc_name'] || '');
        confirmationMessage = confirmationMessage.replace('[Appointment_Date]', dynamicVariables['Appointment_Date'] || '');
        confirmationMessage = confirmationMessage.replace('[Appointment_Time]', dynamicVariables['Appointment_Time'] || '');

        // Send confirmation message to user
        await sendWhatsAppMessage(from, confirmationMessage);

        // Create confirmation options with unique placeholders
        const confirmationOptions = [
            { CLIENT_ID: iClientId, MENU_ID: iMenuId, ITEM_ID: 'Confirm', MENU_NAME: 'Confirm' },
            { CLIENT_ID: iClientId, MENU_ID: iMenuId, ITEM_ID: 'Cancel_Appointment_Request', MENU_NAME: 'Cancel Request' }
        ];
        // Return formatted list of options
        return confirmationOptions;
    } else if (iAction[1] === 'FINALIZE') {
        if (iUserValue === 'Confirm') {
            await updateAppointment('Status', 'Confirmed', Appointment_ID);
            await updateAppointment('Is_Active',1,Appointment_ID);
            await updateAvailableSlots(dynamicVariables);
            let finalizeMessage = await getTemplateMessage(iClientId, iAction[1]);
            finalizeMessage = finalizeMessage.replace('[Appointment_ID]', Appointment_ID || '');
            await sendWhatsAppMessage(from, finalizeMessage);
        } else if (iUserValue === 'Cancel Request') {
            let cancel_message = await getTemplateMessage(iClientId, iSelectId);
            await sendWhatsAppMessage(from, cancel_message);
        }
        return null;
    } else if (iAction[1] === 'CONFIRM_EMERGENCY') {
        let confirmationMessage = await getTemplateMessage(iClientId, iAction[1]);

        // Replace each placeholder with corresponding data
        confirmationMessage = confirmationMessage.replace('[User_Name]', userData.User_Name || '');
        confirmationMessage = confirmationMessage.replace('[User_Email]', userData.User_Email || '');
        confirmationMessage = confirmationMessage.replace('[User_Location]', userData.User_Location || '');
        confirmationMessage = confirmationMessage.replace('[Appointment_Type]', dynamicVariables['Appointment_Type'] || '');
        confirmationMessage = confirmationMessage.replace('[Emergency_Reason]', dynamicVariables['Emergency_Reason'] || '');

        // Send confirmation message to user
        await sendWhatsAppMessage(from, confirmationMessage);

        // Create confirmation options with unique placeholders
        const confirmationOptions = [
            { CLIENT_ID: iClientId, MENU_ID: iMenuId, ITEM_ID: 'Confirm', MENU_NAME: 'Confirm' },
            { CLIENT_ID: iClientId, MENU_ID: iMenuId, ITEM_ID: 'Cancel_Appointment_Request', MENU_NAME: 'Cancel Request' }
        ];
        // Return formatted list of options
        return confirmationOptions;
    } else if (iAction[1] === 'FINALIZE_EMERGENCY') {
        if (iUserValue === 'Confirm') {
            await updateAppointment('Status', 'Confirmed', Appointment_ID);
            await updateAppointment('Is_Active',1,Appointment_ID);
            let finalizeMessage = await getTemplateMessage(iClientId, iAction[1]);
            await sendWhatsAppMessage(from, finalizeMessage);
        } else if (iUserValue === 'Cancel Request') {
            let cancel_message = await getTemplateMessage(iClientId, iSelectId);
            await sendWhatsAppMessage(from, cancel_message);
        }
        return null;
    } else if (iAction[1] === 'FINALIZE_TELE') {
        if (iUserValue === 'Confirm') {
            await updateAppointment('Status', 'Confirmed', Appointment_ID);
            await updateAppointment('Is_Active',1,Appointment_ID);
            await updateAvailableSlots(dynamicVariables);
            let finalizeMessage = await getTemplateMessage(iClientId, iAction[1]);
            finalizeMessage = finalizeMessage.replace('[Appointment_ID]', Appointment_ID || '');
            await sendWhatsAppMessage(from, finalizeMessage);
            const meet_link = await getMeetLink(dynamicVariables['Poc_ID']);
            await sendWhatsAppMessage(from, meet_link);
        } else if (iUserValue === 'Cancel Request') {
            let cancel_message = await getTemplateMessage(iClientId, iSelectId);
            await sendWhatsAppMessage(from, cancel_message);
        }
        return null;
    } else if (iAction[1] === 'CONFIRM_CHECKUP') {
        let confirmationMessage = await getTemplateMessage(iClientId, iAction[1]);

        // Replace each placeholder with corresponding data
        confirmationMessage = confirmationMessage.replace('[User_Name]', userData.User_Name || '');
        confirmationMessage = confirmationMessage.replace('[User_Email]', userData.User_Email || '');
        confirmationMessage = confirmationMessage.replace('[User_Location]', userData.User_Location || '');
        confirmationMessage = confirmationMessage.replace('[Appointment_Type]', dynamicVariables['Appointment_Type'] || '');
        confirmationMessage = confirmationMessage.replace('[Appointment_Date]', dynamicVariables['Appointment_Date'] || '');
        confirmationMessage = confirmationMessage.replace('[Appointment_Time]', dynamicVariables['Appointment_Time'] || '');

        // Send confirmation message to user
        await sendWhatsAppMessage(from, confirmationMessage);

        // Create confirmation options with unique placeholders
        const confirmationOptions = [
            { CLIENT_ID: iClientId, MENU_ID: iMenuId, ITEM_ID: 'Confirm', MENU_NAME: 'Confirm' },
            { CLIENT_ID: iClientId, MENU_ID: iMenuId, ITEM_ID: 'Cancel_Appointment_Request', MENU_NAME: 'Cancel Request' }
        ];
        // Return formatted list of options
        return confirmationOptions;
    } else if (iAction[1] === 'FETCH_APPOINTMENT_DETAILS') {  
        const appointmentDetails = await getAppointmentDetailsByUserID(userData.User_ID);  
        console.log(appointmentDetails);  
        if (appointmentDetails && appointmentDetails.length > 0) {  
         const appointments = appointmentDetails.map((appointment, index) => {  
            Appointment_ID=appointment.Appointment_ID;
          return {  
            id: appointment.Appointment_ID,  
            text: `Appointment ID: ${appointment.Appointment_ID},Appointment Type: ${appointment.Appointment_Type}, Date: ${appointment.Appointment_Date}, Time: ${appointment.Appointment_Time}`,  
            cancelOptions: [  
             { CLIENT_ID: iClientId, MENU_ID: iMenuId, ITEM_ID: 'Cancel', MENU_NAME: 'Cancel' },  
             { CLIENT_ID: iClientId, MENU_ID: 0, ITEM_ID: 'Back', MENU_NAME: 'Back' }  
            ]  
          };  
         });  
        
         for (const appointment of appointments) {  
          const cancelItems = appointment.cancelOptions.map(item => ({  
            id: item.CLIENT_ID + '~' + item.MENU_ID + '~' + item.ITEM_ID + '~' + appointment.id + '|' + iClientId + '~' + iMenuId + '~' + iSelectId,  
            title: item.MENU_NAME  
          }));  
          await sendCancelInteractiveMessage(from, appointment.text, cancelItems);  
         }  
        } else {  
         await sendWhatsAppMessage(from, 'No appointment found.');  
        }  
        return null;  
      }else if (iAction[1] === 'FINALIZE_CANCEL') {  
        if (iUserValue === 'Cancel') {  
        await updateAppointment('Status', 'Cancelled', Appointment_ID); 
        await updateAppointment('Is_Active',0,Appointment_ID);
        // Get the POC ID, appointment date, and time from the appointment details  
        const appointmentDetails = await getAppointmentDetailsByAppointmentId(Appointment_ID);  
        dynamicVariables['Poc_ID'] = appointmentDetails[0].POC_ID;  
        dynamicVariables['Appointment_Date'] = appointmentDetails[0].Appointment_Date;  
        dynamicVariables['Appointment_Time'] = appointmentDetails[0].Appointment_Time;  
            console.log(` ${dynamicVariables['Poc_ID']}  ${dynamicVariables['Appointment_Date']} ${dynamicVariables['Appointment_Time']}`);
        // Increase the appointments_per_slot available by one  
        await increaseAvailableSlots(dynamicVariables);
        await sendWhatsAppMessage(from, 'Appointment cancelled successfully.');  
        }
    return null; 
}else {
        console.log('handleAction:inside Else');
    }
}
// Start the server 
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});