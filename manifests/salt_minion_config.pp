# Added global path
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# Get fresh packages
exec { "update_packages":
  command => "apt-get -y update",
}
# Install git for DVCS
package { "git":
  ensure => present,
  require => Exec[ "update_packages" ]
}


exec { "install_python_sw_props":
  command => "sudo apt-get -y install python-software-properties",
  require => Exec[ "update_packages" ],
}

exec { "add_apt_repo":
  command => "sudo apt-get -y update && sudo add-apt-repository ppa:saltstack/salt",
  require => Exec[ "update_packages" ],
}

exec { "install_salt_master":
  command => "sudo apt-get -y update && sudo apt-get -y install salt-minion",
  require => Exec[ "add_apt_repo" ],
}

exec { "install_python":
  command => "sudo apt-get -y update && sudo apt-get -y install python python-dev python-setuptools",
  require => Exec[ "update_packages"],
}

exec { "add_python_packages":
  command => "sudo /usr/bin/easy_install pyzmq jinja2 pycrypto pyyaml m2crypto msgpack-python",
  require => Exec[ "install_python"],
}

exec{ "set_hostname":
  command => "sudo hostname salt-minion",
}

exec{ "copy_etc_hosts":
  command => "sudo cp /vagrant/etc_hosts /etc/hosts",
}

