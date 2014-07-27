#
# simple rake file to perform a few taks in setting up the Chef server environment
#
require 'chef'

# task to install the chef client on your workstation
task :install_chef do
  puts "\n\nMake sure to enter your password when prompted\n\n"
  sh 'curl -L https://www.opscode.com/chef/install.sh | sudo bash'
end

task :setup_server do
  sh './setup_server.sh'
end

task :sync_repo do
  sh 'cd chef-repo; knife upload / -c ../knife_config/knife.rb'
end

# task to cleanup all the leftover nodes
task :wipe_chef_nodes do
  config = File.join(File.dirname(__FILE__), 'knife_config', 'knife.rb')
  Chef::Config.from_file(config)

  Chef::ApiClient.list.keys.each do |client|
    next if client == 'chef-validator' || client == 'chef-chef-webui'
    client_to_kill = Chef::ApiClient.load(client)
    puts "Deleting client #{client_to_kill}"
    client_to_kill.destroy
  end

  Chef::Node.list.keys.each do |node|
    next if node == 'chef-validator' || node == 'chef-chef-webui'
    node_to_kill = Chef::Node.load(node)
    puts "Deleting node #{node_to_kill}"
    node_to_kill.destroy
  end

end
