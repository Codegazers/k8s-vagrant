# -*- mode: ruby -*-
# vi: set ft=ruby :

# Require YAML module
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__), 'config.yml'))

base_box=config['environment']['base_box']

master_ip=config['environment']['masterip']

domain=config['environment']['domain']

boxes = config['boxes']

boxes_hostsfile_entries=""

 boxes.each do |box|
   boxes_hostsfile_entries=boxes_hostsfile_entries+box['mgmt_ip'] + ' ' +  box['name'] + ' ' + box['name']+'.'+domain+'\n'
 end

#puts boxes_hostsfile_entries

update_hosts = <<SCRIPT
    echo "127.0.0.1 localhost" >/etc/hosts
    echo -e "#{boxes_hostsfile_entries}" |tee -a /etc/hosts
SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = base_box
  config.vm.synced_folder "tmp_deploying_stage/", "/tmp_deploying_stage",create:true
  config.vm.synced_folder "src/", "/src",create:true
  boxes.each do |node|
    config.vm.define node['name'] do |config|
      config.vm.hostname = node['name']
      config.vm.provider "virtualbox" do |v|

        v.name = node['name']
        v.customize ["modifyvm", :id, "--memory", node['mem']]
        v.customize ["modifyvm", :id, "--cpus", node['cpu']]

        v.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
        v.customize ["modifyvm", :id, "--nictype2", "Am79C973"]
        v.customize ["modifyvm", :id, "--nictype3", "Am79C973"]
        v.customize ["modifyvm", :id, "--nictype4", "Am79C973"]
        v.customize ["modifyvm", :id, "--nicpromisc1", "allow-all"]
        v.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
        v.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
        v.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

      end

      config.vm.network "private_network",
      ip: node['mgmt_ip'],
      virtualbox__intnet: "LABS"


      #  config.vm.network "private_network",
      #  ip: opts[:node_hostonlyip], :netmask => "255.255.255.0",
      #  :name => 'vboxnet0',
      #  :adapter => 2


      config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true

      config.vm.network "public_network",
      bridge: ["enp4s0","wlp3s0","enp3s0f1","wlp2s0"],
      auto_config: true

      #config.vm.provision "shell", inline: <<-SHELL
      #	echo "useDNS no" >> /etc/ssh/sshd_config
      #  update-ca-certificates
      #  systemctl reload ssh
      #SHELL


      config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update -qq && apt-get install -qq chrony && timedatectl set-timezone Europe/Madrid
      SHELL

      # Delete default router for host-only-adapter
      #  config.vm.provision "shell",
      #  run: "always",
      #  inline: "route del default gw 192.168.56.1"

      config.vm.provision :shell, :inline => update_hosts

      config.vm.provision "shell", inline: <<-SHELL
        sudo cp -R /src ~ubuntu
        sudo chown -R ubuntu:ubuntu ~ubuntu/src
      SHELL
 


      if node['role'] == "client"
      	config.vm.provision "shell", inline: <<-SHELL
          apt-get install -qq curl 
        SHELL
	      next
      end




      ## INSTALLDOCKER --> on script because we can reprovision
      config.vm.provision "shell", inline: <<-SHELL
      apt-get remove --purge -qq sudo apt-get remove docker docker-engine docker.io
      apt-get install -qq \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
        sudo apt-get update -qq
        apt-get install -qq docker-ce=17.03.2~ce-0~ubuntu-xenial
        usermod -aG docker ubuntu
      SHELL


      ## INSTALLKUBERNETES --> on script because we can reprovision
      config.vm.provision "shell", inline: <<-SHELL
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
        echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list 
        apt-get update -qq
        apt-get install -y --allow-unauthenticated kubelet kubeadm kubectl kubernetes-cni
      SHELL


      config.vm.provision "file", source: "create_cluster.sh", destination: "/tmp/create_cluster.sh"
      config.vm.provision :shell, :path => 'create_cluster.sh' , :args => [ node['mgmt_ip'], master_ip ]

    end
  end

end
