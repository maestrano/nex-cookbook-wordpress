name             'wordpress'
maintainer       'Cesar Tonnoir'
maintainer_email 'it@maestrano.com'
license          'all_rights'
description      'Installs/Configures wordpress on a docker container (with linked Mysql container)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

recipe "wordpress", "Installs wordpress on the container"
recipe "wordpress:configure", "Creates wordpress database and user, and configures wp-config"

depends "nginx"
depends "database"
depends "mysql", "~> 5.5.0"
depends "tar"
depends "php-fpm"
depends "php"

%w{ debian ubuntu windows centos redhat scientific oracle }.each do |os|
  supports os
end

attribute "WordPress/version",
  :display_name => "WordPress download version",
  :description => "Version of WordPress to download from the WordPress site or 'latest' for the current release.",
  :default => "latest"

attribute "WordPress/checksum",
  :display_name => "WordPress tarball checksum",
  :description => "Checksum of the tarball for the version specified.",
  :default => ""

attribute "WordPress/dir",
  :display_name => "WordPress installation directory",
  :description => "Location to place WordPress files.",
  :default => "/var/www/wordpress"

attribute "WordPress/db/database",
  :display_name => "WordPress MySQL database",
  :description => "WordPress will use this MySQL database to store its data.",
  :default => "wordpressdb"

attribute "WordPress/db/user",
  :display_name => "WordPress MySQL user",
  :description => "WordPress will connect to MySQL using this user.",
  :default => "wordpressuser"

attribute "WordPress/db/password",
  :display_name => "WordPress MySQL password",
  :description => "Password for the WordPress MySQL user.",
  :default => "randomly generated"

attribute "WordPress/keys/auth",
  :display_name => "WordPress auth key",
  :description => "WordPress auth key.",
  :default => "randomly generated"

attribute "WordPress/keys/secure_auth",
  :display_name => "WordPress secure auth key",
  :description => "WordPress secure auth key.",
  :default => "randomly generated"

attribute "WordPress/keys/logged_in",
  :display_name => "WordPress logged-in key",
  :description => "WordPress logged-in key.",
  :default => "randomly generated"

attribute "WordPress/keys/nonce",
  :display_name => "WordPress nonce key",
  :description => "WordPress nonce key.",
  :default => "randomly generated"

attribute "WordPress/server_aliases",
  :display_name => "WordPress Server Aliases",
  :description => "WordPress Server Aliases",
  :default => "FQDN"

attribute "WordPress/languages/lang",
  :display_name => "WordPress WPLANG configulation value",
  :description => "WordPress WPLANG configulation value",
  :default => ""

attribute "WordPress/languages/version",
  :display_name => "Version of WordPress translation file",
  :description => "Version of WordPress translation file",
  :default => ""

attribute "WordPress/languages/projects",
  :display_name => "WordPress translation projects",
  :description => "WordPress translation projects",
  :type => "array",
  :default => ["main", "admin", "admin/network", "cc"]