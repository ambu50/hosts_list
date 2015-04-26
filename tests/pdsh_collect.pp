# Example of a collector only which collects all hosts and stores the result in
# a shared location for all hosts to use the resulted file. This profile also
# takes care of creating the directory structure and linking the network shared
# folder to the local file system

# In this example we are configuring the host list for the prallel shell
# "pdsh" command which we use to execute commands for a group of nodes

# You can have one of the following three configuration:
#  * All hosts export and collect, in this case use pdsh_export_collect in
# all nodes
#  * All hosts export but dedicated host collect and share the result over a
# shared folder. Use export only for the hosts and collect only
# for the collector
#  * All hosts export including the dedicated collector and only the collector
# export and collect. Use pdsh_export_collect for the collector and pdsh_export
# for all the other hosts. This is useful when there is a need to include the
# collector in the resulted host list

class pdsh_collect {

  $cluster = $::ecc_clustername
  $directory = '/etc/dsh/group'
  $dsh = '/etc/dsh'

  file { $dsh:
    ensure => 'directory',
  }

  ->

  file { $directory:
    ensure => 'link',
    force  => true,
    target => '/enod/hpc/dsh/group',
  }

  ->

  ::hosts_list::collect{ $cluster:
    directory  =>  $directory,
  }

}
