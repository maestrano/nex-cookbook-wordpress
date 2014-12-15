::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

node.set_unless['wordpress']['db']['pass'] = secure_password
node.set_unless['wordpress']['db']['host'] = ENV["MYSQL_PORT_3306_TCP_ADDR"]
node.save unless Chef::Config[:solo]

db = node['wordpress']['db']

mysql_connection_info = {
  :host     => db['host'],
  :username => 'root',
  :password => ENV["MYSQL_ENV_MYSQL_ROOT_PASSWORD"]
}

# Cesar: Create wordpress database and user
include_recipe "database"
include_recipe "mysql::client"

mysql_database db['name'] do
  connection  mysql_connection_info
  action      :create
end

require 'socket'
mysql_database_user db['user'] do
  connection    mysql_connection_info
  password      db['pass']
  host          "%"
  database_name db['name']
  action        :create
end

mysql_database_user db['user'] do
  connection    mysql_connection_info
  database_name db['name']
  privileges    [:all]
  action        :grant
end

# Cesar: Create wp-config.php 
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
node.set_unless['wordpress']['keys']['auth'] = secure_password
node.set_unless['wordpress']['keys']['secure_auth'] = secure_password
node.set_unless['wordpress']['keys']['logged_in'] = secure_password
node.set_unless['wordpress']['keys']['nonce'] = secure_password
node.set_unless['wordpress']['salt']['auth'] = secure_password
node.set_unless['wordpress']['salt']['secure_auth'] = secure_password
node.set_unless['wordpress']['salt']['logged_in'] = secure_password
node.set_unless['wordpress']['salt']['nonce'] = secure_password
node.save unless Chef::Config[:solo]

template "#{node['wordpress']['dir']}/wp-config.php" do
  source 'wp-config.php.erb'
  mode node['wordpress']['config_perms']
  variables(
    :db_name          => db['name'],
    :db_user          => db['user'],
    :db_password      => db['pass'],
    :db_host          => db['host'],
    :db_prefix        => db['prefix'],
    :db_charset       => db['charset'],
    :db_collate       => db['collate'],
    :auth_key         => node['wordpress']['keys']['auth'],
    :secure_auth_key  => node['wordpress']['keys']['secure_auth'],
    :logged_in_key    => node['wordpress']['keys']['logged_in'],
    :nonce_key        => node['wordpress']['keys']['nonce'],
    :auth_salt        => node['wordpress']['salt']['auth'],
    :secure_auth_salt => node['wordpress']['salt']['secure_auth'],
    :logged_in_salt   => node['wordpress']['salt']['logged_in'],
    :nonce_salt       => node['wordpress']['salt']['nonce'],
    :lang             => node['wordpress']['languages']['lang'],
    :allow_multisite  => node['wordpress']['allow_multisite']
  )
  owner node['wordpress']['install']['user']
  group node['wordpress']['install']['group']
  action :create
end