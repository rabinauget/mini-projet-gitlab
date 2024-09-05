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

1. **La phase de Build :** consistera à la compilation du code source et construction des artéfacts nécessaires pour le déploiement.

2. **La phase de Test de l'artifact (Test d'acceptation) :** sera la partie où nous allons tester et confirmer que l'artéfact précédement créé est bien fonctionnel.

3. **La phase de sauvegarde de l'image (Release image) :** Après avoir confirmer que l'artéfact est fonctionnel, nous allons le sauvegarder afin de pouvoir le déployer sur les serveurs tests/prod ou le réutiliser ultérieurement.

4. **La phase de déploiement sur le serveur Test ( Deploy staging) :** Cette étape concerne le déploiement sur le serveur de test. Si des erreurs surviennent dans la chaîne de déploiement, elles seront détectées avant le déploiement sur le serveur de production. Mais on pourra également en profiter pour effectuer des tests sur les fonctionnalités de l'application.

5. **La phase de révision (Deploy Review) :** Une fois confirmée qu'il n'y a pas de problème dans la chaîne, l'application doit être déployée en production. Cependant, avant cela, elle passera par une phase de révision pour s'assurer que l'application est bien fonctionnelle et accessible.

6. **La phase de déploimeent sur le serveur Prod :** L'application, ayant été confirmée comme fonctionnelle à toutes les étapes, peut maintenant être déployée sur l'environnement de production pour être utilisée par les clients.

# Application

Donc le pipeline sera composé de:

+ **Le fichier .gitlab-ci.yml :** où nous allons décrire tous les étapes du pipeline CI/CD.
+ **Le fichier Dockerfile :** nous servira à créer l'image docker de notre application pour pouvoir le conteneuriser.
+ **nginx.conf :** vu qu'on va utiliser nginx comme serveur web dans le container, ce fichier sera son fichier de configuration.
+ Le code source sera télécharger depuis le repos github directement dans l'image docker: https://github.com/diranetafen/static-website-example.git

# Infrastructure

Nous allons utiliser les technologies ci-dessous:

+ **Hôte physique :** Windows 11 avec un CPU intel core i7-8ème 2.1GHz et 16GB RAM
+ **Gitlab :** Nous allons utiliser le gitlab public, accessible sur https://gitlab.com/
+ **Runner :** Et pour le runner, nous allons utiliser les runners de Gitlab car Gitlab fourni déjà toutes sortes de runners. Pour ce projet, nous allons utiliser Docker DinD (Docker in Docker)
+ **Heroku :** Et pour déployer notre application, nous allons le déployer sur Heroku qui est une plateforme de déploiement d'application (https://www.heroku.com/)

# Préparation de l'environnement

1. Pour commencer, nous allons créer un projet/repository sur Gitlab avec le +:

![plus-for-create-project](../capture/1-1-prep-env-plus.png)

2. Nous allons maintenant être rediriger vers l'interface de création du nouveau projet. On aura plusieurs choix mais je vais créer un nouveau projet vièrge.

![create-project](../capture/1-2-prep-env-create-project.png)

3. Il faut maintenant spécifier le nom du projet et mettre le projet en public afin de pouvoir partager le projet. Pour les autre options qui sont optionnelles, je vais les laisser comme tels et je clique sur `Create project`.

![create-project-form](../capture/1-3-prep-env-create-project-form.png)

4. Une fois le projet créée, copier le lien du repo via le bouton en bleu `Code` et choisir la méthode `Clone with HTTPS` en cliquant sur l'icône presse papier à côté de l'URL.

![clone-https](../capture/1-4-prep-env-clone-https.png)

5. Et sur mon ordinateur local, je vais me positionner vers le répertoire où j'ai mis le project. 

    + Ensuite, ajouter le repo gitlab nouvellement créer comme repo distant et son nom d'identification sera `origin` : 
    
    `git remote add origin https://gitlab.com/skynet17/mini-projet-gitlab.git`

    + Puis, renommer la branche par défaut en `main`: `git branch -M main`
    + J'ai terminé de créer le fichier `Dockerfile` et `.gitlab-ci.yml` sur mon ordinateur local donc je vais  maintenant pouvoir les pousser vers Gitlab sous la branche main comme suit:

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

1. Maintenant, nous allons d'abord deployer l'application sur un environnement de staging puis une fois validée qu'il n'y a pas de souci, nous allons déployer sur l'environnement de prod. Mais avant cela, nous allons créer une nouvelle branche `staging`. Nous verrons par la suite comment faire pour déployer sur la prod avec la branche `main` à l'aide d'un `merge request`.

Pour cela, nous allons utiliser les commandes ci-dessous:

    + `git -checkout -b staging`: pour créer la branche et dont le nom sera `staging`
    + `git add .`: pour valider la modification
    + `git commit -m "add branch staging"`: pour mettre une petitie note sur l'action
    + `git push -u origin staging`: pour pousser les modifications vers le repo distant

Et si on regarde notre repo distant (sur Gitlab), on verra une nouvelle branche au nom de `staging` et nous aurions également tous les fichiers qui étaient dans la branche `main`:

![5-1-staging-create-branch.png](../capture/5-1-staging-create-branch.png)

2. On peut voir que le pipeline s'est déjà lancé au push des modifications et cette fois, nous avons quatre stages qui vont se lancer l'un après l'autre.

**Capture depuis pipeline:**

![5-2-staging-create-branch-pipeline.png](../capture/5-2-staging-create-branch-pipeline.png)

**Details du pipeline:**

![5-2-staging-create-branche-pipeline-details.png](../capture/5-2-staging-create-branche-pipeline-details.png)

