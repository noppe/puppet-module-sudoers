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
      $rules = generate( '/opt/eis_pua/bin/rules', $::hostname )
      $content = template( 'sudoers/sudoers.erb' )
    }
    default : {
      fail( "Sorry, I don't know how to handle ${source} yet." )
    }
  }

  sudoers::frag { 'check_sudoers_file' :
    path => $check_target,
    prio => '10',  
  }
}
