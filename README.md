Ansible Playbooks to Manager the SHAO Cluster
=============================================

Weitian LI, 2018-01-25

*NOTE*:
Install `cowsay` for an awesome Ansible experience!


A. Create Deploy User
---------------------
### The easy way:

```shell
control$ sh bootstrap.sh
```

Or to bootstrap the *master* machine:

```shell
control$ ansible-playbook --verbose --diff --ask-pass --ask-become-pass \
         --extra-vars "bootstrap_host=master" bootstrap.yml
```

Or to bootstrap one of the node machines, e.g., *gpu1*:

```shell
control$ ansible-playbook --verbose --diff --ask-pass --ask-become-pass \
         --limit gpu1 bootstrap.yml
```

### The hard way:

1. Add a new user `ansible`:

```
root# useradd -m ansible
```

2. Configure "sudo" to allow `ansible` do administration without password:

```
root# cat > /etc/sudoers.d/ansible << _EOF_
# Allow user `ansible` do administration without password
ansible  ALL=(ALL) NOPASSWD: ALL
_EOF_

root# chmod 0440 /etc/sudoers.d/ansible
```

3. Setup the SSH pubkey authentication:

```
ansible$ mkdir -m 0700 ~/.ssh
ansible$ echo "... pubkey content ..." > ~/.ssh/authorized_keys
ansible$ chmod 0600 ~/.ssh/authorized_keys
```

4. Configure SSH to only allow pubkey authentication for user `ansible`
   by adding the following settings to `/etc/ssh/sshd_config`:

```
# Only allow pubkey authentication for `ansible`
Match User ansible
    PasswordAuthentication no
    X11Forwarding no
    AllowTcpForwarding no
```

5. Check SSH configuration and restart service

```
root# sshd -T
root# service sshd restart
```

6. Test Ansible connection from the control machine:

```
control$ ansible master -m ping
control$ ansible master -m command -a whoami
control$ ansible master -m command -a whoami -b
```

