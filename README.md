Vagrant Chef Server
===================
This repo contains a self provisioning chef server in Vagrant


Note in order to run this you'll need a local chef-client installed which can be installed with the following:

curl -L https://www.opscode.com/chef/install.sh | sudo bash

###Repository Components
####/systems
Vagrant definitions for individual systems are located in the systems directory.  Each system is a single vagrant file within a directory.

####/chef-repo
The chef-repo contains the environments, roles, cookbooks, and data bags that chef uses for configuration.  These files have been copied from the LVP chef-repo and the dev environment renamed to 'vagrant'.

###/knife_config
The knife.rb file used to upload contents to the Vagrant Chef server and also the encrypted_data_bag_secret file used by the clients to access encrypted secrets

###/setup_server.sh
The system defined at systems/0.chef_server/Vagrantfile is the Chef server.  In order to show a fully functional chef stack, as opposed to Chef-Solo or Chef-Zero, a full Chef server is built.  The system is built from our base Precise Vagrant box using the chef-server recipe, which is executed using chef-solo. Setup_server.sh script performs the following:
 * runs vagrant up
 * pulls down the validation.pem used to authenticate clients to the chef server
 * pulls down the admin.pem file used by knife to interact with the server
 * uploads the contents of the chef-repo to the chef-server

#### Alternative

(i.e. dependency-less assumptions; without knife on the local workstation)

```sh
# Ensure <repo root>/.tmp have pems for other vagrant deployments
scp -o StrictHostKeyChecking=no -i ~/.vagrant.d/insecure_private_key vagrant@192.168.100.101:/home/vagrant/chef-validator.pem .tmp/validation.pem
scp -o StrictHostKeyChecking=no -i ~/.vagrant.d/insecure_private_key vagrant@192.168.100.101:/home/vagrant/admin.pem .tmp/admin.pem

# Copy cookbooks up to server so we can manipulate with knife on server...
scp -rp -o StrictHostKeyChecking=no -i ~/.vagrant.d/insecure_private_key chef-repo vagrant@192.168.100.101:/home/vagrant

# On 0.chef_server node
knife user list -c /vagrant/knife.rb

## Update cookbooks on server (note / is relative to /home/vagrant/cookbooks path)
knife upload / -c /vagrant/knife.rb --chef-repo-path=~/chef-repo
```

### HOWTO

Getting a new cookbook:

```sh
knife cookbook site download zabbix
tar -xzf zabbix-*
mv zabbix <chef-repo path>/cookbooks/.
knife upload / ... # see server_setup / knife_config
# e.g. [vagrant@chef-server ~]$ knife upload / -c /vagrant/knife.rb --chef-repo-path=~/chef-repo
# Created /cookbooks/zabbix
```
