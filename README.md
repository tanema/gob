![Gob Bluth](http://i.imgur.com/xyvffqA.jpg)

> Gob: You know, I sorta thought my contribution... could be a magic show! 

Gob and Reveler: Go Broject Management
=============================

Gob will help you start and manage your go project. It will 

 * set the GOPATH to the root of the project when you cd into the project.
 * with the GOPATH set to the project, you can easily commit your project libraries to source control.
 * add a go specific gitignore to a new project.

Reveler will do all that and more. It will create a new project, get revel, build it and set the GOPATH.

Installation
------------
*prerequisites: Go is installed, GOROOT is set, and GOPATH is not set.*

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
   echo "[[ -s \"$PWD/gob.sh\" ]] && source \"$PWD/gob.sh\" # Load gob"  >> ~/.bashrc 
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
  gob new,n    Creates a new directory with a .goproj and .gitignore file in it.
  gob sub      Iterate through source and add as submodules
  gob version  Displays version Number.

Example:
  gob init
  gob new myproj
```

```
Reveler

Use:
  reveler help            Show this message
  reveler init            Create a .goproj file in the pwd, marking it as the root of a project.
  reveler new,n name      Creates a new directory with a .goproj and .gitignore file in it.
                          It then gets revel and builds it.
  reveler run,r [env]     Will run the revel project with an optional environment
  reveler debug,d         Will open a gdb console with the project running (NOTE: This builds before 
                          it runs so any changes to the code will not be refelected in the gdb session).
  reveler package         This will package up your project without having to specify the path
  reveler build,b target  This will build your project without having to specify the path
  reveler sub             Iterate through source and add as submodules
  reveler version         Displays version Number.

Example:
  reveler init
  reveler new myproj
```

TODO
----------------

If there are any requests I am willing to make setting the GOPATH and PATH variables opt-out in case
any of those who use a global GOPATH are interested in the limited functionality this tool still gives them.

