Gob and Reveler, Go Broject Management
=============================

Gob will help you start and manage your go project. It will 

 * set the GOPATH to the root of the project when you cd into the project.
 * with the GOPATH set to the project, you can easily commit your library to source control.
 * add a gitignore to a new project.

Reveler will do all that and more. It will create a new project, get revel, build it and set the GOPATH.

![Gob Bluth](http://i.imgur.com/xzy4ys1.jpg)

> Illusions Michael, 

Installation
------------

1. Clone the repository

   ```bash
   git clone git@github.com:tanema/gob.git
   ```

3. Enter the project folder

   ```bash
   cd gob
   ```

2. Add the `bin/` folder to your PATH

   ```bash
   echo "[[ -s \"$PWD/gob.sh\" ]] && source \"$PWD/gob.sh\""  >> ~/.bashrc 
   ```

3. Optionaly reload your bashrc

   ```bash
   source ~/.bashrc
   ```

Usage
--------------

```

Gob

Use:
  gob help     Show this message
  gob init     Create a .goproj file in the pwd, marking it as the root of a project.
  gob new      Creates a new directory with a .goproj and .gitignore file in it.
  gob version  Displays version Number.

Example:
  gob init
  gob new myproj

```

```

Reveler

Use:
  reveler help     Show this message
  reveler init     Create a .goproj file in the pwd, marking it as the root of a project.
  reveler new      Creates a new directory with a .goproj and .gitignore file in it.
  reveler run      Will run the revel project.
  reveler version  Displays version Number.

Example:
  reveler init
  reveler new myproj

```
