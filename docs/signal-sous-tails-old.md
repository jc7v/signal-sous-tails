        ********************************************
        *UTILISER SIGNAL SANS SMARTPHONE SOUS TAILS*
        ********************************************


On va utiliser pour ça deux façons complémentaires d'utiliser signal : 
- signal-cli (comme "command line interface"), qui permet comme son nom l'indique d'utiliser signal en ligne de commande
- signal-desktop, qui est une interface graphique pour signal sur PC, qui fonctionne presque comme l'interface sur smartphone à  exceptions près : il n'est notamment pas possible de créer un nouveau compte, ni de démarrer un nouvelle conversation en utilisant tor.

Merci aux blogs bisco.org et ctrl.alt.coop pour les tutos, et à AsamK pour signal-cli


-------------
AVERTISSEMENT
-------------
1° Signal demande que les comptes soient régulièrement consultés. Il y a une suspicion de risque de fermeture d'un compte en cas de non utilisation prolongée. Dans le cas d'un compte créé avec une carte sim "jetable", le compte sera dans ce cas définitivement perdu. Il est donc conseillé d'utiliser régulièrement tails (de l'ordre de tous les 15 jours a minima).
2° Les appels audio et vidéo ne fonctionnent pas avec cette méthode (et a priori pas avec tor)

------------------------------------------------
#### Pour commencer : ce qui est nécessaire ####


- Une clé tails >= 5.0 (version sortie le 3 mai 2022, ça ne fonctionnera pas avec une version moins récente, et il faut utiliser une version à jour de toute façon !), avec un volume persistent.
- Une connaissance minimale de l'usage du terminal (ce tutoriel essaie d'expliciter chaque manipulation mais ça reste délicat sans aucune expérience).
- Un numéro de téléphone jetable (nommé +336XXXXXXXX dans ce tuto, en cas de numéro en 07, le numéro à renseigner sera sous la forme +337XXXXXXXX), sur lequel recevoir un sms ou un appel. Il est bon de rappeler que les logs des opérateurs gardent en mémoire l'identifiant du téléphone (appareil) en communication et l'associent à la carte sim utilisée. Pour être tout à fait anonyme (ou disons plus anonyme), il faut donc utiliser aussi un boitier téléphonique jetable, et dans l'idéal réaliser l'opération ailleurs que chez soi. Attention : l'activitation d'une nouvelle carte sim peut mettre plusieurs minutes.

---------------------------------
#### Configuration de Tails ####
- Ouvrir tails en déverrouillant la persistence
- Valider dans "configurer le volume persistent" : "dotfiles" et "logiciels supplémentaires"
- Redémarrer tails en activant un mot de passe administrateur
NB: les lignes après ~$ sont à taper dans un terminal, en validant avec la touche entrée. Les commandes commençant par "sudo" impliquent de rentrer le mot de passe administrateur choisi au démarage de tails.

