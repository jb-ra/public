#!/bin/bash

# Ask for GitHub account and repo name
echo "Enter your GitHub account name:"
read github_account

echo "Enter the repository name:"
read repo_name

# Define the SSH key file path
ssh_key_path="$HOME/.ssh/id_rsa"

# Check if SSH key exists, if not, generate a new one
if [ ! -f "$ssh_key_path" ]; then
    echo "No SSH key found. Generating a new one..."
    ssh-keygen -t rsa -b 4096 -C "$github_account@github.com" -f "$ssh_key_path" -N ""
    echo "SSH key generated. Displaying public key for GitHub..."

    # Display the public key for user to copy
    cat "$ssh_key_path.pub"
    echo "Public key displayed above. Please copy it and add it to your GitHub account."
    echo "Visit https://github.com/settings/keys and click 'New SSH key'. Paste the public key and give it a title."

    # Pause until user confirms they have added the key
    while true; do
        read -p "Once you've added the key to GitHub, type 'OK' to continue: " confirm
        if [ "$confirm" == "OK" ]; then
            break
        else
            echo "Please make sure you've added the key to your GitHub account before typing 'OK'."
        fi
    done
else
    echo "SSH key found, proceeding with the repository setup."
fi

# Test SSH connection to GitHub
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com

if [[ $? -ne 1 ]]; then
    echo "SSH connection failed. Please check your SSH key and GitHub settings."
    exit 1
fi

# Clone the repository
echo "Cloning repository $repo_name from GitHub..."
git clone git@github.com:$github_account/$repo_name.git

echo "Repository cloned successfully!"

# End of script
