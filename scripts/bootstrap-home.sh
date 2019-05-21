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
MIIEowIBAAKCAQEAoXzW6wHCk1sPmMA+0u+1O3oMqeSzAa5DsWMtbuxtpJqK2OdE
ul8PCv1o/pqYEuKn2uhL5EfF4T12TqDW+fTZjZBt5ALvL0znuojO4XHkkjkXV3xV
r7M1NOW8eqyQkctNlAT0gFbOt0y0Ytr8zMiXPdxq4DAeptJd77sCy+Y9AfRoqV2+
9W3N0LwmpGrinyvvcawIsNNVEI0GX87CL7M3oJU8ZjHRaRjItS87rtQUIKO4yYxw
5ke+Gd491lXlT23z76LpJBzAisoWc7b31cBH6moHnqppQGWAtIGjvN9gWMozdw2l
Vtk7IbzcOR87gBMCz5byutZJJy3m9VJ7p3keSwIDAQABAoIBAGRTtwJSGZyK2mnA
JkfOfP3ymaODXmMQ7SVrxHJBmOzGxrRzGhPfsuzU+0ISsaAqCLbL0zqEDMAe+z1m
V6j7IZ39uQgLeqYcVWtiS4VsyOC/b2z+5g0+fTPb9vkP9NFfSVdIrM5/H/ZpRTiV
bLGdfbkFE7EstB5YW9vwh5A9/nETdr31nCnIy2l4YjCT7xM/8ORrfDZdSj3Z5Pja
AJRt6y93TsvfYSsw9mEZvNbjj1hp0deIdmY+1oRaUMQCVplkTsbRIr75EjjD/3fp
ckZSYKFqMavHUAbY85yCRYoBWiaO9YZlN3eJen/iYT+V7CECiN25zwPfeUT3K4EB
ODatUgECgYEAzBG9K+7Zbcw4vDDNLdbzDE4HfCzJMkDCfbgqgCciFO4zf8jRGMuX
G46vfBCv3Q0oFb/p1t7bGFdsKn40fwNELRa/tCOBe0gqQVwoBbuXngb/41R5CegC
XWGwWRdVyBz7KiAtWSgNNO4gFHfcNEevWeG7G4Hnj+vrg/xOJkDUywsCgYEAypUV
u+Xg+VESF8czX/tohSbvXZmIgo/8NkwNbOx76Vi0/lyNlPY4wdXxg5s4uS0g4dQG
wuFj3YwEI4BABAODIgvEIx7DJpDgamg1Rdo/wfuxC3rNIGG2MT9QiWs41m4ANC+m
fdlU+jJTAj21Vf8H7TwB8CKiVh0AVxnVOGdjAcECgYBgdzI5hlr58EQRkfAr7yRN
eMVJCdLCEqLd0yUkF1uhEUj+6usNEZCI0lZaC3lWwVVlkqbzj716MDlNjQM710tv
FQXiHbajlGWFKA8zRo5RgXWM/O2KpUYY5oj6VHGUez6vly5YqvozPy2i/1X00L4v
eul8A1h3TEq0xZwbsSHmKQKBgQCw/0kZ/mNt8bNJKzZr6hEMJVSGBxsKWBsYpaIl
RQmOe37Hrr3VJLu6P97gCcKpqBBOvx2ZL6w9aZREIE3OM/Niz7zyonIHRBWPYrUI
7wM9zVaGnSiT3kt9A8CuEAx87WcoMWnaEwT4BPgZwSiqlkSqtf9LfDcx3ezqLRvq
SAptAQKBgAWBj3xzZWvimurNfSVduO8VupLWMSv9ah9sAHXhkdOuJGkpWlOipElb
+lxc2J54Al0RY331Qb64zDbYqHBYQzxDAgKGgqI4LoTqnIc1ti81regsWZ45s0vQ
wv0wGIZTBvn0djNEcHZZaoTd9VMd6kJ2v7AfSFPEFx7/uh20lHTU
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
