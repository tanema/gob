. ../gob.sh

green='\033[32m'
red='\033[31m'
end_c='\033[0m'

mkdir "tmp"
cd tmp
echo "gob help should show message"
if [[ "x$(gob help)" = "x" ]]; then
  echo "${red}Failed with $gob_help${end_c}"
else
  echo "${green}Passed${end_c}"
fi

echo "a unrecognized command should echo the help info"
if [[ "$(gob help)" != "$(gob fuck)" ]]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

echo "gob init should create a .goproj file in the pwd, marking it as the root of a project."
mkdir test && cd test && gob init
if [ -f ".goproj" ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi

echo "gob init should not allow to create a project inside a project"
mkdir test2 && cd test2 && gob init
if [ -f ".goproj" ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi
cd ../.. && rm -rf test

echo "gob new should create a new directory with a .goproj and .gitignore file in it."
gob new test && cd test
if [ -f ".goproj" ] && [ -f ".gitignore" ]; then
  echo "${green}Passed${end_c}"
else
  echo "${red}Failed${end_c}"
fi

echo "gob new should not allow to create a project inside a project"
mkdir test2 && cd test2 && gob new test
if [ -d "test" ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi
cd ../.. && rm -rf test

echo "gob version should display a version Number."
if [ $(gob version) != $(echo $GOB_VERSION) ]; then
  echo "${red}Failed${end_c}"
else
  echo "${green}Passed${end_c}"
fi

echo "changing directories in to a project should set the path gopath and goproj_path"

cd ..
rm -rf tmp
