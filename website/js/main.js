import {getCognitoCodeFromURL, redirectToCognitoLogin} from "./auth/auth.js";
import {fetchMessages, sendMessage} from "./api/api.js";
import {addOneMessage, updateHeaderWithUsername, updateMessagesUI} from "./ui/ui.js";
import {getCognitoToken, getUsernameFromToken} from "./auth/token.js";
import {signOut} from "./auth/auth.js"

document.addEventListener('DOMContentLoaded', () => {
    const signoutButton = document.querySelector('.signout-button');
    handlePageLoad();
    setupMessageSending();
    if (signoutButton) {
        signoutButton.addEventListener('click', signOut);
    }
});

let lastEvaluatedKey = null;

const scrollContainer = document.querySelector('.content')
if (scrollContainer) {
    scrollContainer.addEventListener('scroll', () => {
        console.log("Défilement dans le conteneur");
        if (scrollContainer.scrollTop + scrollContainer.clientHeight >= scrollContainer.scrollHeight - 300) {
            console.log("Vous avez atteint le bas du conteneur !");
            loadMoreMessages();
        }
    });
}

let isLoadingMoreMessages = false;
let hasMoreMessages = true;

function loadMoreMessages() {
    if (isLoadingMoreMessages || !hasMoreMessages) {
        console.log("c'est true")
        return;
    }

    isLoadingMoreMessages = true;
    const token = localStorage.getItem('jwtToken');
    if (token) {
        const encodedLastKey = lastEvaluatedKey ? encodeURIComponent(JSON.stringify(lastEvaluatedKey)) : '';
        fetchMessages(token, encodedLastKey)
            .then(data => {
                if (data.messages && data.messages.length > 0) {
                    updateMessagesUI(data.messages);
                    lastEvaluatedKey = data.lastEvaluatedKey;
                    if (!data.lastEvaluatedKey) {
                        hasMoreMessages = false;
                    }
                } else {
                    hasMoreMessages = false;
                }
                isLoadingMoreMessages = false;
            })
            .catch(error => {
                console.error('Error loading more messages:', error);
                isLoadingMoreMessages = false;
                localStorage.removeItem('jwtToken');
                redirectToCognitoLogin();
            });
    }
}



function handlePageLoad() {
    const token = localStorage.getItem('jwtToken');
    const cognitoCode = getCognitoCodeFromURL();

    if (cognitoCode) {
        getCognitoToken(cognitoCode)
            .then(fetchedToken => {
                console.log("appele de updataHeaderWithUSername");
                updateHeaderWithUsername();
                return fetchMessages(fetchedToken); // Appel de fetchMessages avec le token récupéré
            })
            .then(data => {
                if (data && data.messages) {
                    updateMessagesUI(data.messages);
                }
            })
            .catch(error => {
                console.error(error);
                redirectToCognitoLogin();
            });
    } else if (token) {
        updateHeaderWithUsername();
        fetchMessages(token)
            .then(data => {
                if (data && data.messages) {
                    updateMessagesUI(data.messages);
                }
            })
            .catch(error => {
                console.error('Error fetching messages:', error);
                localStorage.removeItem('jwtToken');
                redirectToCognitoLogin();
            });
    } else {
        redirectToCognitoLogin();
    }
}

function setupMessageSending() {
    const sendButton = document.querySelector('.message-input button');
    const messageInput = document.querySelector('.message-input textarea');

    sendButton.addEventListener('click', () => {
        const messageText = messageInput.value.trim();
        const token = localStorage.getItem('jwtToken');

        console.log(messageText, getUsernameFromToken() )

        if (messageText && token) {
            sendMessage(token, messageText)
                .then(response => {
                    messageInput.value = '';

                    const newMessage = {
                        user: getUsernameFromToken(), // Remplacez par le nom d'utilisateur actuel si disponible
                        message: messageText,
                        timestamp_utc_iso8601: new Date().toISOString() // Horodatage actuel
                    };

                    addOneMessage([newMessage]);
                })
                .catch(error => {
                    console.error('Error sending message:', error);
                    localStorage.removeItem('jwtToken');
                    redirectToCognitoLogin();
                });
        } else if (!token) {
            redirectToCognitoLogin();
        }
    });
}
