# MINI PROJET GITLAB

Ce mini projet est dans le cadre du bootcamp Devops de Eazytraing

**Nom** : AUGET

**Prénom** : Rabina

**Pour la promotion 19 du Bootcamp DevOps**

**Période** : Mai - Juin - Juillet 2024

**Date de réalisation**: 15 Juin 2024

**LinkedIn** : www.linkedin.com/in/auget-rabina-61663314a

# Contexte du projet

Ce projet vise à implémenter un pipeline CI/CD (Intégration Continue et Déploiement Continu) pour automatiser et optimiser le processus de livraison et de déploiement d'une application. Réduisant ainsi les erreurs manuelles, accélérant les mises à jour, et garantissant une intégration fluide et cohérente à chaque étape. Et surtout, cela renforcera la collaboration entre les équipes de développement et d'opérations.

Le pipeline se déclenchera à chaque push de code vers le dépôt GitLab, garantissant que les nouvelles modifications sont automatiquement compilées, testées, intégrées, puis déployées sur les serveurs de Test (Staging) et de Production.

# Fonctionnement du pipeline

Le pipeline CI/CD sera structuré en plusieurs étapes clés:

1. **La phase de Build :** consistera à la compilation du code source et construction des artefacts nécessaires pour le déploiement.

2. **La phase de Test de l'artifact (Test d'acceptation) :** sera la partie où nous allons tester et confirmer que l'artéfact précédement créé est bien fonctionnel.

3. **La phase de sauvegarde de l'image (Release image) :** Après avoir confirmer que l'artéfact est fonctionnel, nous allons le sauvegarder afin de pouvoir le déployer sur les serveurs tests/prod ou le réutiliser ultérieurement.

4. **La phase de déploiement sur le serveur Test ( Deploy staging) :** Cette étape concerne le déploiement sur le serveur de test. Si des erreurs surviennent dans la chaîne de déploiement, elles seront détectées avant le déploiement sur le serveur de production. Mais on pourra également en profiter pour effectuer des tests sur les fonctionnalités de l'application.

5. **La phase de révision (Deploy Review) :** Une fois confirmée qu'il n'y a pas de problème dans la chaîne, l'application doit être déployée en production. Cependant, avant cela, elle passera par une phase de révision pour s'assurer que l'application est bien fonctionnelle et accessible.

6. **La phase de déploimeent sur le serveur Prod :** L'application, ayant été confirmée comme fonctionnelle à toutes les étapes, peut maintenant être déployée sur l'environnement de production pour être utilisée par les clients.

# Application

Donc le pipeline sera composé de:

+ **Le dossier webapp :** va contenir les fichiers du code source de l'application.
+ **Le fichier .gitlab-ci.yml :** où nous allons décrire toutes les étapes du pipeline CI/CD.
+ **Le fichier Dockerfile :** nous servira à créer l'image docker de notre application pour pouvoir le conteneuriser.

# Infrastructure

Nous allons utiliser les technologies ci-dessous:

+ **Hôte physique :** Windows 11 avec un CPU intel core i7-8ème 2.1GHz et 16GB RAM
+ **Gitlab :** Nous allons utiliser le gitlab public, accessible sur https://gitlab.com/
+ **Runner :** Et pour le runner, nous allons utiliser les runners de Gitlab car Gitlab fourni déjà toutes sortes de runners. Pour ce projet, nous allons utiliser Docker DinD (Docker in Docker)
+ **Heroku :** Et pour déployer notre application, nous allons le déployer sur Heroku qui est une plateforme de déploiement d'application (https://www.heroku.com/)

# Préparation de l'environnement

1. Pour commencer, nous allons créer un projet/repository sur Gitlab avec le +:

![plus-for-create-project](../capture/1-1-prep-env-plus.png)

2. Nous allons maintenant être rediriger vers l'interface de création du nouveau projet. On aura plusieurs choix, mais étant donné que j'ai déjà téléchargé le code source sur mon ordinateur local depuis GitHub car j'ai voulu organiser mes fichiers, je vais créer un nouveau projet vièrge.

![create-project](../capture/1-2-prep-env-create-project.png)