3. L'éxecution des pipelines étant terminé, nous allons maintenant pouvoir vérifier le lien de notre application en staging sur Heroku:

**Capture depuis la barre latérale gauche `Operate > Environments > Open`:**

![5-3-staging-open-url-staging.png](../capture/5-3-staging-open-url-staging.png)

**Capture de l'application:**

![5-3-staging-check-url-staging.png](../capture/5-3-staging-check-url-staging.png)

# Test Staging

Nous avons confirmé que l'application est accessible via son URL de staging en la vérifiant manuellement. Cependant, l'objectif d'un pipeline CI/CD est d'automatiser les processus sans intervention manuelle. C'est pourquoi cette étape est incluse, afin d'automatiser la vérification et la validation.

1. Après avoir ajouté cette section dans le fichier .gitlab-ci.yml et fait un push des modifications vers le repo distant, le pipeline s'est lancé automatiquement avec maintenant cinq stages, mais cette fois-ci, j'ai mis un paramètre `only on staging` pour que le pipeline ne se lance que si on fait un push vers la branche `staging`. 

**Capture du pipeline:**

![6-1-test-stagine-pipeline.png](../capture/6-1-test-stagine-pipeline.png)

**Capture du détails du pipeline:**

![6-1-test-stagine-pipeline-details.png](../capture/6-1-test-stagine-pipeline-details.png)

2. Le pipeline s'est terminé avec succès et on peut maintenant confirmé que l'URL a bien été vérifié et l'application est bien fonctionnel

![6-2-test-stagine-console.png](../capture/6-2-test-stagine-console.png)

# Deploy review

Le test de staging nous a permis de confirmer que l'application est bien fonctionnelle et cela, sans besoin d'intervention manuelle. Maintenant, nous allons pouvoir envoyer les modifications vers la branche `main` qui est la branche de production. Mais avant cela, nous allons passer vers la phase de review qui va servir à confirmer qu'il n'y a pas de conflit de code entre la branche de staging et la branche `main`.

1. J'ai ajouté les sections `deploy review & stop review` et fait un push vers le repo dispo. Le pipeline s'est lancé automatiquement mais seulement avec encore 5 cinq stages car les review ne vont se lancer que si on fait un merge request. 

![7-1-review-pipeline-list.png](../capture/7-1-review-pipeline-list.png)

2. Et une fois que le pipeline se termine, il y aura un bandeau en haut qui va suggérer de faire un merge étant donné que le push effectué n'était pas sur la branche principale. 

![7-2-review-bandeau-merge.png](../capture/7-2-review-bandeau-merge.png)

3. Mais on peut aussi créer le merge request depuis la barre latérale gauche puis dans `Code > Merge requests` puis `New merge request`.

**Capture du création merge request interface 1:**

![7-3-1-review-merge-request-form.png](../capture/7-3-1-review-merge-request-form.png)

**Capture du création merge request interface 2:**

![7-3-2-review-merge-request-form1.png](../capture/7-3-2-review-merge-request-form1.png)

4. On est ensuite redirigé vers cette interface pour remplir les différents champs afin de paramétrer le comporetement du merge request. Et si on a préféré cliquer sur le bandeau, on aura été redirigé vers cette interface également. Mais surtout, on ne va pas oublié de décocher l'option ci-dessous afin de ne pas supprimer la branche staging étant donné qu'elle nous servira encore. 

**Capture tête du formulaire:**

![7-4-1-review-merge-request-form2.png](../capture/7-4-review-merge-request-form2.png)

**Capture du pied du formulaire:**

![7-4-2-review-merge-request-form-delete.png](../capture/7-4-review-merge-request-form-delete.png)

5. Une fois qu'on a cliqué sur `create merge resquest`, on est redirigé vers la page ci-dessous qui va nous indiqué que le merge s'est bien lancé. On peut cliquer sur la référence du merge pour avoir les détails du pipeline.

![7-5-review-merge-request-launched.png](../capture/7-5-review-merge-request-launched.png)

6. Après avoir cliqué sur la référence du pipeline, on est redirigé vers la page qui affiche les détails du pipeline et on verra qu'il n'y a que deux pipeline. Car dans notre fichier `.gitlab-ci.yml`, on a dit que les deux pipelines seront lancés lors d'un merge request:

    + `deploy review`: pour faire la création du projet dans un environnement conteneuriser et faire le test de l'application;
    + `stop review`: pour supprimer l'environnement une fois le test terminer car sinon, ça va occuper notre espace sur Heroku pour en. Mais on peut voir les icônes play et stop sur le job stop deploy car dans notre fichier `.gitlab-ci.yml`, nous avons spécifié que ce job sera lancé manuellement, donc cela nous laisse le temps de vérifier et confirmer que l'application est bien accessible avec de valider la suppression de l'environnement de review. Et on peut également arrêter le job si on veut.

![7-6-merge-request-pipeline-details.png](../capture/7-6-merge-request-pipeline-details.png)

7. Avant de supprimer l'environnement de review si le deploy review s'est terminé sans erreur, on peut aller dans `Operate > Environments`, puis on identifie notre job, et on clique sur open pour accéder à l'application.

**Capture environnement:**

![7-7-merge-request-environment-open.png](../capture/7-7-merge-request-environment-open.png)

**Capture vérification application:**

![7-7-merge-request-url-open.png](../capture/7-7-merge-request-url-open.png)

8. Comme les pipelines précédents, on peut cliquer sur le job pour accéder à la console d'évènement. Et on verra que le job s'est bien terminé avec succès. 

![8-merge-request-console-stop-review.png](../capture/8-merge-request-console-stop-review.png)


