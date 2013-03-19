class riak {
  exec { "install": 
    command => "/usr/bin/dpkg --install /vagrant/riak_1.1.4-1_amd64.deb"
  }

  file {"/etc/riak/vm.args":
    content => template("riak/etc/riak/vm.args.erb"),
    require => Exec["install"]
  }

  file {"/etc/riak/app.config":
    content => template("riak/etc/riak/app.config.erb"),
    require => Exec["install"]
  }

  file {"/etc/riak/cert.pem":
    source => "puppet:///modules/riak/etc/riak/cert.pem",
    require => Exec["install"]
  }

  file {"/etc/riak/key.pem":
    source => "puppet:///modules/riak/etc/riak/key.pem",
    require => Exec["install"]
  }

  service {"riak":
    enable => true,
    ensure => "running",
    subscribe => [File["/etc/riak/vm.args"], File["/etc/riak/app.config"], File["/etc/riak/cert.pem"], File["/etc/riak/key.pem"]],
  }

  package {"libssl0.9.8":
    ensure => present
  }
  
  Package["libssl0.9.8"] -> Exec["install"] -> Service["riak"]
}
