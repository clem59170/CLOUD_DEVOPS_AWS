#!/bin/bash

# Configuration des variables
CLIENT_ID="4c06626ubqqkt8ceme9mmqjmfa"
CLIENT_SECRET=""  # Remplacez ceci par votre client secret
REDIRECT_URI="https://d1mhyz71pk3h10.cloudfront.net"

# URL du serveur Cognito
COGNITO_TOKEN_ENDPOINT="https://cyclone-auth.auth.eu-west-1.amazoncognito.com/oauth2/token"

# Demande du code d'autorisation
echo -n "Entrez le code d'autorisation: "
read AUTH_CODE

# Encodage en Base64 des identifiants client
ENCODED_CREDENTIALS=$(echo -n "$CLIENT_ID:$CLIENT_SECRET" | base64)
echo "$ENCODED_CREDENTIALS" | base64 --decode

# Requête POST pour obtenir le token
curl --http1.1 --location --request POST "$COGNITO_TOKEN_ENDPOINT" \
--header "Authorization: Basic $ENCODED_CREDENTIALS" \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode "grant_type=authorization_code" \
--data-urlencode "client_id=$CLIENT_ID" \
--data-urlencode "redirect_uri=$REDIRECT_URI" \
--data-urlencode "code=$AUTH_CODE"

