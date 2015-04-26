#This is an example of how to be an exporter and collector at the same time.
# In all cases you need to create the directory structure needed to store the
# resulted host file as the base module doesn't handle that part 
# You can have one of the following three configuration:
# #  * All hosts export and collect, in this case use pdsh_export_collect in
# all nodes
# #  * All hosts export but dedicated host collect and share the result over 
# a shared folder. Use export only for the hosts and collect only
# for the collector
# #  * All hosts export including the dedicated collector and only the
# collector export and collect. Use pdsh_export_collect for the collector 
# and pdsh_export for all the other hosts. This is useful when there is a need
# to include the collector in the resulted host list

class pdsh_export_collect {

  $cluster = $::ecc_clustername
  $directory = '/etc/dsh/group'
  $dsh = '/etc/dsh'

  file { $dsh:
    ensure    => 'directory',
  }

  ->

  file { $directory:
    ensure => 'link',
    force  => true,
    target => '/enod/hpc/dsh/group',
  }

  ->

  ::hosts_list::export{ $cluster:
    directory =>  $directory,
    before    =>  ::Hosts_list::Collect[$cluster],
  }

  ->

  ::hosts_list::collect{ $cluster:
    directory => $directory
  }

}
