class { 'sudoers' :
  check_target => '/tmp/sudoers.tmp',
  target => [ '/tmp/sudoers', '/tmp/sudoers.quest', '/tmp/sudoers.ionable' ],
}
