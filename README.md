# KSB Custom Cards
Welcome to my custom card repository. It contains its own archetypes and commissions from players with very original ideas. The balance is taken into account for healthy use and compatible with the current playing style. Enjoy it.
Visit my website to look at the archetypes. -> https://ksb-custom.github.io/KSB-Archetypes/

If you can't see custom cards in Edopro you have to check 'Alternate formats', this show all cards including anime and custom cards.

![Alternate formats](https://imgur.com/2YZEFNk.png)

# Add the cards and server to EdoPro
To add the cards and the server (for online play) follow the configuration in the Secuter repository.
-> https://github.com/Secuter/SecuterYGOCustomCards/tree/main

Thanks to Secuter for allowing my cards to be added to their server.
My discord: keenon4190

# A la comunidad en Español YGO Cartas Personalizadas
La diversión comienza aquí! Has encontrado mi repositorio de cartas personalizadas para EdoPro.
Si no sabes inglés seguramente te costará entender como modificar algunas cosas del juego, como los repositorios, así que te dejo una guía sencilla a continuación.

¿Qué es un repositorio y para qué sirve?
Los repositorios son bibliotecas alojadas en Github.com, estos se enlazan con el juego mediante códigos dentro del archivo config.json. Un nuevo repositorio es una nueva colección de cartas (en este caso cartas personalizadas) y pueden ser añadidos modificando el archivo config.json (Carpeta config). 
EdoPro se actualiza automáticamente mediante repositorios, los cuales contienen los archivos del juego. Un repositorio descargará o actualizará
automáticamente las cartas en EdoPro, estas descargas se irán a la carpeta "Repositories". 
Así es como se ven los códigos de repositorios en el archivo .json
* repositories
```json
		{
			"url": "https://github.com/Secuter/SecuterYGOCustomCards",
			"repo_name": "Secuter Custom Cards",
			"repo_path": "./repositories/secuter-custom-cards",
			"data_path": "expansions",
			"script_path": "script",
			"should_update": true,
			"should_read": true
		},
		{
			"url": "https://github.com/KSB-Custom/KSB-CCG",
			"repo_name": "KSB Custom Cards",
			"repo_path": "./repositories/KSBCustoms",
			"should_update": true,
			"should_read": true
		}
```
¿Cómo puedo añadir un repositorio a EdoPro?
Hay 2 maneras: 
1. Debes descargar el archivo [user_configs.json](config/user_configs.json) y colocarlo en la carpeta "config" de su instalación de Edopro. En  mi caso -> WINDOWS(C)\ProjectIgnis\config\user_configs.json<br>
2. Si usas otros repositorios con cartas personalizadas, debes editar manualmente el archivo user_config para incluir ambos.<br>
Hay quienes modifican el archivo config.json, pero lo ideal es usar el archivo user_config. La única diferencia es que el archivo config.json se sobrescribe con las actualizaciones importantes de Edopro, mientras que el archivo user_config no.<br>

¿Puedo tener más de un archivo configs.json?
No. Si varios programadores tienen su propio archivo config.json o user_config.json debes quedarte con uno y utilizar el método manual para añadir sus repositorios en  un sólo un archivo user_config.json.

¿Las cartas están en inglés o en español?
He añadido un repositorio para mi traducción al español de las cartas personalizadas (Secuter y mías)
Si ya tienes mi repositorio, solo debes verificar que el archivo esté en "languajes>Español>CCG-KSB-Spanish" dentro de la carpeta
"Config" de tu Edopro. También puedes hacerlo manualmente colocando el archivo en la ubicación mencionada. Debido a la gran carga de información (+1200 cartas) usé traductores que pueden tener errores. Cualquier error que encuentres puedes reportarlo a mi discord para corregirlo.

¿Puedo jugar con mis amigos con las cartas personalizadas?
Sí, pero debes agregar el repositorio del servidor Secuter Custom Cards. (Mi archivo user_config.json ya lo incluye, si ya lo tienes debería aparecerte el Servidor)
Y sólo las cartas que están en mi sitio web que tienen en la descripción "ONLINE" están disponibles para jugar en el servidor.
->https://ksb-custom.github.io/KSB-Archetypes/

¿Cómo puedo jugar con cartas personalizadas si no tengo un servidor?
Si tienes otras colecciones de cartas personalizadas o has hecho las tuyas sólo podrás jugarlas contra otros jugadores usando programas que creen una red local como Radmin VPN (únicamente pc) o ZeroTierOne (PC y móvil).

¿Cómo puedo programar mis cartas en EdoPro?
No es una tarea sencilla, requiere conocimientos básicos de programación y dominar el inglés. Puedes buscar tutoriales en youtube para comenzar. Para quienes deseen apoyarme, hago comisiones de cartas desde $1 (dólar) además he creado algunos manuales para facilitar el aprendizaje de programar cartas, tutoriales y atención personalizada en mi Patreon.
->https://www.patreon.com/c/KSBCustoms