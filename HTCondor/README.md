# HTCondor y Pandas

En este directorio se encuentran dos ejecuciones de un contenedor (`josanabr/pandas`) que tiene instalada la librería Pandas. 
Una de las ejecuciones se encuentra descrita en el archivo `pandas.condor` y la segunda en el archivo `pandas_script_as_arg.condor`.

La ejecución descrita en `pandas.condor` muestra la ejecución de un script (llamado `script.sh`) sin argumentos.
Este script ejecuta un programa en Python que accede a un archivo CSV "quemado" dentro del contenedor. 

La ejecución descrita en `pandas_script_as_arg.condor` muestra la ejecución de un script (llamado `script_as_arg.sh`) que espera recibir como argumento un script en Python que el usuario espera se ejecute dentro del contenedor. 
A diferencia de la ejecución anterior, en este caso el usuario podrá usar un script diferente para trabajar sobre los datos "quemados" dentro del contenedor.

Diferencias entre los archivos `.condor`

```
4c4
< transfer_input_files = script.sh
---
> transfer_input_files = script_as_arg.sh,pandas_app.py
7c7
< arguments = script.sh
---
> arguments = script_as_arg.sh pandas_app.py
14,17d13
```

Diferencias entre los archivos `.sh`

```
$ diff script.sh script_as_arg.sh 
3c3,7
< python3 pandas_app.py
---
> if [ "${1}" == "" ]; then
> 	echo "No fue provisto un script"
> 	exit 1
> fi
> python3 ${1}
```
