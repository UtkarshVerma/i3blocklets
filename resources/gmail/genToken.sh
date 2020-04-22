#!/bin/bash
#----------------------------------------------------------------------------------------------------
# Script to generate access token for Gmail blocklet.
# Requires jq - https://stedolan.github.io/jq
#----------------------------------------------------------------------------------------------------
# Default config path.
configFile="~/.gmail"

# Read CLI arguments.
while getopts ":c:" opt; do
	case $opt in
		c) configFile="$OPTARG";;
		\?) echo "Invalid option -$OPTARG" >&2;;
	esac
done

eval configFile=$configFile;
source $configFile || exit 1
eval tokenFile=$tokenFile

scope="https://www.googleapis.com/auth/gmail.labels"
redirectURL="http://localhost:"

# Find a random unused local port.
while :
do
	if [[ "$(netstat -lntu | grep -c ":$port")" -gt "0" ]]
	then
		port=$(( $RANDOM % 4000 ))
	else
        redirectURL+="$port"
        break
	fi
done

# Generates JSON which has to be POSTed.
generateJSON() {
	cat << EOF
{
	"code":"$oauthCode",
	"client_id":"$clientID",
	"client_secret":"$clientSecret",
	"grant_type":"authorization_code",
	"redirect_uri":"$redirectURL",
}
EOF
}

# Open user consent window.
echo "Opening user-consent in web browser..."
sleep 2
authURL="\
https://accounts.google.com/o/oauth2/v2/auth?\
client_id=$clientID&\
redirect_uri=$redirectURL&\
response_type=code&\
scope=$scope&\
access_type=offline"
xdg-open $authURL

if [[ $? != 0 ]]
then
	echo -e "Could not open web browser. Open this link manually:\n$authURL"
	sleep 10
fi

# Fetch the authorization code.
oauthCode=`nc -lW 1 $port | head -1 | sed -nr "s/.*code=(.*)&.*/\1/p"`
if [[ $? != 0 ]]
then
	echo "Authorization code fetched successfully."
else
	echo "Failed to get authorization code."
	exit 33
fi

# Fetch and save access, refresh tokens as JSON.
mkdir -p $(dirname $tokenFile);
touch $tokenFile;
curl -s https://www.googleapis.com/oauth2/v4/token \
	-H "Content-Type: application/json" \
	-d "$(generateJSON)" > $tokenFile;
