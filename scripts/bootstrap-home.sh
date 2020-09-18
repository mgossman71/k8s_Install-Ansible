#!/bin/sh
CHEFENV=_default                        # This should be set to the Chef Org environment the node should be bootsrapped into.  User is prompted.  Default is Chef _default org.
CHEFDIR=/etc/chef                       # Location to setup chef configuration.  This should not be changed.
host=`hostname -s`

# Update chef-client
systemctl stop chef-client
if [[ -d "$CHEFDIR" ]]
then
  rm -rf "$CHEFDIR"
fi

mkdir "$CHEFDIR"

cd /tmp
curl -O https://packages.chef.io/files/current/chef/14.12.9/el/7/chef-14.12.9-1.el7.x86_64.rpm
yum install -y ./chef-14.12.9-1.el7.x86_64.rpm

cat > ${CHEFDIR}/validation.pem <<EOF
-----BEGIN RSA PRIVATE KEY-----
M
-----END RSA PRIVATE KEY-----
EOF

#set up the client.rb
cat > ${CHEFDIR}/client.rb <<EOF
log_level  :info
log_location STDOUT
chef_server_url "https://chef01/organizations/home"
validation_client_name "home-validator"
node_name "$(hostname -s)"
ssl_verify_mode :verify_none
EOF

#set up the run list
cat > ${CHEFDIR}/first-run.json <<EOF
{ "run_list":
    [
    "role[centos-base]"
    ]
}
EOF

chef-client -j ${CHEFDIR}/first-run.json -L ${CHEFDIR}/first-run.log -E ${CHEFENV}