3. Il faut maintenant spécifier le nom du projet et mettre le projet en public. Pour les autre options qui sont optionnelles, je vais les laisser comme tels et je clique sur `Create project`.

![create-project-form](../capture/1-3-prep-env-create-project-form.png)

4. Une fois le projet créée, nous allons copier le lien du repo via le bouton en bleu `Code` et choisir la méthode `Clone with HTTPS` en cliquant sur l'icône presse papier à côté de l'URL.

![clone-https](../capture/1-4-prep-env-clone-https.png)

5. Et sur mon ordinateur local, je vais naviguer vers le répertoire où j'ai mis le project. 

    + Ensuite, ajouter le repo gitlab que je viens de créer comme repo distant et son nom d'identification sera `origin` : 
    
    `git remote add origin https://gitlab.com/skynet17/mini-projet-gitlab.git`

    + Puis, renommer la branche par défaut où je me trouve actuellement en `main`: `git branch -M main`
    + Enfin, il est temps de pousser les fichiers du code sources vers le repo distant `origin` et sous la branche `main`: `git push -uf origin main`

6. J'ai terminé de créer le fichier `Dockerfile` et `.gitlab-ci.yml` sur mon ordinateur local donc je vais maintenant pouvoir les pousser vers Gitlab sous la branche main comme suit:

    + `git add .`
    + `git commit -m "First commit"`
    + `git push origin main`

# Phase de build

1. Après avoir terminer le push des fichiers, on peut remarquer cet icône qui nous indique qu'un pipeline est en cours d'execution. Il s'est lancé automatiquement après l'action push. Mais on verra par la suite comment le déclencher après un évènement spécifique.

![pipeline-running](../capture/2-1-phase-build-pipeline-running.png)

2. Si on patiente un peu, cet icône va passer en vert pour nous indiquer que le pipeline s'est bien déroulé avec succès. Mais on peut aussi aller dans la barre latérale gauche dans `Build` > `Pipeline` pour voir la liste de tous les pipelines en cours ou ceux qui sont déjà terminé. Comme notre fichier `.gitlab-ci.yml` ne contient pour l'instant que la partie `docker-build`, il n'y a qu'un seul stage sur la partie `Stages`. On peut cliquer sur l'icône en vert pour voir quelle partie des jobs déclarés dans le fichier sont en cours d'execution.

![2-2-phase-build-pipeline-list-state.png](../capture/2-2-phase-build-pipeline-list-state.png)

3. Si on clique sur `docker-build`, on sera redirigé vers la console qui où nous pourrions voir tous les étapes du build: Depuis la génération du container Dind jusqu'au statut finale `succeeded`, nous indiquant que le job s'est terminé sans erreur. S'il y a erreur, on verra un `failed` en rouge.

![2-3-phase-build-job-succeeded.png](../capture/2-3-phase-build-job-succeeded.png)

4. **Sur GitLab, à chaque job, un conteneur est créé puis supprimé une fois le job terminé.** C'est pourquoi, dans notre fichier de pipeline `gitlab-ci.yml`, nous sauvegardons l'image Docker sous forme d'artéfact pour qu'il soit disponible pour les jobs suivants. On peut vérifier que l'artéfact a bien été sauvegardé dans `Build` > `Artifact` et la référence du commit de l'artfifact correspond bien à la référence du commit de notre pipeline `2ef8da8b`. Ou bien depuis la liste des pipelines, on peut aussi cliquer sur l'icône de téléchargement pour voir la liste des artéfacts construits et cliquer sur l'un d'eux pour directement le télécharger. Mais on peut également le télécharger depuis `Build` > `Artifact`.

**Capture dans `Build` > `Artifact`**

![2-4-phase-build-artifact-list.png](../capture/2-4-phase-build-artifact-list.png)

**Capture dans `Build` > `Pipeline`**

![2-4-phase-build-artifact-download.png](../capture/2-4-phase-build-artifact-download.png)

5. Si on regarder le contenu de l'artéfact, il contient 3 fichiers 
   + **`artifacts.zip` :** qui contient l'image docker .tar
   + **`metadata.gz` :** les metadonnés de l'artéfact: nom de l'image, le droit du système sur le fichier, le crc pour la sécurité du fichier, la taille de l'image
   + **`job.log`:** les logs du pipeline que nous avons vu sur la partie 4.

