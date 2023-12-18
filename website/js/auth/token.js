import {clearCodeFromURL} from "./auth.js";

export function getCognitoToken(code) {
    const clientId = '4c06626ubqqkt8ceme9mmqjmfa'; // Remplacez par votre Client ID
    const clientSecret = 'o462a44c8ee9midr4cidekkq3tf2f1b08tpr53bpdriij2bn2q6'; // Remplacez par votre Client Secret
    const redirectUri = 'https://d1mhyz71pk3h10.cloudfront.net';
    const cognitoDomain = 'cyclone-auth.auth.eu-west-1.amazoncognito.com';

    const tokenUrl = `https://${cognitoDomain}/oauth2/token`;

    const headers = new Headers();
    headers.append('Content-Type', 'application/x-www-form-urlencoded');
    const basicAuth = btoa(`${clientId}:${clientSecret}`);
    headers.append('Authorization', `Basic ${basicAuth}`);

    const body = new URLSearchParams();
    body.append('grant_type', 'authorization_code');
    body.append('redirect_uri', redirectUri);
    body.append('code', code);

    return fetch(tokenUrl, {
        method: 'POST',
        headers: headers,
        body: body
    })
        .then(response => response.json())
        .then(data => {
            if (data.id_token) {
                console.log('JWT Token:', data.id_token);
                localStorage.setItem('jwtToken', data.id_token); // Stockage du token
                clearCodeFromURL(); // Nettoyer le code de l'URL
                return data.id_token;
            } else {
                // Gérer l'erreur de connexion
                throw new Error('Error fetching JWT token');
            }
        })
        .catch(error => {
            console.error('Error fetching JWT token:', error);
        });
}


function parseJwt(token) {
    try {
        const base64Url = (segment) => segment.replace(/-/g, '+').replace(/_/g, '/');
        const base64Decode = (str) => decodeURIComponent(atob(str).split('').map((c) => {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));

        const parts = token.split('.');
        if (parts.length !== 3) {
            throw new Error('Le JWT est incorrect, il doit contenir exactement 3 segments');
        }

        return JSON.parse(base64Decode(base64Url(parts[1])));
    } catch (e) {
        console.error('Erreur lors du décodage du JWT:', e);
        return null;
    }
}

export function getUsernameFromToken() {
    const idToken = localStorage.jwtToken;
    console.log(idToken);
    if (!idToken) return null;

    try {
        const decodedToken = parseJwt(idToken);
        console.log(decodedToken);
        return decodedToken['cognito:username'] || decodedToken['username'];
    } catch (error) {
        console.error('Error decoding token:', error);
        return null;
    }
}


