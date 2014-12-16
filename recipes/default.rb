#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2014, Maestrano
#
# All rights reserved - Do Not Redistribute
#

# Configure PHP-FPM
include_recipe "php-fpm" 

php_fpm_pool "wordpress" do
  listen "127.0.0.1:9000"
  user node['wordpress']['install']['user']
  group node['wordpress']['install']['group']
  if node['platform'] == 'ubuntu' and node['platform_version'] == '10.04'
    process_manager 'dynamic'
  end
  listen_owner node['wordpress']['install']['user']
  listen_group node['wordpress']['install']['group']
  php_options node['wordpress']['php_options']
  start_servers 5
end

# Configure NGINX
template "#{node['nginx']['dir']}/sites-enabled/wordpress.conf" do
  source "nginx.conf.erb"
  variables(
    :docroot          => node['wordpress']['dir'],
    :server_name      => node['wordpress']['server_name'],
    :server_aliases   => node['wordpress']['server_aliases'],
    :server_port      => node['wordpress']['server_port']
  )
  action :create
end

# Install WORDPRESS
directory node['wordpress']['dir'] do
  action :create
  recursive true
  if platform_family?('windows')
    rights :read, 'Everyone'
  else
    owner node['wordpress']['install']['user']
    group node['wordpress']['install']['group']
    mode  '00755'
  end
end

archive = platform_family?('windows') ? 'wordpress.zip' : 'wordpress.tar.gz'

if platform_family?('windows')
  windows_zipfile node['wordpress']['parent_dir'] do
    source node['wordpress']['url']
    action :unzip
    not_if {::File.exists?("#{node['wordpress']['dir']}\\index.php")}
  end
else
  tar_extract node['wordpress']['url'] do
    target_dir node['wordpress']['dir']
    creates File.join(node['wordpress']['dir'], 'index.php')
    user node['wordpress']['install']['user']
    group node['wordpress']['install']['group']
    tar_flags [ '--strip-components 1' ]
    not_if { ::File.exists?("#{node['wordpress']['dir']}/index.php") }
  end
end
