#!/bin/bash

# Add any commands that should be run on instance creation

cat > /etc/cloud/cloud.cfg.d/99-custom-networking.cfg <<EOF
network:
  version: 1
  config:
  - type: physical
    name: ens3
    subnets:
      - type: dhcp
      - type: dhcp6
EOF

cat > /tmp/gpadmin_id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
# Add user private key here
-----END RSA PRIVATE KEY-----
EOF

echo "kernel.sem =  250 512000 100 2048" >> /etc/sysctl.conf

mkdir -p /etc/security/limits.d
echo '* soft core unlimited' >> /etc/security/limits.d/99-core.conf
echo '* hard core unlimited' >> /etc/security/limits.d/99-core.conf

echo 'gpadmin soft nproc 131072' >> /etc/security/limits.d/gpadmin-limits.conf
echo 'gpadmin hard nproc 131072' >> /etc/security/limits.d/gpadmin-limits.conf
echo 'gpadmin soft nofile 65536' >> /etc/security/limits.d/gpadmin-limits.conf
echo 'gpadmin hard nofile 65536' >> /etc/security/limits.d/gpadmin-limits.conf

useradd -m gpadmin
mkdir /home/gpadmin/.ssh
cp /tmp/gpadmin_id_rsa /home/gpadmin/.ssh/id_rsa
cp /home/centos/.ssh/authorized_keys /home/gpadmin/.ssh/
chown -R gpadmin:gpadmin /home/gpadmin/.ssh
chmod 600 /home/gpadmin/.ssh/id_rsa

reboot

