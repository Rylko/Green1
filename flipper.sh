#!/bin/sh

source conf.sh

DEVELOPMENT_TEAM_ID="Y2V6NG4VN2"
TEMPLATE_URL=git@git.mobexs.com:flipper/ios-template-application.git
FASTLANE_CREDENTIALS_URL="http://git.mobexs.com:8081/flipper/app-credentials.git"

function setup() {
	
	checkLibsAreInstalled
	git clone "$TEMPLATE_URL"	

	###copy required content to destination folder
    addModules
	copyTemplateResourses

	###parse project.yml and set config values
	setProjectName
    setBundleIDs
    setTargetName
    setDeploymentTarget	
    setupCodeSigning 
    setConfigDevTeam   

	###generate xcode project using project.yml
	xcodegen

	###remove ios template project repository
	cleanTemporaryTemplateResourses

	###codesigning
	addCoding
	askAndStoreFastlaneCredentials
	setupFastlaneFiles
	
	createAppID
	getProfiles

	###git setup
	createGitRepo
}

function addModules {

    #coredata
    cd ios-template-application
    if [ $USE_COREDATA == 'default' ]
    then
        echo "adding subtree coredata storage"
        git subtree add --prefix IOS-APP/Classes/Storage git@git.mobexs.com:flipper/coredata-storage.git master --squash;
        setDataBaseName

    else
        echo "No CoreData"
    fi
    cd ..
}

function checkLibsAreInstalled() {
	declare -a arr=("fastlane" "xcodegen")
	result=true
	## now loop through the above array
	for i in "${arr[@]}"
	do   		
   		libPath=$(which $i)
   		if [ "$libPath" = "" ];then
   			echo $i not installed
   			result=false 
   		else
   			echo $i installed   			
   		fi
	done

	if [ $result = true ];then
		echo Continue
	else
		echo "Flipper script canceled"
		exit 2
	fi

	echo "Required libs installed"
}

function setProjectName() {	
	sed -i '' "s|___PROJECT_NAME___|"$PROJECT_NAME"|g" project.yml
}

function setBundleIDs() {
	sed -i '' "s|___BUNDLE_ID_RELEASE___|"$BUNDLE_ID_PROD"|g" project.yml
    sed -i '' "s|___BUNDLE_ID_STAGING___|"$BUNDLE_ID_STAGING"|g" project.yml
}

function setTargetName() {
	sed -i '' "s|___PROD_TARGET_NAME___|"$PROD_TARGET_NAME"|g" project.yml
}

function setDeploymentTarget() {
	sed -i '' "s|___DEPLOYMENT_TARGET___|"$DEPLOYMENT_TARGET"|g" project.yml
}

function setConfigDevTeam() {
	sed -i '' "s|___DEVELOPMENT_TEAM_ID___|"$DEVELOPMENT_TEAM_ID"|g" Config/config.xcconfig
}

function copyTemplateResourses() {
	cp -a ./ios-template-application/Configs ./
	cp -a ./ios-template-application/IOS-APP ./
	cp -a ./ios-template-application/IOS-APP_UITests ./
	cp -a ./ios-template-application/IOS-APP_UnitTests ./
	cp -a ./ios-template-application/IOS-APP_UnitTests ./
	cp -a ./ios-template-application/README ./
	cp -a ./ios-template-application/scripts ./	
	cp -a ./ios-template-application/project.yml ./	
	cp -a ./ios-template-application/fastlane ./
    cp -a ./ios-template-application/Gemfile ./
    cp -a ./ios-template-application/Gemfile.lock ./
    cp -a ./ios-template-application/gitignore ./
    #rename gitignore file
    mv -i gitignore .gitignore
}

function cleanTemporaryTemplateResourses() {
	rm -rf ios-template-application
	rm -rf project.yml
}

#modules 
function setDataBaseName() {
	
	find . -iname '___DATABASE_NAME___.xcdatamodel' -execdir mv -i '{}' "$PROD_TARGET_NAME".xcdatamodel \;
	sed -i '' "s|___DATABASE_NAME___|"$PROD_TARGET_NAME"|g" IOS-APP/Classes/Storage/Storage.swift
}

#codesigning
function setupFastlaneFiles() {
	echo "--- setupFastlaneFiles"
	## AppFile	
	#1. parse and replace bundleIDs
	sed -i '' "s|___BUNDLE_ID_RELEASE___|"$BUNDLE_ID_PROD"|g" fastlane/Appfile
    sed -i '' "s|___BUNDLE_ID_STAGING___|"$BUNDLE_ID_STAGING"|g" fastlane/Appfile
    sed -i '' "s|___BUNDLE_ID_RELEASE___|"$BUNDLE_ID_PROD"|g" fastlane/Fastfile
    sed -i '' "s|___BUNDLE_ID_STAGING___|"$BUNDLE_ID_STAGING"|g" fastlane/Fastfile

    #2. parse and replace Dev Team ID
    sed -i '' "s|___DEVELOPMENT_TEAM_ID___|"$DEVELOPMENT_TEAM_ID"|g" fastlane/Appfile

    #3. parse and replace fastlane git storage with certificates and profiles
    sed -i '' "s|___FASTLANE_CREDENTIALS_URL___|"$FASTLANE_CREDENTIALS_URL"|g" fastlane/Matchfile
}

function addCoding {

	echo "--- setup UTF-8 symbols"
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
}

function createAppID() {
    echo "--- createAppID"
	#create app id for prod target application
	fastlane produce -u "$DEVPORTAL_LOGIN" -q "$PROJECT_NAME" -a "$BUNDLE_ID_PROD" -b "$DEVELOPMENT_TEAM_ID" --skip_itc

	#create app id for prod staging application
	fastlane produce -u "$DEVPORTAL_LOGIN" -q "$PROJECT_NAME""-test" -a "$BUNDLE_ID_STAGING" -b "$DEVELOPMENT_TEAM_ID" --skip_itc
}

function askAndStoreFastlaneCredentials() {
	echo "--- Please input password for $DEVPORTAL_LOGIN apple developer account ---"
	fastlane fastlane-credentials add --username $"$DEVPORTAL_LOGIN"
}

function getProfiles() {

    #fastlane match development --username "$DEVPORTAL_LOGIN"
	fastlane match appstore -u "$DEVPORTAL_LOGIN"
	
	#fastlane match adhoc --username "$DEVPORTAL_LOGIN"
}

function createGitRepo() {

    echo "--- create GitRepo"
	status_code=1
	rof=$((status_code/100))
	while [ $rof -ne 2 ]
	do

	echo
	#echo "Enter your GitHub login: "
	read -p "Enter your GitHub login: " gh_user
	echo -n "Password: "
	read -s password
	echo

    reponame=$PROJECT_NAME
    echo "--- Creating repo: $reponame"
	response=$(curl -u $gh_user:$password \
	--write-out \\n%{http_code} \
	--silent \
	https://api.github.com/user/repos \
	-d "{\"name\":\"$reponame\"}")

	status_code=$(echo "$response" | sed -n '$p')
	html=$(echo "$response" | sed '$d')
	echo status_code=$status_code
	rof=$((status_code/100))

	done

	repo="git@github.com:$gh_user/$reponame.git"
	git init
	git add .
	git commit -a -m "initial"
	git remote add origin $repo
	git push -u origin master
}

setup
