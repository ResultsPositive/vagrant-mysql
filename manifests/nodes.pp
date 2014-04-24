node default {}

node 'mysql01.ghostlab.net' {
  class { '::base': }

  package { ['nano', 'git', 'screen', 'vim-enhanced', 'rsync', 'bind-utils']:
    ensure => installed,
  }

  class { '::mysql::server':
    root_password    => 'strongpassword',
    override_options => { 'mysqld' => { 'max_connections' => '1024' } }
  }
 
  mysql_user { 'oouser@%':
    ensure                   => 'present',
    max_connections_per_hour => '0',
    max_queries_per_hour     => '0',
    max_updates_per_hour     => '0',
    max_user_connections     => '0',
  }

  mysql_grant { 'oouser@%/oodb.*':
    ensure     => 'present',
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => '*.*',
    user       => 'oouser@%',
  }

  mysql_database { 'oodb':
    ensure  => 'present',
    charset => 'utf8',
    collate => 'utf8_swedish_ci',
  }
  
  firewall { '3360 accept MySQL Traffic':
    proto   => 'tcp',
    port    => '3360',
    action  => 'accept',
  }

  firewall { '6379 accept Redis Traffic':
    proto   => 'tcp',
    port    => '6379',
    action  => 'accept',
  }

  class { 'redis':
    conf_port => '6379',
    conf_bind => '0.0.0.0',
    system_sysctl => true,
    require => Class['epel'],
  }
}
