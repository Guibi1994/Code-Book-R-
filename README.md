# Code-Book-R
Tips generales en R


# I. Uso de Git y GitHub


 
```r
# 1. Cambiar de usuario

git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# 2. Clonar un repositorio
git clone https://github.com/Guibi1994/Urban-quality-in-pandemic-times.git

# 3. "Add"
git add arhcivo.lqsea

# 4. "Commit"
git commit -m "comentario" arhcivo.lqsea
git commit -am "comentario" # para enviar todo

# 5. "Push"
git push

# 6. "Pull"
git pull


```
# Conectar un repo existente a uno upstream
```r
# I. Crear/mover/tener un archivo en el repo local
echo “A new repository with my scripts and data” >> README.txt

# II. Iniciar Git en el repo
git init # Estando dentro del repo

# III. realizar un primer commit
git commit -m "First commit. Adding README file."

# IV. Conectar un repo local a uno web
git remote add origin "https://github.com/rairizarry/murders.git"

# V. Realiza relizar el primer push
git push

```
  
# Tipos para manejo de  UNIX

```
.. # Ir al directorio anterior

rm -r # Borar un directorio con todos sus contenidos

rm -f # Borra archivos protegiods

rm -rf #Borrar todo así contenga archivos protegido

ls -a # Mostrar archivos (incluido ocultos)

ls -lart # Mostrat todo en orden cronológico

less # Revisar rapidamente el contenido de un archivo

echo "Segunda nueva linea" >> archivo.text # Crear un documento o agregar una lina


```