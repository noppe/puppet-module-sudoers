# sudoers module quick install guide:
## prerequesites
generate ssh-keys for the PUA user to a preferred location on or shared by the puppet masters and copy the contents of public key to .ssh/authorized_keys of the PUA master
add public ssh key for PUA host in /var/lib/puppet/ssl/puahostfile 
(permissions for the keyfiles should be 600 and owned by the puppet-user)
## applying the puppetclass on the master 

1. define something like the following for the puppetmasters

  class { 'sudoers::puppetmaster':
    puaserver  => 'puamaster',
    puauser    => 'puausername',
    puacommand => '/opt/eis_pua/bin/serve',
    keypath    => 'path_to_private_key',
  }

2. apply the config on the masters

## preparing the PUA master
1. setup PUA according to the documentation

1. copy the contents of the ssh public key generated on the puppet masters to .ssh/authorized_keys of the pua user on the pua master 
2. define the following in the puppet manisfest for the pua master
 include sudoers::puaserver
3. apply puppet config on the PUA master

## puppet config for clients
 
for the clients you can define multiple targets as following, if the default /etc/sudoers is not enough or the sudoers file should be placed elsewhere:
class { 'sudoers':
    target => ['/etc/sudoers','/etc/opt/quest/sudo/sudoers']
  }

you can also redefine search path i.e for some cases where visudo is not in the genral paths, check the init.pp for more variables 
