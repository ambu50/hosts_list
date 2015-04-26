# == Class: hosts_list::collect
#
# This class collects the exported hosts and stores the result in a host list 
#file. After that is sorts the list for a cleaner result. This class needs 
#to be called by any host that needs to generate the host list or by 
#a centrlized collector which takes care of creating the file then share it 
#with the other hosts via network shared folder.
#
# === Parameters
#
# $group: it is the name of the resulted file or the name of the resulted group
# of hosts
# $hostname: The hostname the node is contributing to the host list, by
# default it is the localhost
# $directory: the directory where the resulted file should be stored
# $owner, $grp, $mode are the standard access control for the generated file
#
# [*sample_parameter*]
#   $group     = "Web_Servers"
#   $directory = "/etc/servers_groups/"

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

define hosts_list::collect (
  $directory,
  $group     = $title,
) {

  $file = "${directory}/${group}"

  File_line <<| tag == $group |>> {notify => Exec["/bin/sort ${file} -o ${file}"]}

  exec { "/bin/sort ${file} -o ${file}":
  refreshonly => true,
  }

}
