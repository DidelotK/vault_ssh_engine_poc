# Ansible Role: Docker

An Ansible Role that installs [Docker](https://www.docker.com) on Linux.
This role is a fork of geerlingguy.docker with more features (docker users, docker deamon conf)
## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    # Edition can be one of: 'ce' (Community Edition) or 'ee' (Enterprise Edition).
    docker_edition: 'ce'
    docker_package: "docker-{{ docker_edition }}"
    docker_package_state: present

The `docker_edition` should be either `ce` (Community Edition) or `ee` (Enterprise Edition). You can also specify a specific version of Docker to install using a format like `docker-{{ docker_edition }}-<VERSION>`. And you can control whether the package is installed, uninstalled, or at the latest version by setting `docker_package_state` to `present`, `absent`, or `latest`, respectively.

    docker_install_compose: true
    docker_compose_version: "1.15.0"
    docker_compose_path: /usr/local/bin/docker-compose

Docker Compose installation options.

    docker_users: []

The `docker_users` should be a list of existing users.

    docker_reset_ssh: false

The options to reset ssh at the end of the role (can be used if `ansible_user` is in `docker_users`)
    docker_daemon_options:
        hosts:
          - "unix:///var/run/docker.sock"
          - "tcp://{{ ansible_host }}:2376"
        tlsverify: true
        tlscacert: "{{ tls_server_cert_path }}/ca.pem"
        tlscert: "{{ tls_server_cert_path }}/server-cert.pem"
        tlskey: "{{ tls_server_cert_path }}/server-key.pem"
Docker daemon options.

(Note that certificates has to be created before launching the role and you have to create the tls_server_cert_path).

    docker_use_proxy: false
    docker_http_proxy: ""
    docker_https_proxy: ""

Set `docker_use_proxy` to `true` and set `docker_http_proxy` and `docker_https_proxy` in order to configure docker to use proxy.


    docker_apt_release_channel: stable
    docker_apt_repository: "deb https://download.docker.com/linux/{{ ansible_distribution|lower }} {{ ansible_distribution_release }} {{ docker_apt_release_channel }}"

(Used only for Debian/Ubuntu.) You can switch the channel to `edge` if you want to use the Edge release.

    docker_yum_repo_url: https://download.docker.com/linux/centos/docker-{{ docker_edition }}.repo
    docker_yum_repo_enable_edge: 0
    docker_yum_repo_enable_test: 0

(Used only for RedHat/CentOS.) You can enable the Edge or Test repo by setting the respective vars to `1`.

## Use with Ansible (and `docker` Python library)

Many users of this role wish to also use Ansible to then _build_ Docker images and manage Docker containers on the server where Docker is installed. In this case, you can easily add in the `docker` Python library using the `geerlingguy.pip` role:

```yaml
- hosts: all

  vars:
    pip_install_packages:
      - name: docker

  roles:
    - geerlingguy.pip
    - docker
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: all
  roles:
    - docker
```

## License

MIT / BSD

## Author Information

This role was created in 2017 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
And edited by Kevin Didelot in 2018