-----------------------------------------------------------------------------------------
#### Installation de signal-cli (https://github.com/AsamK/signal-cli#installation) ####

    * installation de java (nécessaire au fonctionnement de signal-cli)
        ~$ sudo apt update 
        ~$ sudo apt install openjdk-17-jdk zbar-tools
        
        Valider "installer à chaque fois"

    * installation de signal-cli en version 0.10.11, si version plus récente (voir https://github.com/AsamK/signal-cli/releases/latest), remplacer les références dans les lignes suivantes
        ~$ mkdir Persistent/signal
        ~$ wget https://github.com/AsamK/signal-cli/releases/download/v0.10.11/signal-cli-0.10.11-Linux.tar.gz
        ~$ tar xf signal-cli-0.10.11-Linux.tar.gz -C Persistent/signal
	# Ajouter ces deux lignes dans le fichier ~/.bashrc
	~$ export JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true"
	~$ alias signal="torsocks /home/amnesia/Persistent/signal/signal-cli-0.10.11/bin/signal-cli"
	# Enregistrer le fichier et le copier dans dotfiles
	~$ cp ~/.bashrc /live/persistance/Tailsdata_Unlocked/dotfiles
    * Se referer au script ~/Persistent/signal/signal-install/install.sh (pas vraiment fonctionel)
        

-----------------------------------------
#### Enregistrement du compte signal ####

    * Comme on passe par tor le serveur de signal demande de valider l'enregistrement avec un captcha (https://github.com/AsamK/signal-cli/wiki/Registration-with-captcha)
        ouvrir avec torbrowser https://signalcaptchas.org/challenge/generate.html ou https://signalcaptchas.org/registration/generate.html (au choix)
        ouvrir une console (clic droit sur la page, "inspecter", puis "console" dans le bandeau des outils développeur)
        résoudre le captcha
        dans la console, copier la longue suite de caractère qui s'affiche après signalcaptcha://
        
    * enregistrer le compte (numéro de téléphone 06xxxxxxxx)
        ~$ signal -a +336xxxxxxxx register --captcha CAPTCHA
        (où CAPTCHA est la suite de caractères récupéré à l'étape précédente)
        Cette opération envoi un code par sms au numéro indiqué. pour recevoir un code par message vocal (sur une ligne fixe par exemple), ajouter --voice à la ligne de commande précédente
        ~$ signal -a +336xxxxxxxx verify CODE
        (où  CODE est le code récupéré à l'étape précédente)
        
    * ajouter un code pin au compte signal (ce qui évitera qu'une fois le numéro jetable réattribué après quelques mois, quelqu'un écrase votre compte signal !)
        ~$ signal -a +336xxxxxxxx setPin VOTRECODEPINAUCHOIX
        
    * optionel : se donner un nom de profil sur signal (pour les autres modifs du profil cf. https://github.com/AsamK/signal-cli/blob/master/man/signal-cli.1.adoc#updateprofile)

    ~$ signal -a +336xxxxxxxx updateProfile --name VOTRENOM


    * garder la config de signal-cli dans la persistence
        ~$ mkdir -p /live/persistence/TailsData_unlocked/dotfiles/.local/share
        ~$ cp -r .local/share/signal-cli /live/persistence/TailsData_unlocked/dotfiles/.local/share/
   
    * un script pour commencer une conversation avec un nouveau contact (voir paragraphe "utilisation") : voir le fichier ~/Persistent/signal/new-conversation.py et ~/.local/share/applications/new-conversation.desktop
        
----------------------------------------
####Installation de signal-desktop ####

## Download signal-desktop .deb package from Signal repo

  1. Install the official signal public software signing key
  ~$ wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
  ~$ cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null

  2. Add our repository to your list of repositories
  ~$ echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] tor+https://updates.signal.org/desktop/apt xenial main' |\
    sudo tee -a /etc/apt/sources.list.d/signal-xenial.list

  3. Update your package database and install signal
  ~$ sudo apt update
  ~$ apt download signal-desktop
  ~$ dpkg-deb -xv signal-desktop_X.X.deb ~/Persistent/signal/signal-desktop

Voir le fichier Persistent/signal/signal.sh pour lancer signal. Il ressemble a cela:
        #!/usr/bin/env bash


	export HTTP_PROXY="socks://127.0.0.1:9050"
	export HTTPS_PROXY=$HTTP_PROXY

	/home/amnesia/Persistent/signal/signal-desktop/opt/Signal/signal-desktop --no-sandbox %U

    ~$ mkdir -p /live/persistence/TailsData_unlocked/dotfiles/.local/share/applications
    ~$ gedit /live/persistence/TailsData_unlocked/dotfiles/.local/share/applications/Signal.desktop
    copier, enregistrer, fermer :
        [Desktop Entry]
        Name=Signal
        GenericName=Signal Desktop Messenger
        Exec=/home/amnesia/Persistent/signal/signal.sh
        Terminal=false
        Type=Application
        Icon=/home/amnesia/Persistent/signal/signal-cli/usr/share/icons/hicolor/128x128/apps/org.signal.Signal.png

----------------------------------------------
#### Relier signal-cli et signal-desktop ####
(https://ctrl.alt.coop/en/post/signal-without-a-smartphone/)

    lancer signal-desktop (icone "signal" dans les applications de tails)
    faire une capture d'écran du QR code proposé par signal-desktop et l'enregistrer dans Images/ (utiliser le logiciel capture d'écran et choisir le mode "sélection" pour ne capture que le QR code)
    ~$ sudo apt install zbar-tools
    (pas la peine d'installer à chaque fois)
    ~$ export JAVA_TOOL_OPTIONS="-Djava.net.preferIPv4Stack=true"
    ~$ zbarimg Images/LE-NOM-DE-VOTRE-CAPTURE-D'ECRAN 
    (pour cette dernière ligne, si on tape sur la touche "tabulation" (les deux flèches en sens opposées) après le / de Images/, le terminal devrait compléter tout seule le nom du fichier)
    copier la ligne après QR-Code: (qui commence par sgnl://). Pour copier/coller dans le terminal il faut selectionner le texte et faire clic du milieu ou clic droit + clic gauche (pour coller le texte sélectionner à l'endroit du curseur)
    ~$ torsocks signal-cli -a +336XXXXXXXX addDevice --uri "sgnl://..."
    (en collant la ligne copier ci-dessus entre les guillemets)
    
    

L'installation est maintenant terminée et fonctionnelle, si tout s'est bien passé...
L'utilisation, même après redémarrage de tails, est heureusement plus simple :
    
----------------------    
#### Utilisation ####

    * attendre que les logiciels supplémentaires soient installés au démarrage (un message signale quand c'est le cas, ça prend une à deux minutes)
    * lancer signal-desktop via l'icône dans les applications et l'utiliser normalement.
    * pour démarrer une conversation avec un nouveau contact, il est nécessaire d'utiliser signal-cli (impossible avec signal-desktop):             
    ~$ ./Persistent/signal/nouveau-contact.sh +336YYYYYYYY "votre message ici entre les guillemets"
        où 06YYYYYYYY est le numéro de votre correspondant.e
    la conversation apparaîtra alors dans signal-desktop et pourra se poursuivre là. 
    * il est possible (et recommandé) de mettre à jour signal-desktop régulièrement avec la commande suivante :
        ~$ torify flatpak update
    * Pour récupérer les fichiers attachés à un message :
        - lancer le script de récupération des messages (ça peut être très long):

        ~$ ./Persistent/signal/relever-signal-cli.sh

    - Les fichiers joints se retrouvent dans le répertoire Persitent/signal/attachments

--------------------------------

