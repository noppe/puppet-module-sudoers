

class sudoers::puppetmaster(
  $puaserver = undef,
  $user      = undef,
  $keypath   = undef,
) {

  file { '/opt/eis_pua' : 
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755', 
  } ->
  file { '/opt/eis_pua/bin' :
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755', 
  } ->
  file { '/opt/eis_pua/bin/fetch' :
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755', 
    content => template( 'sudoers/fetch.erb' )
  }
}

