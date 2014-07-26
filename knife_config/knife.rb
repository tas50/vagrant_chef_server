current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               "#{current_dir}/../.tmp/admin.pem"
validation_client_name   'chef-validator'
validation_key           "#{current_dir}/../.tmp/validation.pem"
chef_server_url          'https://192.168.100.101'
cache_type               'BasicFile'
cache_options(:path => "#{ENV['HOME']}/.chef/checksums")
cookbook_path            ["#{current_dir}/../chef-repo/cookbooks"]
