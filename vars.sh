# ====================================================================
# Modify this file and set variables as required for your deployment
# ====================================================================

# This is used as a prefix for resource names as well as the resource group name, and the DNS prefix of the public IP
export TF_VAR_name="myvpn"

# Azure region to deploy to
export TF_VAR_location="uksouth"

# VM size to deploy
export TF_VAR_vmsize="Standard_B1s"