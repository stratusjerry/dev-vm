# Vagrantfile.virtualbox.template
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  config.vm.boot_timeout = 600
  config.vm.graceful_halt_timeout = 600

  # WinRM configuration
  config.winrm.username = "Administrator"
  config.winrm.password = "packer"
  config.winrm.transport = :negotiate
  config.winrm.basic_auth_only = false
  config.winrm.ssl_peer_verification = false
  config.winrm.retry_limit = 30
  config.winrm.retry_delay = 10

  # VM configuration
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.memory = 8192
    vb.cpus = 4
    vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"] 
    vb.customize ["modifyvm", :id, "--vram", "256"]
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
    vb.customize ["modifyvm", :id, "--accelerate2dvideo", "on"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    vb.customize ["modifyvm", :id, "--paravirtprovider", "hyperv"]
    vb.customize ["modifyvm", :id, "--audio-driver", "dsound"]
    vb.customize ["modifyvm", :id, "--audiocontroller", "hda"]
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]
    vb.customize ["modifyvm", :id, "--usbxhci", "on"]
  end

  # Shared folders configuration
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "C:/vagrant", 
    type: "virtualbox",
    owner: "Administrator",
    group: "Administrators"
  
  # Network configuration
  config.vm.network "forwarded_port", guest: 3389, host: 33389, id: "rdp", auto_correct: true
  config.vm.network "forwarded_port", guest: 5985, host: 55985, id: "winrm", auto_correct: true
  config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", auto_correct: true

  # Additional forwarded ports for development
  config.vm.network "forwarded_port", guest: 3000, host: 3000, id: "react"
  config.vm.network "forwarded_port", guest: 4200, host: 4200, id: "angular"
  config.vm.network "forwarded_port", guest: 8080, host: 8080, id: "tomcat"
  config.vm.network "forwarded_port", guest: 5000, host: 5000, id: "flask"
  config.vm.network "forwarded_port", guest: 8000, host: 8000, id: "django"

  # Post-boot configuration
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    Write-Output "Windows 11 Development Environment Ready!"
    Write-Output "==> Development tools installed:"
    Write-Output "  - Visual Studio Code"
    Write-Output "  - Node.js with npm"
    Write-Output "  - Python 3"
    Write-Output "  - Git"
    Write-Output "  - Chrome and Firefox"
    Write-Output "  - Various development utilities"
    Write-Output ""
    Write-Output "==> Access via RDP: localhost:33389"
    Write-Output "==> Username: Administrator"
    Write-Output "==> Password: packer"
    Write-Output ""
    Write-Output "==> Development folder: C:\\Development"
  SHELL
end