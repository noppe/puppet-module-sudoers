class { 'sudoers::puppetmaster' :
  puaserver => 'esekilx6021',
  user => 'local',
  keypath => '/home/local/.ssh/id_dsa',
}
 
