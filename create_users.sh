#!/bin/bash

userPoolId="eu-west-1_MUtLef28e"  # Remplacez par votre User Pool ID

# Création de 5 utilisateurs (ajustez le nombre selon vos besoins)
# shellcheck disable=SC1009
for i in {1..5}; do
    userName="user$i"
    userEmail="user$i@example.com"
    userPassword="YourPassword123!"  # Définissez un mot de passe conforme à vos politiques de sécurité

    # Commande pour créer un utilisateur
    # shellcheck disable=SC1073
    aws cognito-idp admin-create-user \
        --profile imt \
        --user-pool-id $userPoolId \
        --username $userName \
        # shellcheck disable=SC1126
        # shellcheck disable=SC2140
        --user-attributes Name="email",Value="$userEmail" \
        --temporary-password $userPassword

    # Commande pour confirmer l'inscription de l'utilisateur (si nécessaire)
    aws cognito-idp admin-set-user-password \
        --profile imt \
        --user-pool-id $userPoolId \
        --username $userName \
        --password $userPassword \
        --permanent
done
