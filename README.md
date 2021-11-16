# Procesamiento de datos en Python usando contenedores en Docker

Este repositorio tiene como propósito presentar el uso Docker como herramienta para el apoyo de procesamiento de datos en un ambiente multiplataforma usando Python/Pandas.

El contenedor será descargado de Docker Hub ([enlace](https://hub.docker.com/r/amancevice/pandas/?ref=login)). 

Para su ejecución se usa el comando:

```
docker container run --rm --name pandas -it amancevice/pandas /bin/sh
```

Note que cuando se ejecuta este contenedor el usuario con el que se ejecuta el contenedor es el usuario `root`. 

```
john@john-Latitude-5520:~/Src/docker/pandas$ docker container run --rm --name pandas -it amancevice/pandas /bin/sh
# id
uid=0(root) gid=0(root) groups=0(root)
```

Para cambiar esto se creará un nuevo contenedor a partir del contenedor `amancevice/pandas`.
Este nuevo contenedor se ejecutará bajo un usuario llamado `user` y por defecto el contendor ejecutará el intérprete de comandos `/bin/sh`.

```
FROM amancevice/pandas
RUN groupadd -r user && useradd -r -g user user
USER user
CMD [ "/bin/sh" ]
```

Ahora se puede ejecutar la imagen de esta manera:

```
docker container run --rm --name pandas -it josanabr/pandas
```

En este contexto ya se pueden crear scripts en Python + Pandas y procesar datos.

En el directorio `resources` hay dos archivos que nos permitirán evidenciar la ejecución de Python + Pandas en un problema real. 
El archivo `HRDataset.csv` contiene datos de empleados y `pandas_app.py` tiene un script que lee los datos del archivo `.csv` y saca una información básica gracias a la librería Pandas. 

La forma de acceder a esta información es a través de la ejecución del comando `docker container run ...` de la siguiente manera:

```
docker container run -v $(pwd)/resources:/workdir --rm --name pandas -it josanabr/pandas
```

Ahora en el directorio `workdir` ya se puede acceder a estos dos archivos.
Lo más interesante de esta ejecución, es que los archivos se pueden modificar desde fuera del contenedor y los cambios serán visibles dentro del contenedor.

Una segunda opción para acceder a estos archivos, es crear una imagen de contenedor con los dos archivos descritos anteriormente. 
Para ello se crea una nueva imagen de contenedor a partir del siguiente `Dockerfile`:

```
FROM amancevice/pandas
RUN groupadd -r user && useradd -r -g user user
USER user
WORKDIR /workdir
COPY resources/* ./
CMD [ "/bin/sh" ]
```

Se ha creado un directorio llamado `workdir` y dentro de este directorio se han copiado los archivos localizados en el directorio `resources` del equipo anfitrión.

---

Ahora se desea invocar un script que ejecuta el script `pandas_app.py` que se encuentra en el directorio `/workdir`. 
El script, llamado `script.sh`, tiene las siguientes líneas:

```
#!/bin/sh
cd /workdir
python3 pandas_app.py
```

La forma de ejecutar el contenedor y que ejecute el script es de la siguiente manera:

```
docker container run --rm --name pandas -v $(pwd):/execute -it josanabr/pandas /execute/script.sh
```

Ya con estos insumos, estamos listos para enviar una tarea del universo `docker` en HTCondor 

---

# Referencias

* El contenedor usado  `amancevice/pandas`.
 
  * [Docker Hub](https://hub.docker.com/r/amancevice/pandas/?ref=login).

  * [GitHub](https://github.com/amancevice/docker-pandas)

* Ejemplo tomado de [Data Processing Example using Python](https://towardsdatascience.com/data-processing-example-using-python-bfbe6f713d9c).

* Los datos usados en el ejemplo fueron tomados de [HRDataset_v13.](https://www.kaggle.com/dushantkumar/hrdataset-v13?select=HRDataset_v13.csv).

* [Docker - USER](https://www.geeksforgeeks.org/docker-user-instruction/) 

* [Docker - CMD](https://riptutorial.com/docker/example/11009/cmd-instruction)
