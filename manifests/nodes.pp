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

  ::mysql::db { 'oodb':
    user     => 'oouser',
    password => 'secretp',
    host     => '%',
  }

  class { '::mysql::server::backup':
    backupdir => '/backups',
    backupuser => 'oouser',
    backuppassword => 'secretp',
    backupcompress => 1,
    backuprotate => 5,
    backupdatabases => ['oodb'],
    file_per_database => 1,
    time => ['2', '10'],
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
