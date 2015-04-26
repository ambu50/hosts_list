# hosts_list
#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with hosts_list](#setup)
    * [What hosts_list affects](#what-hosts_list-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with hosts_list](#beginning-with-hosts_list)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes] (#classes)
        * [export] (#export)
        * [collect] (#collect)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The module creats hosts list file to be used by applications that expects such a list. The output is a file that lists all contributed hosts one hostname per line. The module is conpatible with Linux and Linux like operating systems

## Module Description
The module uses exported resources Puppet feature to allow the contributed hosts to announce (export) their host names, then a single or multiple collectors collect the host names and stores them in a file. The module allows you to specify where you want to store the file so that it can be used by any application expecting hosts list. One example of applications that can use the genereted hosts list is "pdsh" parallel shell linux command which is heavely used to manage high performance computing (HPC) hosts by running shell commands on all hosts in parallel.

You can have one of the following three configuration:
* All hosts export and collect, in this case you need to call the export module then the collect module in every host
* All hosts export but dedicated host collect and share the result over a shared folder. In this case call export only for all the hosts and call collect only for the centrelized collector
* All hosts export including the centerlized collector and only the collector export and collect. In this case call export and collect in the centerlized collector and export only for all the other hosts. This is useful when there is a need to include the collector in the resulted host list


## Setup

### What hosts_list affects

host_list doesn't modify anything in the system, it only creats a single file contains a list of all contributing hosts. For the list to be complete, the export module has to be executed at least once on all the export hosts before the collect module is executed on the collector. This should happen automatically by time. 

Please note that the module doesn't create the directory structure needed to store the resulted host list, so make sure to create the directory in your profile. You can check our test files for a use case example.

### Beginning with hosts_list

To start using host_list, you need to identify your exporters and your collectors. The exporters are all the hosts that need to exists in the resulted host file and the collector is any host that need to have the resulted file. Then you need to write an export profile that configure and call the export module and a collector profile that configure and call the collect profile. Say you want all nodes to generate the host list file, then you need to create a profile as follow:

```
include pdsh_export_collect
```


The you need to configure the export and collect modules by providing them the name of the file generated and where to store it. Also you need to create the directory where you want to store the file if needed
```
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
```


## Usage

You can seprate the export and collect into two different classes and call the right profile for each type of nodes. You can find an example of seprate export and collect classes in the test directory

## Reference

This module consists of two sub modules, collect and export:

### Classes
#### export
This class uses the exported resources feature in Puppet to create a host list file and inserts the local host name in that file. Because this is an exported resource, practically, calling this class will only generate an empty host list file. For the file_line to take effect, the collect class has to be called which will execute the file_line exported by all the other hosts which assimbles the host list

**Parameters within `export`:**
##### group
It is the name of the resulted file or the name of the resulted group of hosts

##### hostname
The hostname the node is contributing to the host list, by default it is the localhost

##### directory
The directory where the resulted file should be stored

##### owner, grp, mode
These are the standard access control for the generated file

#### collect
 This class collects the exported hosts and stores the result in a host list file. After that is sorts the list for a cleaner result. This class needs to be called by any host that needs to generate the host list or by a centrlized collector which takes care of creating the file then share it with the other hosts via network shared folder.

**Parameters within `collect`:**
##### group
It is the name of the resulted file or the name of the resulted group of hosts

##### hostname
The hostname the node is contributing to the host list, by default it is the localhost

##### directory
The directory where the resulted file should be stored

##### owner, grp, mode
These are the standard access control for the generated file
=======
Puppet module that generates a file contains vertical host list of a certain group such as a cluster using Puppet exported resources
