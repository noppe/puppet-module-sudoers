#
# Class sudoers
#   - Handle sudoers file
# ===

class sudoers(
  $target       = '/etc/sudoers',
  $source       = 'PUA',
  $check_target = '/etc/sudoers.d/._check_~',
  $path         = '/bin:/usr/bin:/sbin:/usr/sbin',
  $preamble     = '',
  $fetcher      = 'fetch2.pl',

) {
  
  case $source {
    'PUA' : {
      $rules = generate( "/opt/eis_pua/bin/${fetcher}", $::hostname, $::fqdn, $::ipaddress)
      $content = template( 'sudoers/sudoers.erb' )
    }
    default : {
      fail( "Sorry, I don't know how to handle ${source} yet." )
    }
  }

  $owner = 'local'
  $group = undef
  $mode  = '0400'
  file { 'check_sudoers_file' :
    ensure  => 'present', 
    path    => $check_target,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    notify  => Exec[ 'check_sudoers_cmd' ],
  }

  exec { 'check_sudoers_cmd' :
    command     => "visudo -cf ${check_target} && cp ${check_target} ${check_target}.ok",
    path        => $path,
    refreshonly => true,
    notify => Exec[ 'sudoers_cleanup_cmd' ],
  }

  deploy_sudoers { $target : 
    check_target => $check_target
  }

  exec { 'sudoers_cleanup_cmd' :
    command     => "/bin/rm -f ${check_target}",
    path        => $path,
    refreshonly => true,
  }
}

define deploy_sudoers ($check_target) {
  file { $name :
    ensure => present,
    path   => $name,
    source => "${check_target}.ok",
    subscribe => Exec[ 'check_sudoers_cmd' ],
  }
}
