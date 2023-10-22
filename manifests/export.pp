# Class: hosts_list::export
#
# @summary This class uses the exported resources feature in Puppet to create
# a host list file and inserts the local host name in that file. Because this
# is an exported resource, practically, calling this class will only generate an 
# empty host list file. For the file_line to take effect, the collect class has
# to be called which will execute the file_line exported by all the other hosts
# which assimbles the host list
#
# @param group the name of the resulted file or the name of the resulted group
#   of hosts
# @param hostname The hostname the node is contributing to the host list, by default
#   it is the localhost
# @param directory the directory where the resulted file should be stored
#
# @example Refer to the examples folder
#  
# @author Ahmed Bu-khamsin <Ahmed.bukhamsin@aramco.com
#
# === Copyright
#
# Copyright 2015 Ahemd Bu-khamsin
#
define hosts_list::export (
  Stdlib::Absolutepath $directory,
  String[1]            $group     = $title,
  String[1]            $hostname  = $facts['networking']['hostname'],
) {
  file { "${directory}/${group}":
    ensure  => file,
  }

  @@file_line { "add ${hostname} to the group file":
    path => "${directory}/${group}",
    line => $hostname,
    tag  => $group,
  }
}
