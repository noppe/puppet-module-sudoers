# Sudoers module
## Purpose
The Purpose of this module is to provide sudoers rules and content from PUA
It is meant as an interims module to be used until sudo handling been
unified on the hubs. 
### Usage
For servers using old eis_sudo module: Remove eis_sudo from nodes manifest, and insert sudoers instead. Set parameters necessary to support i.e quest-sudo
This will leave the sudo binaries unmaintained, but that is acceptable
during a limited time period, until QAS  4 is deployed.

## Sudoers module quick install guide:
### Prerequesites
Generate ssh-keys for the PUA user to a preferred location on, or shared by, the puppet masters and copy the contents of the public key to .ssh/authorized_keys of the PUA master
Add public ssh key for PUA host in /var/lib/puppet/ssl/puahostfile 
Permissions for the keyfiles should be 600 and owned by the puppet-user
### Applying the puppetclass on the master 

1. Define something like the following for the puppetmasters

  class { 'sudoers::puppetmaster':
    puaserver  => 'puamaster',
    puauser    => 'puausername',
    puacommand => '/opt/eis_pua/bin/serve',
    keypath    => 'path_to_private_key',
  }

2. Apply the config on the masters

## Preparing the PUA master
1. Setup PUA according to the documentation

1. Copy the contents of the ssh public key generated on the puppet masters to .ssh/authorized_keys of the pua user on the pua master 
2. Define the following in the puppet manisfest for the pua master
 include sudoers::puaserver
3. Apply puppet config on the PUA master

### Puppet config for clients

For clients using standard sudo with sudoers in /etc, the default values should do.
 
For clients with for example both quest-sudo and standard sudo, you can define multiple target destinations as following:
class { 'sudoers':
    target => ['/etc/sudoers','/etc/opt/quest/sudo/sudoers']
  }

You can also redefine PATH, which is needed in cases where visudo is not in the general paths, /bin:/sbin:/usr/bin:/usr/sbin. Check init.pp for more variables 
