*Sorry documentation in french at this moment, I will translate it when stabilized.*
## Description
Cette image permet de se connecter à un véhicule Xpeng en émulant l'application Android. Elle publie ensuite les données obtenues vers un serveur MQTT dans un format permettant le transfert vers Home Assistant.

Le container ne contient pas l'APK de l'application Xpeng. Il est téléchargé depuis APKPure à chaque démarrage.

L'application incluse a été développée par [Paul Simon](https://www.facebook.com/groups/968560359253519/user/61584594027246) et publié dans le groupe [Hey Xpeng France !](https://www.facebook.com/groups/968560359253519) : [Conversation Facebook](https://www.facebook.com/groups/968560359253519/permalink/1077131558396398/).

## Usage
### 1- Compte Xpeng
Pour fonctionner l'application nécessite un compte secondaire xpeng que vous avez invité sur votre véhicule.
### 2 - Configuration
La première étape consiste à se connecter sur l'application xpeng avec le compte secondaire pour obtenir un token de session.

    docker run -it --rm --volume xpeng-storage:/data -p 8765:8765 sbonnell/xpeng-direct:latest /app/setup.sh
Une fois lancé l'interface de configuration est accessible sur http://[IP du serveur]:8765/

Le token de session et la configuration sont stockés dans xpeng-storage qui doit être persistant entre les redémarrage.
### 3 - Mode serveur
Une fois la configuration faite, il faut relancer le container en mode serveur.

    docker run -d --volume xpeng-storage:/data sbonnell/xpeng-direct:latest
    

