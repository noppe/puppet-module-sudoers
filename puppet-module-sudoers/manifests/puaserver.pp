

class sudoers::puaserver(
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
  file { '/opt/eis_pua/bin/serve' :
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0755', 
    content => template( 'sudoers/serve.erb' )
  }
}

