#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Change these if you have keys in weird places
SSH_KEY_PUB="$HOME/.ssh/id_rsa.pub"
SSH_KEY_PRIV="$HOME/.ssh/id_rsa"

# Preamble banner
echo -e "\n\e[34m╭───────────────────────────────╮"
echo -e "│\e[32m  Pritunl VPN Server Deployer\e[34m  │"
echo -e "╰───────────────────────────────╯"
echo -e "\e[35m🚀  v0.0.1\n"

# Pre-checks
echo -e "\e[34m»»» 🔎 \e[96mRunning pre checks\e[0m..."
az > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️  Azure CLI is not installed! 😥 Please go to http://aka.ms/cli to set it up"
  exit 1
fi

terraform version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo -e "\e[31m»»» ⚠️  Terraform is not installed! 😥 Please go to https://www.terraform.io/downloads.html to set it up"
  exit 1
fi

if [ ! -e "$SSH_KEY_PUB" ]; then
  echo -e "\e[31m»»» ⚠️  SSH public key file $SSH_KEY_PUB was not found or was invalid"
  exit 1
fi
if [ ! -e "$SSH_KEY_PRIV" ]; then
  echo -e "\e[31m»»» ⚠️  SSH private key file $SSH_KEY_PRIV was not found or was invalid"
  exit 1
fi
set -e

# Load variables
source $DIR/vars.sh
echo -e "\e[34m»»» 🧙 \e[96mThis will create/reconfigure the environment with:\e[0m"
printenv | grep TF_VAR

export SUB_ID=$(az account show --query id -o tsv)
export TENANT_ID=$(az account show --query tenantId -o tsv)
if [ -z $SUB_ID ]; then
  echo -e "\n\e[31m»»» ⚠️  You are not logged in to Azure!"
  exit
fi

echo -e "\e[34m»»» 🔨 \e[96mAzure details from logged on user \e[0m"
echo -e "\e[34m»»»   • \e[96mSubscription: \e[33m$SUB_ID\e[0m"
echo -e "\e[34m»»»   • \e[96mTenant:       \e[33m$TENANT_ID\e[0m"

terraform init
terraform apply -var "ssh_key_pub=$SSH_KEY_PUB" -var "ssh_key_priv=$SSH_KEY_PRIV"