# Pritunl Server on Azure

The idea of this repo it is to give you the tools to be able to create a [Pritunl](https://pritunl.com/) server on Azure using a basic configuration.

The main goals of this are: 

1. Easy to admin VPN Server, with web UI for configuration 
2. Provide VPN users a static outbound IP
3. Easy to deploy server

## Pre-reqs
- Use of a bash shell (e.g. you are running WSL, Azure CloudShell, Linux or MacOS)
- Azure subscription
- Terraform with configured connection to Azure, i.e. Azure CLI logged in
- SSH private/public key pair in `~/.ssh/id_rsa` / `~/.ssh/id_rsa.pub` 

## TLDR Ultra High Level Guide
- Deploy server with supplied Terraform & scripts
- SSH to server to get admin password and setup key
- Configure server using admin web UI


# Deployment Guide

### Deploy resources with Terraform
- Edit `vars.sh` and configure the settings for `TF_VAR_name` and other values as required
- Run `./deploy.sh`
- Make a note of the values output
  
### Configure the Pritunl Server
> NOTE. When first connecting to the admin web console, you will get a security warning from your browser, please ignore this until a proper TLS cert is configured

- SSH to server using the output from the Terraform step
- Open admin console URL, you will be prompted for a one time database setup
  - From the SSH session execute `sudo pritunl setup-key` and paste the key into the page
  - Leave the MongoDB URI as is
  - Hit 'Save'
- You will be redirected to the login prompt
- From the SSH session execute `sudo pritunl default-password` to get the default admin credentials. **Make a note of these!**  
- Login as the default admin user
- The 'Inital Setup' page appears:
  - Check the 'Public Address' matches the `server_ip` output from the Terraform step
  - Enter your FQDN in the 'Lets Encrypt Domain' field to get a real cert issued
  - *Optional.* Change the admin password
  - Hit 'Save'
- Add a Server, an organization and one or more users using this guide https://docs.pritunl.com/docs/connecting
  - **IMPORTANT!** Make sure you specify port 11225 & UDP when adding the server
  - Note. If you tick the 'Enable Google Authenticator' option then users will be required to use 2FA to connect to the VPN

# User Instructions - Connecting to VPN
To add users navigate to 'Users' and setup a new user in whatever organization you created, optionally set a PIN for the new user

### Pre-reqs and Software
- [Download and install the VPN client](https://client.pritunl.com/#install)
- If you enabled 2FA, users will require an app installed & setup to generate one time codes, the [Microsoft Authenticator](https://www.microsoft.com/en-us/account/authenticator) is the suggested app to use

### Configure the VPN Client
This is a one time process, as follows:
- Access the admin web UI as described above
- Click the chain link icon 'Get temporary profile links' next to your user
- Open the link 'Temporary url to view profile links, expires after 24 hours' which will look like `https://broadside.uksouth.cloudapp.azure.com/k/zZzZzZzZ`
- From the user profile page:
  - Use the QR code to configure your authenticator app (add account -> other)
  - Use the `pritunl://` URI to configure the VPN client, using the 'Import Profile URI' button

### Connecting the Client
- Click the hamburger menu
- Click connect
- Enter PIN (If specified when you added user)
- If you enabled 2FA, enter OTP code from authenticator app

### Validate
After successfully connecting to the VPN validate your public IP is that of the server by going to https://ifconfig.me/ or running `curl ifconfig.me`