# Class: hosts_list::collect
#
# @summary This class collects the exported hosts and stores the result
# in a host list file. After that is sorts the list for a cleaner result.
# This class needs to be called by any host that needs to generate the
# host list or by a centrlized collector which takes care of creating the
# file then share it with the other hosts via network shared folder.
#
# @param group it is the name of the resulted file or the name of the 
#   resulted group of hosts
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
define hosts_list::collect (
  Stdlib::Absolutepath $directory,
  String[1]           $group     = $title,
) {
  $file = "${directory}/${group}"

  File_line <<| tag == $group |>> { notify => Exec["/bin/sort ${file} -o ${file}"] }

  exec { "/bin/sort ${file} -o ${file}":
    refreshonly => true,
  }
}
