#!/bin/bash
# Initilize Variables
apiProjectDirInput="testDir"
uiProjectDirInput="testDir"
uhUsername="uhusername"
grouperPassword="groupPass"
user=$(whoami)

# Welcome message that explains what this tool is
echo ""
echo ""
echo "Welcome to the UH Groupings Project!"
echo "This script will create your overrides file (macOS and Linux)."
echo "Please be sure you know what this script is doing, it may cause issues in the future if unsure."
echo "Hope this tool helps make the process of setting up your environment easier!"
echo "Feel free to edit this script to improve it."
echo ""

# Read input from the user and set the input to the variables pre-initilized above
read -r -p "Enter UH Groupings API project directory (drag and drop uh-groupings-api directory in this window and press enter: " apiProjectDirInput
read -r -p "Enter UH Groupings UI project directory (drag and drop uh-groupings-ui directory in this window and press enter: " uiProjectDirInput
read -r -p "Enter your UH Username (e.g. kobeya): " uhUsername
read -r -p "Enter the grouper password (get this from your mentor through secure filedrop, NEVER send this password through email or direct message): " grouperPassword

# If the config folder already exists, prompt the user to delete it
if [ -d "$HOME/.${user}-conf/" ]; then
  echo ""
  echo "ERROR: The \"$HOME/.${user}-conf/\" directory already exists. Please make sure it is not in your home directory and try again."
  echo "Since this directory starts with a '.', it is a hidden file. Ask another team member for assistance."
  read -p "Press Enter to exit..."
  exit 1
fi

# Create the directory with a properly interpolated name
mkdir -p "$HOME/.${user}-conf"
apiProjectDir1=${apiProjectDirInput//\\/}
uiProjectDir1=${uiProjectDirInput//\\/}

apiProjectDir=${apiProjectDir1//\'/}
uiProjectDir=${uiProjectDir1//\'/}

# Copies the skeleton file from the api project folder and creates a config file
cp "$apiProjectDir/uh-groupings-api-overrides.skeleton.properties" "$HOME/.${user}-conf/uh-groupings-api-overrides.properties"

# Using the Stream editor to edit the file
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' -e "s/^\(groupings\.api\.localhost\.user\s*=\s*\).*\$/\1$uhUsername/" $HOME/.${user}-conf/uh-groupings-api-overrides.properties
  sed -i '' -e "s/^\(groupings\.api\.test\.admin_user\s*=\s*\).*\$/\1$uhUsername/" $HOME/.${user}-conf/uh-groupings-api-overrides.properties
  sed -i '' -e "s/^\(grouperClient\.webService\.password\s*=\s*\).*\$/\1$grouperPassword/" $HOME/.${user}-conf/uh-groupings-api-overrides.properties

  if [[ "$emailPreference" == "yes" || "$emailPreference" == "y" || "$emailPreference" == "Yes" || "$emailPreference" == "Y" ]]; then
    sed -i '' -e "s/^#\(email\.send\.recipient\s*=\s*\).*\$/\1$emailPreference/" $HOME/.$user-conf/uh-groupings-api-overrides.properties
    sed -i '' -e "s/^\(email\.is\.enabled\s*=\s*\).*\$/\1true/" $HOME/.$user-conf/uh-groupings-api-overrides.properties
    sed -i '' -e "s/^\(email\.is\.enabled\s*=\s*\).*\$/\1true/" $HOME/.$user-conf/uh-groupings-ui-overrides.properties
  fi

else
  sed -i -e "s/^\(groupings\.api\.localhost\.user\s*=\s*\).*\$/\1$uhUsername/" $HOME/.${user}-conf/uh-groupings-api-overrides.properties
  sed -i -e "s/^\(groupings\.api\.test\.admin_user\s*=\s*\).*\$/\1$uhUsername/" $HOME/.${user}-conf/uh-groupings-api-overrides.properties
  sed -i -e "s/^\(grouperClient\.webService\.password\s*=\s*\).*\$/\1$grouperPassword/" $HOME/.${user}-conf/uh-groupings-api-overrides.properties

  if [[ "$emailPreference" == "yes" || "$emailPreference" == "y" || "$emailPreference" == "Yes" || "$emailPreference" == "Y" ]]; then
    sed -i -e "s/^#\(email\.send\.recipient\s*=\s*\).*\$/\1$emailPreference/" $HOME/.$user-conf/uh-groupings-api-overrides.properties
    sed -i -e "s/^\(email\.is\.enabled\s*=\s*\).*\$/\1true/" $HOME/.$user-conf/uh-groupings-api-overrides.properties
    sed -i -e "s/^\(email\.is\.enabled\s*=\s*\).*\$/\1true/" $HOME/.$user-conf/uh-groupings-ui-overrides.properties
  fi
  
fi

# Copies the skeleton file from the ui project folder and creates a config file
cp "$uiProjectDir/uh-groupings-ui-overrides.skeleton.properties" "$HOME/.${user}-conf/uh-groupings-ui-overrides.properties"

read -p "Press Enter to exit..."
exit 1