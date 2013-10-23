#
# Class sudoers
#   - Handle sudoers file
# ===

class sudoers(
  $target       = '/etc/sudoers',
  $source       = 'PUA',
  $defaults     = undef,
  $check_target = '/etc/sudoers.d/._check_~',
  $path         = '/bin:/usr/bin:/sbin:/usr/sbin',
  $preamble     = '',

) {
  
  case $source {
    'PUA' : {
      $rules = generate( '/opt/eis_pua/bin/rules', $::hostname, $::fqdn, $::ipaddess)
      $content = template( 'sudoers/sudoers.erb' )
    }
    default : {
      fail( "Sorry, I don't know how to handle ${source} yet." )
    }
  }

  file { 'check_sudoers_file' :
    ensure  => 'present', 
    path    => $check_target,
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => $content,
    notify  => Exec[ 'check_sudoers_cmd' ],
  }

  exec { 'check_sudoers_cmd' :
    command     => "visudo -cf $check_target",
    path        => $path,
    refreshonly => true,
    notify      => Exec[ 'deploy_sudoers' ],
  }

  exec { 'deploy_sudoers' :
    command => "cp -f \"${check_target}\" \"${target}\"",
    path    => $path,
    notify  => Exec[ 'sudoers_cleanup_cmd' ],
  }

  exec { 'sudoers_cleanup_cmd' :
    command     => "/bin/rm -f ${check_target}",
    path        => $path,
    refreshonly => true,
  }
}
