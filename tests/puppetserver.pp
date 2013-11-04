class { 'sudoers::puppetmaster' :
  puaserver => 'esekilx6021',
  user => 'local',
  keypath => '/home/local/.ssh/id_dsa',
}
# Add fetcher => '...' above. Supplied is fetch and fetch2.pl (default). 
# If using a custom fetcher, supply the full path to it. 
 
