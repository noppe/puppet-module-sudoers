class pua::sudo(
  $version = '1.8',
  $pkgname = 'sudo',
  $altname = 'sudo',
) {
  
  package { $pkgname :
    ensure => $version,
    alias  => $altname,
  }

  file { '/bin/sudo' :
    ensure  => link,
    target  => '/usr/bin/sudo,
    require => Package[ $altname ],
  }
}

