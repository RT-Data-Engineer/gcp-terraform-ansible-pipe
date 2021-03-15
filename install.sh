#/bin/bash

#generate random project and activate billing with creation of service account and compute API
id=$(tr -dc a-z0-9 </dev/urandom | head -c 5 ; echo ''); id=rt-$(date -u +"%Y-%m-%d-%H-%M-%S")-$id;

gcloud config unset project

gcloud projects create $id

gcloud config set project $id

gcloud iam service-accounts create acg-sg \
    --description="GCloud Service Account" \
    --display-name="ServiceAccount"

gcloud projects add-iam-policy-binding $id \
    --member="serviceAccount:acg-sg@$id.iam.gserviceaccount.com" \
    --role="roles/owner"
    
gcloud iam service-accounts keys create $HOME/bootstrap/credentials.json \
  --iam-account acg-sg@$id.iam.gserviceaccount.com

b=$(gcloud alpha billing accounts list --uri)

gcloud alpha billing accounts projects link $id --account-id $b

gcloud services enable compute.googleapis.com

gcloud services enable dataproc.googleapis.com

gcloud services enable cloudresourcemanager.googleapis.com

gcloud compute project-info add-metadata \
    --metadata enable-oslogin=TRUE

gsutil mb gs://$id-dataproc

gcloud beta dataproc clusters create cluster-dataproc --enable-component-gateway --bucket $id-dataproc --region us-central1 --zone us-central1-a --single-node --master-machine-type n1-standard-2 --master-boot-disk-size 40 --image-version 2.0-debian10 --optional-components HIVE_WEBHCAT,ZEPPELIN --project $id

#install ansible and terraform
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/ansible.list
sudo apt-get update && sudo apt-get install ansible -y

wget https://releases.hashicorp.com/terraform/0.14.3/terraform_0.14.3_linux_amd64.zip

unzip -o terraform_0.14.3_linux_amd64.zip

sudo mv -f terraform /usr/bin

#morphing project and bucket name into placeholders
cd $HOME/bootstrap

sed -i -e "s/@project-name/\"$id\"/g" gcp.tfvars

sed -i -e "s/@bucket-name/\"$id\"/g" gcp.tfvars

sed -i -e "s+\$HOME+$HOME+g" gcp.tfvars

sed -i -e "s+\$HOME+$HOME+g" ansible/ansible.cfg

sed -i -e "s+\$HOME+$HOME+g" ansible/playbooks/vars/main.yml

sed -i -e "s/@bucket-name/\"$id\"/g" compute/create-instances.tf

sed -i -e "s/@bucket-name/\"$id\"/g" greenplum/create-instances.tf

sed -i -e "s/@bucket-name/\"$id\"/g" template/ansible_template.tf



#activating terraform auth
export GOOGLE_APPLICATION_CREDENTIALS=$HOME/bootstrap/credentials.json

#preparing SSH keys
ssh-keygen -b 2048 -t rsa -f $HOME/bootstrap/ssh-key -q -N ""

gcloud auth activate-service-account --key-file $HOME/bootstrap/credentials.json

ansibleadmin=$(gcloud compute os-login ssh-keys add --key-file=$HOME/bootstrap/ssh-key.pub | grep 'username:' | awk '{print $2}')

sed -i -e "s/@sa-name/\"$ansibleadmin\"/g" ansible/ansible.cfg

#executing terraform inits
cd $HOME/bootstrap/remote-state && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

sleep 10

cd $HOME/bootstrap/compute && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

sleep 10

cd $HOME/bootstrap/greenplum && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

sleep 120

cd $HOME/bootstrap/template && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

sleep 10

#executing ansible inits
cd $HOME/bootstrap/ansible && ansible-playbook -i $HOME/bootstrap/hosts playbooks/install_all.yml --private-key $HOME/bootstrap/ssh-key

echo "INSTALLATION DONE"
