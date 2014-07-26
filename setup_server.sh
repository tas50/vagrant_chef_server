#!/bin/bash
echo "This script will provision a chef server, grab the validation.pem file, "
echo "and upload the contents of the repo to that server"
echo ""
read -p "Press any key to begin the setup..."
echo ""

# make temp dir to store validation.pem file.  Delete the old one if it's there
rm -rf .tmp
mkdir .tmp

echo ""
echo "Vagrant up-ing the chef server"
echo ""
cd systems/0.chef_server
vagrant destroy -f
vagrant up

echo ""
echo "Grabbing the admin.pem and validation.pem file off the server"
echo ""
cd ../..
scp -o StrictHostKeyChecking=no -i ~/.vagrant.d/insecure_private_key vagrant@192.168.100.101:/home/vagrant/chef-validator.pem .tmp/validation.pem
scp -o StrictHostKeyChecking=no -i ~/.vagrant.d/insecure_private_key vagrant@192.168.100.101:/home/vagrant/admin.pem .tmp/admin.pem

echo ""
echo "Uploading contents of chef-repo to the server"
echo ""
knife upload / -c knife_config/knife.rb
