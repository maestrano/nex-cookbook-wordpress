default['wordpress']['version'] = 'latest'

default['wordpress']['db']['name'] = "wordpressdb"
default['wordpress']['db']['user'] = "wordpressuser"
default['wordpress']['db']['pass'] = "zehardtofindpass"
default['wordpress']['db']['prefix'] = 'wp_'
# HAS to be specified dynamically
# default['wordpress']['db']['host'] = 'localhost'
default['wordpress']['db']['charset'] = 'utf8'
default['wordpress']['db']['collate'] = ''

default['wordpress']['allow_multisite'] = false

default['wordpress']['config_perms'] = 0644
default['wordpress']['server_aliases'] = [node['fqdn']]
default['wordpress']['server_port'] = '80'

case node['platform']
when 'redhat', 'centos', 'scientific', 'fedora', 'amazon', 'oracle'
  default['wordpress']['install']['user'] = 'apache'
  default['wordpress']['install']['group'] = 'apache'
when 'suse', 'opensuse'
  default['wordpress']['install']['user'] = 'wwwrun'
  default['wordpress']['install']['group'] = 'www'
when 'arch'
  default['wordpress']['install']['user'] = 'http'
  default['wordpress']['install']['group'] = 'http'
when 'freebsd'
  default['wordpress']['install']['user'] = 'www'
  default['wordpress']['install']['group'] = 'www'
else
  default['wordpress']['install']['user'] = 'www-data'
  default['wordpress']['install']['group'] = 'www-data'
end

# Languages
default['wordpress']['languages']['lang'] = ''
default['wordpress']['languages']['version'] = ''
default['wordpress']['languages']['repourl'] = 'http://translate.wordpress.org/projects/wp'
default['wordpress']['languages']['projects'] = ['main', 'admin', 'admin_network', 'continents_cities']
default['wordpress']['languages']['themes'] = []
default['wordpress']['languages']['project_pathes'] = {
  'main'              => '/',
  'admin'             => '/admin/',
  'admin_network'     => '/admin/network/',
  'continents_cities' => '/cc/'
}
%w{ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty}.each do |year|
  default['wordpress']['languages']['project_pathes']["twenty#{year}"] = "/twenty#{year}/"
end
node['wordpress']['languages']['project_pathes'].each do |project,project_path|
  # http://translate.wordpress.org/projects/wp/3.5.x/admin/network/ja/default/export-translations?format=mo
  default['wordpress']['languages']['urls'][project] =
    node['wordpress']['languages']['repourl'] + '/' +
    node['wordpress']['languages']['version'] + project_path +
    node['wordpress']['languages']['lang'] + '/default/export-translations?format=mo'
end

if node['platform'] == 'windows'
  default['wordpress']['parent_dir'] = "#{ENV['SystemDrive']}\\inetpub"
  default['wordpress']['dir'] = "#{node['wordpress']['parent_dir']}\\wordpress"
  default['wordpress']['url'] = "https://wordpress.org/wordpress-#{node['wordpress']['version']}.zip"
else
  default['wordpress']['server_name'] = node['fqdn']
  default['wordpress']['parent_dir'] = '/app'
  default['wordpress']['dir'] = "#{node['wordpress']['parent_dir']}/wordpress"
  default['wordpress']['url'] = "https://wordpress.org/wordpress-#{node['wordpress']['version']}.tar.gz"
end

default['wordpress']['php_options'] = { 'php_admin_value[upload_max_filesize]' => '50M', 'php_admin_value[post_max_size]' => '55M' }
