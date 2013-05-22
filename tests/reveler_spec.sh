. ../gob.sh

green='\033[32m'
red='\033[31m'
end_c='\033[0m'

mkdir "tmp"
cd tmp
echo "reveler help should show message"
if [[ "x$(reveler help)" = "x" ]]; then
  echo "${red}Failed with $reveler_help${end_c}"
else
  echo "${green}Passed${end_c}"
fi

echo "a unrecognized command should echo the help info"
if [[ "$(reveler help)" != "$(reveler fuck)" ]]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

echo "reveler init should create a .goproj file in the pwd, marking it as the root of a project."
mkdir test && cd test && reveler init
if [ -f ".goproj" ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi

echo "reveler init should not allow to create a project inside a project"
mkdir test2 && cd test2 && reveler init
if [ -f ".goproj" ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi
cd ../.. && rm -rf test

# echo "reveler new should create a new directory with a .goproj and .gitignore file in it."
# reveler new test && cd test
# if [ -f ".goproj" ] && [ -f ".gitignore" ]; then
#   echo "${green}Passed${end_c}"
# else
#   echo "${red}Failed${end_c}"
# fi
# 
# echo "reveler new should not allow to create a project inside a project"
# mkdir test2 && cd test2 && reveler new test
# if [ -d "test" ]; then
#   echo "${red}Failed${end_c}"
# else
#   echo "${green}Passed${end_c}"
# fi
# cd ../.. && rm -rf test
# reveler ini
# reveler debug

echo "reveler version should display a version Number."
if [ $(reveler version) != $(echo $GOB_VERSION) ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

cd ..
rm -rf tmp
