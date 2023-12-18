#!/bin/bash

# Remplacez ces valeurs par vos informations
# shellcheck disable=SC2034
USER_POOL_ID="eu-west-1_MUtLef28e"
CLIENT_ID="4c06626ubqqkt8ceme9mmqjmfa"
USERNAME="user1"
PASSWORD="YourPassword123!"

# Obtention d'un jeton d'authentification en utilisant le secret client
authResult=$(aws cognito-idp initiate-auth --profile imt \
    --client-id $CLIENT_ID \
    --auth-flow USER_PASSWORD_AUTH \
    --auth-parameters USERNAME=$USERNAME,PASSWORD=$PASSWORD \
    --query "AuthenticationResult.IdToken" \
    --output text)

echo "Token JWT : $authResult"
