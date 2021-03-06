# puppet-module-sudoers
===

Manage sudoers with PUA

[![Build Status](https://travis-ci.org/Ericsson/puppet-module-sudoers.svg?branch=master)](https://travis-ci.org/Ericsson/puppet-module-sudoers)

===

# Compatibility

This module is built for use with Puppet v2 and Puppet v3 and is tested on the following OS families.

* EL 5
* EL 6
* Solaris 11
* Suse 11
* Ubuntu 12.04 LTS

===

# Dependencies

puppetlabs/stdlib (http://forge.puppetlabs.com/puppetlabs/stdlib/3.2.0)

===

# Parameters

hiera_merge
-----------
Boolean to merges all found instances of sudoers::preamble in Hiera. This is useful for specifying
different sudoers rules at different levels of the hierarchy and having them all included in the catalog.

This will default to 'true' in future versions.

- *Default*: false


target
------
Destination of sudoers file. For clients with more than one sudo installed, it is possible to pass an array with multiple destinations.

- *Default*: '/etc/sudoers'


source
------
*Only needed for PUA master server.* Data sources to provide sudoers rules. At the moment only PUA is supported. 

- *Default*: 'PUA'


target_dir
----------
Directory to copy the temporary sudoers file for later visudo checking. If not available, it will be created.

- *Default*: '/etc/sudoers.d'


target_file
-----------
Filename for the temporary sudoers file for later visudo checking.

- *Default*: '._check_~'


path
----
Path for executing visudo check commands. visudo needs to be found in these paths.

- *Default*: '/bin:/usr/bin:/sbin:/usr/sbin:/opt/csw/sbin:/opt/quest/sbin:/app/sudo/1.8.6p8/bin:/app/sudo/1.8.6p8/sbin'


preamble
--------
preamble contains the lines that should be included in sudoers. These lines will be above the rules generated by PUA.
This can be used to pass aliases like Cmnd_Alias or User_Alias to the final sudoers file.
If $hiera_merge is set to true, preamble will be merged through the levels of hiera.

- *Default*: ''


fetcher
-------
*Only needed for PUA master server.* Name of the script to fetch the sudo rules.

- *Default*: 'fetch2.pl'

owner
-----
Owner of sudoers file(s). Owner of $target, $target_dir and $target_file.

- *Default*: 'root'


group
-----
Group of sudoers file(s). Group of $target, $target_dir and $target_file.

- *Default*: 'root'


mode
----
Mode of sudoers file(s). Mode of $target, $target_dir and $target_file.

- *Default*: '0440'

===

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

<pre>
class { 'sudoers::puppetmaster':
  puaserver  => 'puamaster',
  puauser    => 'puausername',
  puacommand => '/opt/eis_pua/bin/serve',
  keypath    => 'path_to_private_key',
}
</pre>

2. Apply the config on the masters

## Preparing the PUA master
1. Setup PUA according to the documentation
2. Copy the contents of the ssh public key generated on the puppet masters to .ssh/authorized_keys of the PUA user on the PUA master
3. Define the following in the puppet manifest for the PUA master
<pre>
include sudoers::puaserver
</pre>

4. Apply puppet config on the PUA master

### Puppet config for clients

For clients using standard sudo with sudoers in /etc, the default values should do.

For clients with for example both quest-sudo and standard sudo, you can define multiple target destinations as following:
<pre>
class { 'sudoers':
    target => ['/etc/sudoers','/etc/opt/quest/sudo/sudoers']
}
</pre>

You can also redefine PATH, which is needed in cases where visudo is not in the general paths, /bin:/sbin:/usr/bin:/usr/sbin. Check init.pp for more variables

### Puppet config for Solaris clients
For Solaris systems, define the sudo_adminfile and sudo_pkg_source to get packages installed

<pre>
include sudoers::sudo
</pre>

in hiera
<pre>
#<source>
sudoers::sudo::sudo_adminfile: '/path-to_admin_file'
sudoers::sudo::pkg_source: '/path_to_package_source'
#</source>
</pre>

or use pkgutil to install CSWsudo
proxy should be set accordingly &
pkgutil CSW package should already be set up on the system.

<pre>
# <provider>
sudoers::sudo::provider: 'pkgutil'
# </provider>
</pre>

Note that there is also a sudo/visudo binary in AFS path /app/sudo/* that can be used on Sparc systems.
In this case no local sudo package installation is necessary.
