
export function fetchMessages(token, lastEvaluatedKey = null) {
    const apiEndpoint = `https://vol4t63zn8.execute-api.eu-west-1.amazonaws.com/prod/fetch-messages?lastKey=${lastEvaluatedKey}`;

    return fetch(apiEndpoint, {
        headers: new Headers({
            'Authorization': `Bearer ${token}`
        })
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok.');
            }
            return response.json();
        });
}


export function sendMessage(token, message) {
    const apiEndpoint = 'https://vol4t63zn8.execute-api.eu-west-1.amazonaws.com/prod/post-message';
    console.log("sendmessage "+token);
    return fetch(apiEndpoint, {
        method: 'POST',
        headers: new Headers({
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json'
        }),
        body: JSON.stringify({ message: message })
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok.');
            }
            return response.json();
        });
}



