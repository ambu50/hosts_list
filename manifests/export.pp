# == Class: hosts_list::export
#
# This class uses the exported resources feature in Puppet to create a host
# list file and inserts the local host name in that file. Because this is an 
# exported resource, practically, calling this class will only generate an 
# empty host list file. For the file_line to take effect, the collect class has
# to be called which will execute the file_line exported by all the other hosts
# which assimbles the host list
#
# === Parameters
#
# $group: it is the name of the resulted file or the name of the resulted group
# of hosts
# $hostname: The hostname the node is contributing to the host list, by default
# it is the localhost
# $directory: the directory where the resulted file should be stored
# $owner, $grp, $mode are the standard access control for the generated file
#
# [*sample_parameter*]
#   $group     = "Web_Servers"
#   $hostname  = $::hostname    ## this uses a fact that returns the local 
# host which is the default
#   $directory = "/etc/servers_groups/"
#   $owner     = "root"
#   $grp       = "root"
#   $mode      = "755"

# === Examples
#
#  
#  Refer to the test folder
#  
#
# === Authors
#
# Author Name: Ahmed Bu-khamsin <Ahmed.bukhamsin@aramco.com
#
# === Copyright
#
# Copyright 2015 Ahemd Bu-khamsin
#
define hosts_list::export (
  $directory,
  $group     = $title,
  $hostname  = $::hostname,
  $owner     = undef,
  $grp       = undef,
  $mode      = undef,
) {
  
  file { "${directory}/${group}":
    ensure  => present,
  }
  
  
  @@file_line { "add ${hostname} to the group file":
    path => "${directory}/${group}",
    line => $hostname,
    tag  => $group,
  }

}
