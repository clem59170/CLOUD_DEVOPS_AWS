# Chiffrage des Coûts AWS pour un Blog sur les Abeilles (pourquoi pas ?)

## Contexte
Ce chiffrage concerne un blog de niche pour les fans d'abeilles. Le site compte environ 1000 inscrits, avec 100 visiteurs actifs par jour. Chaque visiteur consulte le site en moyenne 4 fois par jour et poste un message, ce qui représente environ 400 lectures et 100 écritures par jour. C'est donc un petit blog.

## Services AWS Utilisés
Le blog utilise divers services AWS pour son fonctionnement :

- **Amazon S3** : Stockage du code du site et des ressources statiques.
- **Amazon CloudFront** : CDN pour améliorer la vitesse de chargement et la performance et gestion du HTTPS.
- **Amazon DynamoDB** : Base de données pour les données des utilisateurs et les messages du blog.
- **Amazon API Gateway** : Gestion des requêtes HTTP vers les fonctions Lambda.
- **AWS Lambda** : Fonctions pour la publication et la récupération des messages.
- **Amazon Cognito avec Hosted UI** : Gestion des inscriptions et connexions des utilisateurs.

## Estimation des Coûts (Hors Niveau Gratuit AWS)
Les coûts estimés sont basés sur une utilisation standard hors période gratuite AWS.

### Amazon S3
- Stockage : 1 Go.
- Transfert de données : 5 Go/mois.
- **Coût estimé** : Environ 0,39 $/mois.

### Amazon CloudFront
- Transfert de données : 5 Go/mois.
- **Coût estimé** : Aucun coût supplémentaire en dessous de 50 Go/mois.

### Amazon DynamoDB
- Stockage : 5 Go.
- Lectures/Écritures : 400 lectures et 100 écritures par jour.
- **Coût estimé** : Environ 1,25 $/mois.

### AWS Lambda
- Requêtes : 600 requêtes par jour.
- **Coût estimé** : Aucun coût supplémentaire en dessous de 1 million de requêtes/mois.

### Amazon API Gateway
- Requêtes : 600 requêtes par jour.
- **Coût estimé** : Aucun coût supplémentaire en dessous de 1 million de requêtes/mois.

### Amazon Cognito
- Utilisateurs actifs : 100 par mois.
- **Coût estimé** : Aucun coût supplémentaire en dessous de 50 000 utilisateurs actifs/mois.

## Total des Coûts Mensuels Estimés
- **Amazon S3** : 0,39 $
- **Amazon CloudFront** : 0,00 $
- **Amazon DynamoDB** : 1,25 $
- **AWS Lambda** : 0,00 $
- **Amazon API Gateway** : 0,00 $
- **Amazon Cognito** : 0,00 $

**Total Estimé** : Environ 1,64 $ par mois. (C'est vraiment peu coûteux, ai-je peut-être mal calculé ? ?)

## Source
Les tarifs mentionnés sont basés sur les tarifs AWS standards au moment de la rédaction de ce document. cf [site officiel AWS Pricing](https://aws.amazon.com/pricing/).