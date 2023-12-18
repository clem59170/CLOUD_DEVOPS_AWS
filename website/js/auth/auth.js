
export function getCognitoCodeFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get('code');
}

export function redirectToCognitoLogin() {
    const cognitoLoginUrl = 'https://cyclone-auth.auth.eu-west-1.amazoncognito.com/login?response_type=code&client_id=4c06626ubqqkt8ceme9mmqjmfa&redirect_uri=https://d1mhyz71pk3h10.cloudfront.net';
    window.location.href = cognitoLoginUrl;
}

export function clearCodeFromURL() {
    const urlWithoutCode = window.location.href.split('?')[0];
    window.history.replaceState({}, document.title, urlWithoutCode);
}

export function signOut() {
    localStorage.clear();

    const cognitoDomain = 'cyclone-auth.auth.eu-west-1.amazoncognito.com'; // Remplacez par votre domaine Cognito
    const clientId = '4c06626ubqqkt8ceme9mmqjmfa'; // Remplacez par votre Client ID
    const redirectUri = encodeURIComponent('https://d1mhyz71pk3h10.cloudfront.net');

    const logoutUrl = `https://${cognitoDomain}/logout?client_id=${clientId}&logout_uri=${redirectUri}`;

    window.location.href = logoutUrl;
}

