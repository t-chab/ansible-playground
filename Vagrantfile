# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
    # The most common configuration options are documented and commented below.
    # For a complete reference, please see the online documentation at
    # https://docs.vagrantup.com.

    # Every Vagrant development environment requires a box. You can search for
    # boxes at https://atlas.hashicorp.com/search.
    config.vm.box = "ubuntu/xenial64"
    config.vm.box_url = "https://cloud-images.ubuntu.com/releases/16.04/release/ubuntu-16.04-server-cloudimg-amd64-vagrant.box"
    config.vm.define "Ubuntu_Xenial_VM" do |Ubuntu_Xenial_VM|

    # Allow to share current directory on guest with /vagrant path
    config.vm.synced_folder ".", "/vagrant", disabled: false

    # Share user directory with windows $HOME
    #config.vm.synced_folder ENV["USERPROFILE"], "/home/ubuntu/mnt/" + ENV["USER"], disabled: false

    # Virtualbox specific tuning
    config.vm.provider "virtualbox" do |vb|
        # Display the VirtualBox GUI when booting the machine
        vb.gui = true
        # Customize the VM hardware :
        vb.customize ["modifyvm", :id, "--rtcuseutc", "on"]
        vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
        vb.customize ["modifyvm", :id, "--nestedpaging", "on"]
        vb.customize ["modifyvm", :id, "--vtxvpid", "on"]
        vb.customize ["modifyvm", :id, "--largepages", "on"]
        vb.customize ["modifyvm", :id, "--acpi", "on"]
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--vram", "24"]
        vb.customize ["modifyvm", :id, "--cpus", "2"]
    end

    # Proxy Set up
    puts "proxyconf..."
    if Vagrant.has_plugin?("vagrant-proxyconf")
        puts "Found proxyconf plugin."
        if ENV["HTTP_PROXY"]
          puts "http_proxy: " + ENV["HTTP_PROXY"]
          config.proxy.http  = ENV["HTTP_PROXY"]
        end
        if ENV["HTTPS_PROXY"]
          puts "https_proxy: " + ENV["HTTPS_PROXY"]
          config.proxy.https = ENV["HTTPS_PROXY"]
        end
        if ENV["FTP_PROXY"]
          puts "ftp_proxy: " + ENV["FTP_PROXY"]
          config.proxy.ftp = ENV["FTP_PROXY"]
        end
        if ENV["NO_PROXY"]
          puts "no_proxy: " + ENV["NO_PROXY"]
          config.proxy.no_proxy = ENV["NO_PROXY"]
        end
    end

    # Add some configuration files

    # Enable provisioning with a shell script. Additional provisioners such as
    # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    # documentation for more information about their specific syntax and use.
    config.vm.provision "shell", inline: <<-SHELL
        # Workaround for Ubuntu Xenial bug https://bugs.launchpad.net/cloud-images/+bug/1568447
        cp /vagrant/hosts /etc/hosts

        export DFLT_LANG=fr_FR.UTF-8
        export DEBIAN_FRONTEND=noninteractive

        # Lang and Locale
        cp /vagrant/locale /etc/default/locale
        locale-gen --purge en_US.UTF-8
        locale-gen $DFLT_LANG
        dpkg-reconfigure locales -f noninteractive
        export LANG=$DFLT_LANG
        export LANGUAGE=$DFLT_LANG
        export LC_ALL=$DFLT_LANG

        # Setup keyboard with French layout
        apt-get install -y debconf-utils console-common console-data
        cp /vagrant/keyboard /etc/default/keyboard
        debconf-set-selections < /vagrant/keyboard.conf
        dpkg-reconfigure keyboard-configuration -f noninteractive

        # Upgrade
        apt-get update
        apt-get dist-upgrade -y

        # Install minimal stuff
        apt-get install -y language-pack-fr upstart xubuntu-desktop lightdm virtualbox-guest-additions-iso git vim meld filezilla

        # Install JDK 8 and Sublime
        add-apt-repository ppa:webupd8team/java
        add-apt-repository ppa:webupd8team/sublime-text-3
        apt update

        # Hack to avoid Oracle license question
        echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
        echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections

        apt install -y oracle-java8-installer sublime-text-installer

        # Set up graphical login manager
        systemctl enable lightdm.service
        SHELL
    end
end
