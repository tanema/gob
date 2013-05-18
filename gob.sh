# Gob and Reveler, Go/Revel Project Management
# Implemented as a bash function
# To use source this file from your bash profile
#
# Implemented by Tim Anema <timanema@gmail.com>
GOB_VERSION="0.1.0"

# Auto detect the GOB_DIR
if [ ! -d "$GOB_DIR" ]; then
  export GOB_DIR=$(cd $(dirname ${BASH_SOURCE[0]:-$0}) && pwd)
fi

cd (){
  builtin cd $@
  if [ "x$GOPATH" = "x" ]; then
    gob_get_proj_dir
  elif [[ $PWD != $GOPATH* ]]; then
    export PATH=$(echo ${PATH#$GOPATH/bin:})
    export GOPATH=""
    gob_get_proj_dir
  fi
}

gob_get_proj_dir() {
  local dir="$(pwd)"
  while [[ $dir != "/" ]]; do
    if [[ -e "${dir}/.goproj" ]]; then
      export GOPATH="${dir}"
      export PATH=$GOPATH/bin:$PATH
      break
    fi
    dir=$(dirname "${dir}")
  done
}

gob (){
  if [ $# -lt 1 ]; then
    gob help && return
  fi 

  case $1 in
    "help")
      echo ""
      echo "Gob"
      echo ""
      echo "Use:"
      echo "  gob help     Show this message"
      echo "  gob init     Create a .goproj file in the pwd, marking it as the root of a project."
      echo "  gob new      Creates a new directory with a .goproj and .gitignore file in it."
      echo "  gob version  Displays version Number."
      echo ""
      echo "Example:"
      echo "  gob init"
      echo "  gob new myproj"
      echo ""
      ;;
    "init")
      if [ "x$GOPATH" = "x" ]; then
        # add .goproj to current directory for use with gob
        echo "Warning, only do this in the root of your project directory"
        echo "Continue (y/n)?"
        read  choice
        case "$choice" in 
          y|Y ) 
            touch .goproj && echo "Created .goproj"
            ;;
        esac
      else
        echo "Cannot (or will not) make a go project inside another go project"
      fi
      ;;
    "new" | "n")
      # create directory with .goproj in it already and .gitignore
      if [ "x$GOPATH" = "x" ]; then
        mkdir $2 && touch $2/.goproj && cp $GOB_DIR/Go.gitignore $2/.gitignore && echo "Created $2"
      else
        echo "Cannot (or will not) make a go project inside another go project"
      fi
      ;;
    "version" ) echo $GOB_VERSION;;
    "program" )
        echo "Gob's Program: Y/N?"
        echo "?"
        read  choice
        case "$choice" in 
          y|Y ) 
            while [[ 1 = 1 ]]; do
              printf "Penus "
            done
            ;;
        esac
      ;;
    * ) gob help;;
    esac
}

reveler () {
  if [ $# -lt 1 ]; then
    reveler help && return
  fi 

  case $1 in
    "help")
      echo ""
      echo "Reveler"
      echo ""
      echo "Use:"
      echo "  reveler help     Show this message"
      echo "  reveler init     Create a .goproj file in the pwd, marking it as the root of a project."
      echo "  reveler new      Creates a new directory with a .goproj and .gitignore file in it."
      echo "                   It then gets revel and builds it."
      echo "  reveler run      Will run the revel project."
      echo "  reveler version  Displays version Number."
      echo ""
      echo "Example:"
      echo "  reveler init"
      echo "  reveler new myproj"
      echo "" 
      ;;
    "init" ) gob init;;
    "new" | "n")
      gob new $2 && cd $2
      echo "Getting revel"
      go get github.com/robfig/revel || { echo 'go get failed' ; return 1; }
      echo "Building revel"
      go build -o bin/revel github.com/robfig/revel/cmd || { echo 'go build failed' ; return 1; } 
      revel new $2 && cd src/$2
      ;;
    "run" | "r" | "server" | "s" )
      # run a revel app form the goproj root
      if [ "x$GOPATH" = "x" ]; then
        echo "Oops, you are not in a project directory"
      else
        revel run ${GOPATH##*/}
      fi
      ;;
    "version" ) echo $GOB_VERSION;;
    * ) reveler help;;
  esac
}
