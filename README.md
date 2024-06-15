# MINI PROJET GITLAB

Ce mini projet est dans le cadre du bootcamp Devops de Eazytraing

**Nom** : AUGET

**Prénom** : Rabina

**Pour la promotion 19 du Bootcamp DevOps**

**Période** : Mai - Juin - Juillet 2024

**Date de réalisation**: 15 Juin 2024

**LinkedIn** : www.linkedin.com/in/auget-rabina-61663314a

# Contexte du projet

Ce projet a pour objectif de mettre en place un pipeline CI/CD (Intégration Continue et Déploiement Continu) afin d'automatiser le processus de livraison et de déploiement d'une application. 

Le pipeline sera déclenché à chaque push de code dans le repo GitLab, garantissant ainsi, que les nouvelles modifications sont automatiquement construits (phase de build), testées, intégrées et déployées sur les serveurs de Test (Staging) et de Production.

# Fonctionnement du pipeline

Le pipeline CI/CD sera structuré en plusieurs étapes clés:

1. **La phase de Build :** consistera à la compilation du code source et construction des artefacts nécessaires pour le déploiement.

2. **La phase de Test de l'artifact (Test d'acceptance) :** sera la partie où nous allons tester et confirmer que l'artifact précédement créée est bien fonctionnel.

3. **La phase de sauvegarde de l'image (Release image) :** Après avoir confirmer que l'artéfact est bien fonctionnel, nous allons le sauvegarder afin de pouvoir le déployer sur les serveurs tests/prod ou le réutiliser ultérieurement.

4. **La phase de déploiement sur le serveur Test (Staging) :** sera la partie où nous allons effectuer le déploiement sur le serveur test. Cela va permettre de tester l'application par exemple.

5. **La phase de révision (Deploy Review) :** L'application, après avoir été testée et validée, doit être déployée en production. Mais avant cela, elle passera par une phase de révision pour s'assurer qu'elle fonctionne correctement et sans erreurs.

6. **La phase de déploimeent sur le serveur Prod :** L'application, ayant été confirmée comme fonctionnelle à toutes les étapes, peut maintenant être déployée sur l'environnement de production pour être utilisée par les clients.

# Application: 

Donc le pipeline sera composé de:

+ **Le dossier webapp :** va contenir les fichiers du code source de l'application.
+ **Le fichier .gitlab-ci.yml :** où nous allons décrire toutes les étapes du pipeline CI/CD.
+ **Le fichier Dockerfile :** nous servira à créer l'image docker de notre application pour pouvoir le conteneuriser.

# Infrastructure:

Nous allons utiliser les technologies ci-dessous:

+ **Physical host :** Windows 11
+ **Gitlab :** Nous allons utiliser le gitlab public, accessible sur https://gitlab.com/
+ **Runner :** Et pour le runner, nous allons utiliser les runners de Gitlab car Gitlab fourni déjà toutes sortes de runners. Pour ce projet, nous allons utiliser Docker DinD (Docker in Docker)
+ **Heroku :** Et pour déployer notre application, nous allons le déployer sur Heroku qui est une plateforme de déploiement d'application (https://www.heroku.com/)

# Préparation de l'environnement:

1. Pour commencer, nous allons créer un projet/repository sur Gitlab avec le +:

2. Nous allons maintenant être rediriger vers l'interface de création du nouveau projet. On a le choix de choisir:

+ de créer un noveau projet vièrge
+ de créer à partir d'un template
+ d'importer un projet depuis un repo externe comme GitHub/Bitbucket ou autre
+ soit de connecter gitlab à un repo externe

3. Mais étant donné que j'ai déjà téléchargé le code source sur mon ordinateur local depuis GitHub car j'ai voulu organiser mes fichiers, je vais créer un nouveau projet vièrge.

4. Il faut maintenant spécifier le nom du projet et mettre le projet en public. Pour les autre options qui sont optionnelles, je les laisse comme tels.

5. Nous allons copier le lien du repo via le `Clone with HTTPS`

6. Et sur notre ordinateur local, nous allons naviguer dans le répertoire où nous souhaitons mettre projet et une fois le projet cloner, on se déplace dans le dossier.

7. Pour ma part, je copie maintenant le dossier `webapp` qui contient les fichiers du code source et je créé les fichiers `Dockerfile` et le fichier `.gitlab-ci.yml`.

8. Je pousse maintenant les fichiers sur mon repos comme ceci:

    + git add .
    + git commit -m "First commit"
    + git push origin main

# Phase de build: 

Après avoir créé le fichier `Dockerfile` et le fichier `.gitlab-ci.yml`. 
