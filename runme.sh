#!/bin/sh
if [ -f "./hosts" ]; then
   echo "hosts file already exists, cleanup first ..." 
   sudo sudo ansible-playbook  -i ./hosts /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml
   sudo ansible nodes -a "rm -rf /etc/origin"
   sudo ansible nfs -a "rm -rf /srv/nfs/*"
   rm -rf group_vars LICENSE README.md playbook playbooks hosts.GUID hosts.GUID playbook.yml runme.sh templates
fi
export GUID=`hostname|awk -F. '{print $2}'`
git clone https://github.com/aigars-github/OpenShiftDeployment.git .
rm -rf .git
cat hosts.GUID | sed  s/GUID/$GUID/g > hosts
sudo ansible-playbook  -i ./hosts -f 20 -e "GUID=$GUID" playbook.yml 
