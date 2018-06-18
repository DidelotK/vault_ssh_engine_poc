# -*- mode: ruby -*-
# vi: set ft=ruby

VAGRANT_COMMAND = ARGV[0]

# Vagrant configs
VAGRANT_VERSION = '2'

# Ansible configs
ANSIBLE_COMPATIBILITY_MODE  = '2.0'
ANSIBLE_CONFIG_FILE_PATH = './ansible/ansible.cfg'
ANSIBLE_INVENTORY_PATH = './ansible/inventory'

VM_RAM = 2048
VM_CPU = 2

Vagrant.configure(VAGRANT_VERSION) do |config|
  config.vm.box = 'geerlingguy/ubuntu1604'
  config.ssh.forward_agent = true

  # Define vault server
  config.vm.define 'vault' do |vault|
    vault.vm.network 'private_network', ip: '192.168.50.51', :bridge => '127.0.0.1'
    vault.vm.hostname = 'vault'

    vault.vm.provider 'virtualbox' do |v|
      v.memory = VM_RAM
      v.cpus   = VM_CPU
    end
  end

  # Define worker1
  config.vm.define 'worker1' do |worker1|
    worker1.vm.network 'private_network', ip: '192.168.50.52', :bridge => '127.0.0.1'
    worker1.vm.hostname = 'worker1'

    worker1.vm.provider 'virtualbox' do |v|
      v.memory = VM_RAM
      v.cpus = VM_CPU
    end
  end

  # Define worker2
  config.vm.define 'worker2' do |worker2|
    worker2.vm.network 'private_network', ip: '192.168.50.53', :bridge => '127.0.0.1'
    worker2.vm.hostname = 'worker2'

    worker2.vm.provider 'virtualbox' do |v|
      v.memory = VM_RAM
      v.cpus   = VM_CPU
    end

    worker2.vm.provision 'vault', type: 'ansible' do |ansible_vault|
      ansible_vault.limit               = 'all, localhost'
      ansible_vault.force_remote_user   = false
      ansible_vault.compatibility_mode  = ANSIBLE_COMPATIBILITY_MODE
      ansible_vault.inventory_path      = ANSIBLE_INVENTORY_PATH
      ansible_vault.config_file         = ANSIBLE_CONFIG_FILE_PATH
      ansible_vault.playbook            = 'ansible/playbooks/vault.yml'
      # ansible_vault.tags                = 'vault-ssh-key'
      ansible_vault.verbose             = 'v'
    end

    worker2.vm.provision 'ssh_key', type: 'ansible' do |ansible_ssh_key|
      ansible_ssh_key.limit               = 'localhost'
      ansible_ssh_key.force_remote_user   = false
      ansible_ssh_key.compatibility_mode  = ANSIBLE_COMPATIBILITY_MODE
      ansible_ssh_key.inventory_path      = ANSIBLE_INVENTORY_PATH
      ansible_ssh_key.config_file         = ANSIBLE_CONFIG_FILE_PATH
      ansible_ssh_key.playbook            = 'ansible/playbooks/ssh_key.yml'
      # ansible_ssh_key.tags                = 'vault-ssh-key'
      ansible_ssh_key.verbose             = 'v'
    end
  end

end
