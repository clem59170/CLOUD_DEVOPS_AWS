import {getUsernameFromToken} from "../auth/token.js";

export function updateMessagesUI(newMessages) {
    const messagesContainer = document.querySelector('.guest-book');

    newMessages.forEach(message => {
        const messageElement = document.createElement('div');
        messageElement.className = 'message';
        messageElement.innerHTML = `
            <div class="profile-picture">
                <img src="../../img.png" alt="Profile Picture">
            </div>
            <div class="message-content">
                <h3 class="author">${message.user}</h3>
                <span class="timestamp">${new Date(message.timestamp_utc_iso8601).toLocaleString()}</span>
                <p class="message-text">${message.message}</p>
            </div>
        `;
        messagesContainer.appendChild(messageElement);
    });
}


export function updateHeaderWithUsername() {
    const username = getUsernameFromToken();
    console.log(username);
    const usernameElement = document.querySelector('#username');

    if (!usernameElement) {
        return null;
    }
    if (!username) {
        return null;
    }

    usernameElement.textContent = username;
}

export function addOneMessage(newMessages) {
    const messagesContainer = document.querySelector('.guest-book');

    if (newMessages.length > 0) {
        const message = newMessages[0]; // Accéder au premier élément du tableau
        const messageElement = document.createElement('div');
        messageElement.className = 'message';
        messageElement.innerHTML = `
            <div class="profile-picture">
                <img src="../../img.png" alt="Profile Picture">
            </div>
            <div class="message-content">
                <h3 class="author">${message.user}</h3>
                <span class="timestamp">${new Date(message.timestamp_utc_iso8601).toLocaleString()}</span>
                <p class="message-text">${message.message}</p>
            </div>
        `;

        messagesContainer.prepend(messageElement);
    }
}

