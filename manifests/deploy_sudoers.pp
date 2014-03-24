define sudoers::deploy_sudoers ($check_target) {
  file { $name :
    ensure    => present,
    path      => $name,
    mode      => $sudoers::mode,
    source    => "${check_target}.ok",
    subscribe => Exec[ 'check_sudoers_cmd' ],
  }
}
