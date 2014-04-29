node default {}

node 'mysql01.ghostlab.net' {
  class { '::base': }
  class { '::epel': }

  package { ['nano', 'git', 'screen', 'vim-enhanced', 'rsync', 'bind-utils']:
    ensure => installed,
  }

  class { '::mysql::server': }

  firewall { '3306 accept MySQL Traffic':
    proto   => 'tcp',
    port    => '3306',
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
