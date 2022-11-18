# Debsignal

Aplication permettant une utilisation aisée de Signal sans Smartphone, particulièrement sous Tails. Elle répond particuliprement au besoin de pouvoir se créer un compte Signal depuis un oridnateur sans utiliser de Smartphone.

Pour ce faire, cette application se base sur deux autres logicels:

* Signal Desktop: Interface graphie développée par Signal pour ordinateur. Elle à des fonctionalités limitées, notamment pas de création de compte et pas possible de pouvoir créer une nouvelle conversation Signal.
* signal-cli: Interface en ligne de commande développée par ... écrite en Java, elle implémente toutes les fonctionalitées présente dans Signal pour smartphone. Elle possède notamment une interface JSON-RPC pour communiquer facilement avec d'autres programmes.

Actuellement cela nous semble compliqué de distribuer ces deux applications dans Debian:

* Signal est opposé à ce que libsignal (la bibliothèque qui implémente les protocoles de Signal) soit distribuées dans Debian et ils ne font rien pour faciliter la vie au développeurs qui le voudraient. Pour plus d'infos, consulter les ticket Debian ouvert à ce sujet. Plusieurs personnes ont eu la volonté, mais personne ne l'a encore fait.
* signal-cli évolue vite. Cela nécesiterais de contacter son développeur et de voir comment c'est possible. Mais étant donné signal-cli utilise libsignal, cela risque d'être compliqué.

Dans tous les cas, cela nous semble être beaucoup de travail, et un travail au long cours. Même si dans un monde idéal, il y aurait un paquet signal-desktop et un autre signal-cli disponible dans la distribution Debian.

Note: Signal Dekstop est déjà disponible sous la forme d'un paquet debian et peut être téléchargé depuis le réprtoire de Signal.

## Objectifs

1. se présenter sous la forme d'un paquet Debian qui pourrait à terme être intégré dans la future distribution de Debian
2. En l'état actuel, être facilement installable depuis Tails sans requérir de mot de passe d'admin et que l'installation soit pertistante.
3. Automatiser l'installation et la mise à jour de signal-cli et Signal Desktop, plus particulièrement sous Tails
4. Fournir une interface pour la création de nouveaux comptes Signal
5. De manière générale, détécter son utilisation sous Tails et proposer des options appropriées pour sauvegarder les données dans la persistence
6. Faciliter l'utilisation de signal desktop et signal-cli avec Tor:
  * proposer les bonnes options de configuration
  * faciliter la résolution de captcha pour créer un nouveau compte

## Fonctionalités

* Au démarrage vérifie:
  * la présence de Signal Desktop et signal-cli
  * Si des nouvelles versions sont disponibles
* Propose l'installation des logiciels requis/mises à jour:
  * Télécharge, vérifie et install Signal desktop et signal-cli
* Si l'utilisation de Tails est détectée, propose une option pour une installation qui reste persistante dans Tails des applications (Je ne sais pas si ça passer pour debian??):
  * Signal Desktop
  * signal-cli
  * D'elle même
* Sinon, propose à l'utilisateur l'endroit où il veut sauvegarder les applications? Alors que par défaut c'est dans /usr
* Affiche une fenêtre avec plusieurs options:
  * lancer signal desktop (en utilisant Tor ou non)
  * utiliser signal-cli (avec ou sans Tor)
  * Si l'application est utilisée sous tails, propose une option pour sauvegarder dans la persistence (nécessité d'avoir activer dotfiles?) les données de:
    * Signal desktop
    * signal-cli
    * de l'application elle-même
  * Lancer le processus pour créer un nouveau compte (avec ou sans Tor)
* Démarrer une nouvelle conversation avec quelqu'un dont on à jamais été mis en contact.
* propose l'installation d'un JRE si aucun n'est installé (à voir comment exactement)
* l'interface doit répondre aux normes de GNOME concernant sa conception pour qu'elle puisse être utlilsée sur n'importe quel type d'écran.

## Choix techniques

Pour sa facilité d'utilisation et sa bonne intégration à Debian/Tails, on utilise:

* python3/GTK
* nécessite d'avoir une JRE d'installée pour utiliser signal-cli
