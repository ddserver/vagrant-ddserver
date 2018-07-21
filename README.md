vagrant-ddserver
================

This repository provides a Vagrant environment for the ddserver project.

ddserver is a server-side application for dynamic DNS.

It allows you to specify hostnames (subdomains) inside a dynamic DNS zone,
and to update the IPv4 address of those hostnames using the dyndns2 update
protocol (http://www.noip.com/integrate). This enables you to access hosts
with dynamic IP addresses by a static domain name, even if the IP address
changes.

Some of its features are:

* Nice and intuitive Web-UI
* IP-address update using the dyndns2 protocol
* Support for multiple domains
* Configurable number of hosts per user
* Strong encryption of all passwords (host and user)
* Supports distributed installation

The project homepage is https://ddserver.org


Requirements:
-------------
- VirtualBox > 4.2 (http://www.virtualbox.org)
- Vagrant > 1.4 (http://www.vagrantup.com)
- Git (http://www.git-scm.com)
- *nix based operating system

By default the virtual machine uses a no-worry private NAT network interface.
To give you access to the virtual machine services there are some pre-configured
port forwardings.

- TCP guest 8080 to your host 8080
  provides access to the ddserver Web-UI
- UDP guest 53 to your host 5353
  allows to query dynamic hostnames added with ddserver
- TCP guest 22 to your host 2222
  provides SSH access, but you can also just run `vagrant ssh`


Usage:
------
1. Install VirtualBox and Vagrant on your computer
2. Checkout this repository with: git clone https://github.com/ddserver/vagrant-ddserver.git
3. Change the directory to vagrant-ddserver
4. Run `vagrant up` to start the virtual machine
5. Grab a cup of coffee
6. Point your browser to http://localhost:8080
   - You can login with the default username and password: admin
   - For testing you can do the following:
     - Add a zone, i.e. example.org
     - Add a hostname, i.e. test.example.org
     - Use dig or nslookup to query the DNS server on localhost:5353 for your hostname

You can log into the VM with username `vagrant` and password `vagrant`.
To get root access, use `sudo -i`. The root password is set to `vagrant` as well.


Under the hood
--------------
The Vagrantfile allows you to control the behavior of your virtual machine.
On your first run Vagrant will download a Vagrant basebox based on a minimal
Debian 8 with pre-installed Python 2.7. from the following location:
http://dump.0x80.io/DebianJessie.box

Based on this machine a setup of ddserver and all its dependencies will be
deployed through saltstack. In detail, the following saltstack states are
executed:

common
  - Install some tools like git, python dependencies and a recent version of setuptools
  - Run a full debian system upgrade
  - Set a motd with instructions on how to use the vm

mysql
  - Install and start the mysql server

powerdns
  - Install, configure and start powerdns

ddserver
  - Checkout, build and install python-mysql-connector
  - Clone the ddserver latest master source from github
  - Compile and install ddserver
  - Create an initial /etc/ddserver.conf and the ddserver log file
  - Create the ddserver database, database user and install the database schema
  - Install init script or systemd service and enable ddserver
  - Install powerdns backends and install the ddserver zone
  - Start ddserver on port 8080


Customization
-------------
If you want to run your Vagrant with a different branch or a fork of ddserver
you can configure the git URL and branch parameter in the saltstack pillar:
    salt/roots/pillar/ddserver.sls

To change the port forwardings or the vagrant basebox, edit the Vagrantfile.

Have fun.
