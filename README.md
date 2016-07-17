# HackBooks

Los datos de portada y los pdfs se descargan en local y se guardan en la carpeta cache la primera vez que son descargados.

La opción de guardar libros como favoritos la he implementado con NSUserDefaults para que persista cuando se cierra la app. También se podría haber guardado con CoreData pero al ocupar poco espacio se puede hacer más rápidamente con NSUserDefaults.

Cuando cambia el valor de la propiedad isFavorite se envía una notificación que recibirá todo aquél que esté suscrito. Es la mejor opción porque nos permite actualizar el modelo y recargar los datos de la tabla cuando cambie.

reloadData() no empeora el rendimiento de la aplicación porque los datos pesados (las fotos de las portadas) se almacenan la primera vez que se utilizan en la carpeta cache y así no hay que descargarlos de su ubicación remota cada vez que necesitamos recargar los datos de la tabla. Se podría hacer utilizando Grand Central Dispatch o NSOperationQueue para no sobrecargar el hilo principal, pero no nos hace falta porque después de la primera descarga ya tenemos las imágenes (y los pdfs) en local, si no sí convendría utilizar alguna de esas soluciones.

La actualización de PdfViewController cuando el usuario cambia en la tabla el libro seleccionado se ha hecho por medio de una notificación que envía el LibraryTableViewController cuando se selecciona la celda del libro correspondiente y a la que está suscrito PdfViewController para actualizar el modelo cuando se produzca.

Extras:
a. Las funcionalidad que le añadiría serían una opción de marcapáginas, búsqueda por texto del título o de los autores, sugerencias en función de los últimos libros leídos.

c. Una tienda tipo amazon, una app con las materias de un curso escolar y ejercicios o materiales extra, una app para una sociedad médica con los médicos de su cuadro.


*** Al hacer la versión para iPhone, no he conseguido que funcione la opción de favoritos. Pienso si puede ser porque al no estar “activo” el libraryViewController cuando se muestra el bookViewController y se selecciona “favorito”, no recibe las notificaciones.
