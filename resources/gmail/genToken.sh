#!/bin/bash
#----------------------------------------------------------------------------------------------------
#Script to generate access token for Gmail blocklet.
#----------------------------------------------------------------------------------------------------
while getopts ":c:" opt; do
	case $opt in
		c) configFile="$OPTARG" ;;
		\?) echo "Invalid option -$OPTARG" >&2 ;;
	esac
done
source $configFile

#Generates JSON which has to be POSTed
generateJSON() {
	cat << EOF
{
	"code":"${oauthCode}",
	"client_id":"${clientId}",
	"client_secret":"${clientSecret}",
	"grant_type":"authorization_code",
	"redirect_uri":"${redirectUri}"
}
EOF
}

#Open user consent window
xdg-open "https://accounts.google.com/o/oauth2/v2/auth?\
	client_id=${clientId}&\
	login_hint=${email}&\
	redirect_uri=${redirectUri}&\
	response_type=code&\
	scope=${scope}&\
	access_type=offline";

#Fetch the authorization code
oauthCode=`nc -lW 1 $port | head -1 | sed -nr "s/.*code=(.*)&.*/\1/p"`;

#Fetch and save access, refresh tokens as JSON
curl -s https://www.googleapis.com/oauth2/v4/token \
	-H "Content-Type: application/json" \
	-d "$(generateJSON)" > $tokenFile;
