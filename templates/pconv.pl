#!/usr/bin/env perl

use strict ; 
use warnings ;
use Socket ;
use POSIX qw\strftime\ ;

# define largest and smallest used subnetmask

my $lowmask = 16 ; 
my $highmask = 30 ;

# use CIDR or non CIDR masks.. or both, both are recommended as a start

my $usenoncidr = 1 ; 
my $usecidr = 1 ;

# set to 0 to run command locally and 1 to use ssh

my $usessh = 0 ;

# command that serves PUA data

my $command = ('/opt/eis_pua/bin/serve') ;

#ssh options

my @cmd = ('ssh') ;

#my @cmd = ('echo') ;

# add parameters to commandline if ssh is used

if ($usessh == 1) { 
  push @cmd, '-q' ; 
  push @cmd, '-oUserKnownHostsFile=/var/lib/puppet/ssl/puahostfile' ; 
  push @cmd, '-i/opt/eis_pua/id_rsa' ; 
  push @cmd, 'esekipua@esekilx6021.rnd.ericsson.se' ; 
  push @cmd, $command ; 
} else {
  @cmd = () ;
  push @cmd, $command ;
}

# get ipadresses from commandline

my @ip = grep (/\d+\.\d+\.\d+.\d.*/, @ARGV)  ;
my $output = join " ",@ARGV ;

# check that any ipadress was provided

if (@ip) {

# iterate over provided ip's and add possible subnets to commandline

  foreach (@ip) {

    if ($_ =~ /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(:(\d{1,5}))?/) {

      #iterate over possible masks

      for (my $netmask = $lowmask ; $netmask <= $highmask ; $netmask++) {
        my $ip_address_binary = inet_aton ( $_ ) ;
        my $netmask_binary    = ~pack ("N", (2 ** (32 - $netmask)) - 1) ;
        my $network_address   = inet_ntoa ( $ip_address_binary & $netmask_binary ) ;
        if ($usecidr == 1) {
          $output = $output . ' ' . $network_address . '/' . $netmask ;
        }

        if ($usenoncidr == 1) {
          my $mask = pack ("N", -(1 << (32 - ($netmask % 32)))) ;

          for ($mask) { $_ = join ('.', unpack ("C4", $_)) }
          $output = $output . ' ' . $network_address . '/' . $mask ;
        }
      }

    } else {
      die "argument contains nonvalid ip-adress!\n" ;
    }
  }
} else {
  die "ip-address is not supplied!\n" ;
}

print $output, "\n" ;

