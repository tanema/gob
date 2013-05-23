. ../gob.sh

green='\033[32m'
red='\033[31m'
yellow='\033[33m'
end_c='\033[0m'

mkdir "tmp"
cd tmp
printf "reveler help should show message ..."
if [[ "x$(reveler help)" = "x" ]]; then
  echo "${red}Failed with $reveler_help${end_c}"
else
  echo "${green}Passed${end_c}"
fi

printf "a unrecognized command should echo the help info ..."
if [[ "$(reveler help)" != "$(reveler fuck)" ]]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

printf "reveler init should create a .goproj file in the pwd, marking it as the root of a project. ..."
mkdir test && cd test && echo "y" | reveler init &> /dev/null
if [ -f ".goproj" ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi

printf "reveler init should not allow to create a project inside a project ..."
mkdir test2 && cd test2 && reveler init &> /dev/null
if [ -f ".goproj" ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi
cd ../.. && rm -rf test

printf "reveler new should create a new directory with a .goproj and .gitignore file in it as well as revel. ..."
reveler new test &> /dev/null
if [ -f "../../.goproj" ] && [ -f "../../.gitignore" ] && [ -f "../../bin/revel" ] && [ -d "app" ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi
cd ../..

printf "reveler new should not create a new project inside another project ..."
mkdir test2 && cd test2 && reveler new test &> /dev/null
if [ -d "test" ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi
cd ../.. && rm -rf test

printf "reveler run should call revel run on the project ..."
echo "${yellow}Pending${end_c}"
printf "reveler debug should start up a session of gdb with the app loaded ..."
echo "${yellow}Pending${end_c}"

printf "reveler version should display a version Number. ..."
if [ $(reveler version) != $(echo $GOB_VERSION) ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

cd ..
rm -rf tmp
