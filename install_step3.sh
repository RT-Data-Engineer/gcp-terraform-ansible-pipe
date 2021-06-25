id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | head -n 1 | awk '{print $1;}')

gcloud config set project $id

cd step3

rm -rf ~/bootstrap/hosts

sed -i -e "s/@bucket-name/\"$id\"/g" greenplum/create-instances.tf

sed -i -e "s/@bucket-name/\"$id\"/g" template/ansible_template.tf

cd $HOME/step3/greenplum && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

cd $HOME/step3/template && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt-get update && sudo apt-get install ansible -y

cd $HOME/bootstrap/ansible && ansible-playbook -i $HOME/bootstrap/hosts playbooks/greenplum.yml --private-key $HOME/bootstrap/ssh-key

echo "INSTALLATION DONE"
