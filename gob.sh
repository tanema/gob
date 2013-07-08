# Gob and Reveler, Go/Revel Project Management
# Implemented as a bash function
# To use, source this file from your bash profile
#
# Implemented by Tim Anema <timanema@gmail.com>
GOB_VERSION="0.1.1"

# Auto detect the GOB_DIR
if [ ! -d "$GOB_DIR" ]; then
  export GOB_DIR=$(cd $(dirname ${BASH_SOURCE[0]:-$0}) && pwd)
fi

#if [ "x$GOPATH" = "x" ]; then
  # settings for if GOPATH is already set maybe make it only exclusive if this not set.
  #export GOB_EXCLUSIVE="true"
#fi

cd (){
  builtin cd $@
  if [ "x$GOPROJ_PATH" = "x" ]; then
    gob_get_proj_dir
  elif [[ $PWD != $GOPROJ_PATH* ]]; then
    export PATH=$(echo ${PATH#$GOPATH/bin:})
    export GOPATH=""
    export GOPROJ_PATH="" 
    gob_get_proj_dir
  fi
}

gob_get_proj_dir() {
  local dir="$(pwd)"
  while [[ $dir != "/" ]]; do
    if [[ -e "${dir}/.goproj" ]]; then
      export GOPATH="${dir}"
      export PATH=$GOPATH/bin:$PATH
      export GOPROJ_PATH="${dir}" 
      break
    fi
    dir=$(dirname "${dir}")
  done
}

gob_get_proj_dir

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
      echo "  gob new,n    Creates a new directory with a .goproj and .gitignore file in it."
      echo "  gob sub      iterate through the src and add in all the submodules automatically"
      echo "  gob version  Displays version Number."
      echo ""
      echo "Example:"
      echo "  gob init"
      echo "  gob new myproj"
      echo ""
      ;;
    "init")
      if [ "x$GOPROJ_PATH" = "x" ]; then
        # add .goproj to current directory for use with gob
        echo "Warning, only do this in the root of your project directory"
        echo "Continue (y/n)?"
        read  choice
        case "$choice" in 
          y|Y ) touch .goproj && echo "Created .goproj" ;;
        esac
      else
        echo "Cannot (or will not) make a go project inside another go project"
      fi
      ;;
    "new" | "n")
      # create directory with .goproj in it already and .gitignore
      if [ "x$GOPROJ_PATH" = "x" ]; then
        if [ "x$2" = "x" ]; then
          echo "new requires a name"
          return 1
        else
          mkdir $2 && touch $2/.goproj && cp $GOB_DIR/Go.gitignore $2/.gitignore && echo "Created $2"
        fi
      else
        echo "Cannot (or will not) make a go project inside another go project"
      fi
      ;;
    "sub" )
      if [ "x$GOPROJ_PATH" = "x" ]; then
        echo "Oops. You are not in a project directory"
      else  
        local before_path="$PWD"
        for i in $(ls -d $GOPATH/src/**/); do
          if [ -d "$i".git ]; then
            cd $i
            local remote="$(git config --get remote.origin.url)" 
            cd $GOPATH
            git submodule add $remote ".${i#$GOPATH}"
          fi
        done
        cd $before_path
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
      echo "  reveler help      Show this message"
      echo "  reveler init      Create a .goproj file in the pwd, marking it as the root of a project."
      echo "  reveler new,n     Creates a new directory with a .goproj and .gitignore file in it."
      echo "                    It then gets revel and builds it."
      echo "  reveler run,r     Will run the revel project."
      echo "  reveler debug,d   Will build the app and open a gdb console with the project running (NOTE: This builds before"
      echo "                    it runs so any changes to the code will not be refelected in the gdb session)."
      echo "  reveler package   This will package up your project without having to specify the path"
      echo "  reveler sub       iterate through the src and add in all the submodules automatically"
      echo "  reveler version   Displays version Number."
      echo ""
      echo "Example:"
      echo "  reveler init"
      echo "  reveler new myproj"
      echo "" 
      ;;
    "init" ) gob init;;
    "sub" ) gob sub;;
    "new" | "n")
      gob new $2 && cd $2 && echo "Getting revel" && (go get github.com/robfig/revel/revel || { echo 'go get failed' ; return 1; }) && revel new $2 && cd src/$2
      ;;
    "run" | "r" | "server" | "s" )
      # run a revel app from the goproj root
      if [ "x$GOPROJ_PATH" = "x" ]; then
        echo "Oops, you are not in a project directory"
      else
        revel run ${GOPROJ_PATH##*/}
      fi
      ;;
    "package" | "p" )
      # run a revel app from the goproj root
      if [ "x$GOPROJ_PATH" = "x" ]; then
        echo "Oops, you are not in a project directory"
      else
        revel package ${GOPROJ_PATH##*/}
      fi
      ;;
    "debug" | "d" |"console" | "c" )
      # run a revel console from the goproj root
      if [ "x$GOPROJ_PATH" = "x" ]; then
        echo "Oops, you are not in a project directory"
      else
        echo "####################################################"
        echo "#                     Warning                      #"
        echo "# -------------------------------------------------#"
        echo "# This will be a built version of your app, any    #"
        echo "# changes will not be reflected in debug, revel    #"
        echo "# does not support this at the moment.             #"
        echo "####################################################"
        local project_name=${GOPROJ_PATH##*/}
        revel clean test &> /dev/null && revel build $project_name $GOPROJ_PATH/tmp/$project_name  && (echo r ; cat) | gdb --args $GOPROJ_PATH/bin/$project_name -importPath $project_name -srcPath "$GOPROJ_PATH/src" -runMode dev
      fi
      ;;
    "version" ) echo $GOB_VERSION;;
    * ) reveler help;;
  esac
}
