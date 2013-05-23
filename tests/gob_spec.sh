. ../gob.sh

green='\033[32m'
red='\033[31m'
yellow='\033[33m'
end_c='\033[0m'

mkdir "tmp"
cd tmp
printf "gob help should show message ..."
if [[ "x$(gob help)" = "x" ]]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

printf "a unrecognized command should echo the help info ..."
if [[ "$(gob help)" != "$(gob fuck)" ]]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

printf "gob init should create a .goproj file in the pwd, marking it as the root of a project. ..."
mkdir test && cd test && echo "y" | gob init &> /dev/null
if [ -f ".goproj" ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi

printf "gob init should not allow to create a project inside a project ..."
mkdir test2 && cd test2 && gob init &> /dev/null 
if [ -f ".goproj" ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi
cd ../.. && rm -rf test

printf "gob new should create a new directory with a .goproj and .gitignore file in it. ..."
gob new test &> /dev/null && cd test
if [ -f ".goproj" ] && [ -f ".gitignore" ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi

printf "gob new should not allow to create a project inside a project ..."
mkdir test2 && cd test2 && gob new test &> /dev/null
if [ -d "test" ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi
cd ../.. && rm -rf test

printf "gob version should display a version Number...."
if [ $(gob version) != $(echo $GOB_VERSION) ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

printf "changing directories into a project should set the path gopath and goproj_path ..."
gob new test &> /dev/null  && cd test
if [ "$GOPATH" != "$PWD" ] || [[ $PWD != $GOPROJ_PATH* ]] || [[ $PATH != $PWD* ]]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

printf "changing out of a directory should clear the variables ..."
cd ..
if [ "$GOPATH" = "" ] && [ "$GOPROJ_PATH" = "" ] && [ $PATH != $GOPATH* ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi

cd ..
rm -rf tmp
