#!/usr/bin/env bash

ldapmodify -x -D "cn=admin,dc=planetexpress,dc=com" -w GoodNewsEveryone -H ldap://127.0.0.1:389 -f /vagrant/ldifs/change_surname.ldif
sudo /opt/mattermost/bin/mattermost ldap sync