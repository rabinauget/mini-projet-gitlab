# MINI PROJET GITLAB

Ce mini projet est dans le cadre du bootcamp Devops de Eazytraing

Nom : AUGET

Prénom : Rabina

Pour la promotion 19 du Bootcamp DevOps

Période : Mai - Juin - Juillet 2024

Date de réalisation: 15 Juin 2024

LinkedIn : www.linkedin.com/in/auget-rabina-61663314a

# CONTEXT DU PROJET

Ce projet a pour objectif de mettre en place un pipeline CI/CD (Intégration Continue et Déploiement Continu) afin d'automatiser le processus de livraison et de déploiement d'une application. 

Le pipeline sera déclenché à chaque push de code dans le repo GitLab, garantissant ainsi, que les nouvelles modifications sont automatiquement construits (phase de build), testées, intégrées et déployées sur les serveurs de Test (Staging) et de Production.

# FONCTIONNEMENT DU PIPELINE

Le pipeline CI/CD sera structuré en plusieurs étapes clés:

1. La phase de Build: qui consistera à la compilation du code source et construction des artefacts nécessaires pour le déploiement.

2. La phase de Test de l'artifact (Test d'acceptance): qui sera la partie où nous allons tester et confirmer que l'artifact précédement créée est bien fonctionnel.

3. La phase de sauvegarde de l'image (Release image) : Après avoir confirmer que l'artéfact est bien fonctionnel, nous allons le sauvegarder afin de pouvoir le déployer sur les serveurs tests/prod ou le réutiliser ultérieurement.

4. La phase de déploiement sur le serveur Test: ça sera la partie où nous allons effectuer le déploiement sur le serveur test. Cela va permettre de tester l'application par exemple.

5. La phase de révision: Après que l'application a été testé et confirmer, il va falloir le pousser vers la prod; mais avant cela, on va faire passer l'application dans une phase de révision afin de confirmer que l'application est bien fonctionnelle et sans erreur.

6. La phase de déploimeent sur le serveur Prod: L'application étant bien fonctionnelle confirmer par toutes ces étapes, elle peut maintenant être déployer sur l'environnement de prod afin que les clients puissent le consommer.

# APPLICATION

Donc le pipeline sera composé de:

+ le dossier webapp: qui va contenir les fichiers du code source de l'application
+ le fichier .gitlab-ci.yml: où nous allons décrire toutes les étapes du pipeline CI/CD
+ le fichier Dockerfile: qui nous servira à créer l'image docker de notre application pour pouvoir le conteneuriser

# Infrastructure:

Nous allons utiliser les technologies ci-dessous:

+ Physical host: Windows 11
+ Gitlab: nous allons utiliser le gitlab public accessible sur https://gitlab.com/
+ Et pour le runner, nous allons utiliser les runners de Gitlab car Gitlab fourni déjà toutes sortes de runners. Pour ce projet, nous allons utiliser Docker DinD (Docker in Docker)
+ Et pour déployer notre application, nous allons le déployer sur Heroku