![2-5-phase-build-artifact-content.png](../capture/2-5-phase-build-artifact-content.png)

6. Mais si on clique sur l'icône du dossier de l'artéfact dans `Build` > `Artifact`, on verra le nom de l'artéfact que nous avons spécifié dans `.gitlab-ci.yml`.

**Capture de l'icône du dossier**

![2-6-phase-build-artifact-directory.png](../capture/2-6-phase-build-artifact-directory.png)

**Capture du nom de l'artefact**

![2-6-phase-build-artifact-name-gitlab-ci.png](../capture/2-6-phase-build-artifact-name-gitlab-ci.png)

Donc maintenant, nous pouvons passer à la phase de test d'acceptation.

# Phase de test d'acceptation

Dans cette section, nous utiliserons l'artéfact généré lors de la phase de build pour créer un conteneur Docker et vérifier que notre application web fonctionne correctement. On peut voir à la ligne 37 comment charger cet artéfact dans le conteneur pour la phase d'acceptation. 

Etant donné que nous avons confirmer que l'artéfact est bien présent dans `Build` > `Artifact` puis ajouté la section **test d'acceptation** dans le fichier `gitlab-ci.yml`, on peut maintenant faire un push du repo local vers le repo distant gitlab.

1. Une fois le push effectué, on peut voir dans la liste des pipelines (`Build` > `Pipeline`) qu'un nouveau pipeline est en cours d'execution et on remarquera que la partie `Stages` contient maintenant deux jobs: le premier est celui de la phase de build et le deuxième pour la phase d'acceptation. Si on clique sur la référence du pipeline, on est redirigé vers une page qui va nous afficher les détails concernant ce pipeline et les différents `Stages`.

**Capture du nouveau pipeline:**

![3-1-1-phase-acceptance-new-job.png](../capture/3-1-1-phase-acceptance-new-job.png)

**Capture des détails du pipeline:**

![3-1-2-phase-acceptance-job-name.png](../capture/3-1-2-phase-acceptance-job-name.png)

2. Maintenant, on peut faire un clique sur le test d'acceptation pour voir la console du job en question. On peut constater ici que le job s'est bien déroulé puisque nous avons le code de retour `200` et `Succeeded` comme retour.

![3-2-phase-acceptance-console.png](../capture/3-2-phase-acceptance-console.png)

# Release image

Nous avons validé le bon fonctionnement de l'image. Maintenant, nous allons la versionner pour assurer squ'il soit réutilisable, garantir la traçabilité des mises à jour et faciliter son déploiement cohérent à travers différents environnements. Cela permet également un retour facile à une version précédente en cas de besoin et une meilleure gestion des versions dans les pipelines CI/CD.

1. Pour ce faire, il faudra d'abord déclarer les variables dans la bare latérale gauche `Settings > CI/CD > Variables`.

    + la première sera la clé API de mon compte HEROKU sur https://dashboard.heroku.com/account (Mon compte > Account Settings > API Key)
    + et la deuxième le nom de l'image `registry.gitlab.com/skynet17/mini-projet-gitlab/mini_projet_gitlab`, où la première partie est le serveur sur lequel se trouve le registry de gitlab, puis mon espace à mois, ensuite le projet sur lequel je travail et enfin le nom de mon image

![4-1-release-image-variable.png](../capture/4-1-release-image-variable.png)

2. Nous pouvons désormais effectuer un push de notre code après avoir ajouté la section `Release image` dans notre fichier `.gitlab-ci.yml` et le pipeline va se lancer aussitôt. On vera donc dans la liste des pipelines qu'un nouveau pipeline est en cours d'éxecution et cette fois ci, il y aura trois stages. Et comme d'habitude, on peut cliquer sur la référence du pipeline pour voir le détails du pipeline:

**Capture dans liste des pipelines**

![4-2-release-image-pipeline.png](../capture/4-2-release-image-pipeline.png)

**Capture des détails du pipeline**

![4-3-release-image-job-stage.png](../capture/4-3-release-image-job-stage.png)

# Deploy staging