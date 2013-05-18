# gob: go broject manager

GOB_VERSION="0.1.0"

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
    gob help
    return
  fi 

  case $1 in
    "help")
      echo "Gob"
      echo "========="
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
    "new")
      # create directory with .goproj in it already and .gitignore
      if [ "x$GOPATH" = "x" ]; then
        mkdir $2 && touch $2/.goproj
        echo "Created $2"
      else
        echo "Cannot (or will not) make a go project inside another go project"
      fi
      ;;
    "version" )
      echo $GOB_VERSION
      ;;
    * )
      gob help
      ;;
    esac
}

reveler () {
  if [ $# -lt 1 ]; then
    reveler help
    return
  fi 

  case $1 in
    "help")
      echo "Reveler"
      echo "========="
      ;;
    "init" )
      gob init
      ;;
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
        revel run ${GOPATH##*/}
      else
        echo "Oops, you are not in a project directory"
      fi
      ;;
    "version" )
      echo $GOB_VERSION
      ;;
    * )
      reveler help
      ;;
    esac
}
