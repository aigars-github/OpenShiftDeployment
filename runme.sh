#!/bin/sh
if [ -f "./hosts" ]; then
   echo "hosts file already exists, cleanup first ..." 
   sudo sudo ansible-playbook  -i ./hosts /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml
   sudo ansible nodes -m shell -a "rm -rf /etc/origin"
   sudo ansible nfs -m shell -a "rm -rf /etc/exports.d/openshift-uservols.exports"
   sudo ansible nfs -m shell -a "rm -rf /etc/exports.d/openshift-ansible.exports"
   sudo ansible nfs -m shell -a "rm -rf /etc/exports.d/openshift-prometheus.exports"
   sudo ansible nfs -m shell -a "rm -rf /srv/nfs/*"
   sudo ansible nfs -m shell -a "rm -rf /srv/nfs/*"
   sudo ansible -i ./hosts nfs  -m service -a "name=nfs-server state=reloaded"
   rm -rf group_vars LICENSE README.md playbook playbooks hosts.GUID hosts.GUID playbook.yml runme.sh templates
fi
export GUID=`hostname|awk -F. '{print $2}'`
git clone https://github.com/aigars-github/OpenShiftDeployment.git
/bin/cp -ax OpenShiftDeployment/* .
rm -rf OpenShiftDeployment
cat hosts.GUID | sed  s/GUID/$GUID/g > hosts
sudo ansible-playbook  -i ./hosts -f 20 -e "GUID=$GUID" playbook.yml 
