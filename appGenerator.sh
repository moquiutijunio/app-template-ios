#!/bin/bash

function printError {
	printf "\033[0;31m$1\033[0m\n"
}

function printSuccess {
	printf "\033[0;32m$1\033[0m\n"
}

function printWarning {
	printf "\033[0;33m$1\033[0m\n"
}

while [ -z $PROJECT_NAME ]
do
	read -p "Nome do Projeto: " PROJECT_NAME

	if [[ "$PROJECT_NAME" =~ [^a-zA-Z0-9] ]]; then
		printError "Erro: Nome do projeto deve ter somente caracteres alphanuméricos"
		unset PROJECT_NAME
	fi

	if [ ${#PROJECT_NAME} -le 3 ]; then
		printError "Erro: Nome do projeto deve ter mais que 3 caracteres"
		unset PROJECT_NAME
	fi
done

printf "\n"

DEFAULT_LOCAL_DOWNLOAD="~/Desktop/"

while [ -z $LOCAL_DOWNLOAD ]
do
	read -e -p "Digite a pasta que o projeto será salvo [$DEFAULT_LOCAL_DOWNLOAD]: " RAW_LOCAL_DOWNLOAD
	LOCAL_DOWNLOAD=`eval echo $RAW_LOCAL_DOWNLOAD`

	if [ -z $LOCAL_DOWNLOAD ]; then
		LOCAL_DOWNLOAD=`eval echo $DEFAULT_LOCAL_DOWNLOAD`
	fi

	if [ ! -d $LOCAL_DOWNLOAD ]; then
		printError "Não existe a pasta em \"$LOCAL_DOWNLOAD/\". Essa pasta já deve existir para continuar."
		unset LOCAL_DOWNLOAD
		continue
	fi

	if [ -d "$LOCAL_DOWNLOAD/$PROJECT_NAME" ]; then
		printError "Já existe uma pasta em \"$LOCAL_DOWNLOAD/$PROJECT_NAME\". Mude o local ou apague a pasta para prosseguir."
		unset LOCAL_DOWNLOAD
		continue
	else
		cd "$LOCAL_DOWNLOAD"
	fi

done

command -v brew >/dev/null 2>&1 || { echo >&2 "Homebrew não instalado. Instalando..."; /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }
command -v perl >/dev/null 2>&1 || { echo >&2 "perl não instalado. Instalando..."; brew install perl; }

git clone https://github.com/moquiutijunio/app-template-ios.git "$PROJECT_NAME"

cd "$PROJECT_NAME"

rm -rf .git
rm -rf ./Certificates
grep -rl "AppTemplateiOS" ./AppTemplateiOS | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" ./AppTemplateiOSTests | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" ./AppTemplateiOSUITests | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" ./AppTemplateiOS.xcodeproj | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" ./Podfile | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" ./Gemfile | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" ./R.generated | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" ./fastlane | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "AppTemplateiOS" .ruby-gemset | xargs sed -i "" "s/AppTemplateiOS/$PROJECT_NAME/g"
grep -rl "$FACEBOOK_TEMPLATE_API_KEY" ./AppTemplateiOS | xargs sed -i "" "s/$FACEBOOK_TEMPLATE_API_KEY/$FACEBOOK_API_KEY/g"
mv AppTemplateiOS.xcodeproj/xcshareddata/xcschemes/AppTemplateiOS.xcscheme "AppTemplateiOS.xcodeproj/xcshareddata/xcschemes/${PROJECT_NAME}.xcscheme"
mv AppTemplateiOS.xcodeproj "$PROJECT_NAME.xcodeproj"
mv AppTemplateiOS/ "./$PROJECT_NAME/"
mv AppTemplateiOSTests/AppTemplateiOSTests.swift "./AppTemplateiOSTests/${PROJECT_NAME}Tests.swift"
mv AppTemplateiOSTests/ "./${PROJECT_NAME}Tests/"
mv AppTemplateiOSUITests/AppTemplateiOSUITests.swift "./AppTemplateiOSUITests/${PROJECT_NAME}UITests.swift"
mv AppTemplateiOSUITests/ "./${PROJECT_NAME}UITests/"

command -v rvm >/dev/null 2>&1 || { echo >&2 "rvm não instalado. Instalando..."; gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB; \curl -sSL https://get.rvm.io | bash -s stable; }

source ~/.rvm/scripts/rvm
rvm use .
gem install bundler
bundle

pod install

printWarning "Não se esqueça de substituir o arquivo GoogleService-Info.plist para o plist gerado pelo Google para sua aplicação"
printSuccess "Feito. Happy Coding!!!"

read -r -p "Deseja abrir o projeto? [Y/n] " OPEN_PROJ
if [ -z $OPEN_PROJ ]; then
  OPEN_PROJ="y"
fi

if [[ $OPEN_PROJ =~ [yY](es)* ]]
then
  open "${PROJECT_NAME}.xcworkspace"
fi

