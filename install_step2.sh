id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | tail -n 1 | awk '{print $1;}')

gcloud config set project $id

gcloud services enable dataproc.googleapis.com

gsutil mb gs://$id-dataproc

gcloud beta dataproc clusters create cluster-dataproc --enable-component-gateway --bucket $id-dataproc --region us-central1 --zone us-central1-a --single-node --master-machine-type n1-standard-2 --master-boot-disk-size 40 --image-version 2.0-debian10 --optional-components HIVE_WEBHCAT,ZEPPELIN --project $id

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

sudo echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/ansible.list

sudo apt-get update && sudo apt-get install ansible -y

sudo apt-get install git 

git clone https://github.com/RT-Data-Engineer/gcp-terraform-ansible-pipe.git $HOME/add_soft

cp ~/bootstrap/hosts ~/add_soft/hosts
cp ~/bootstrap/ssh-key ~/add_soft/ssh-key
cp ~/bootstrap/ssh-key.pub ~/add_soft/ssh-key.pub
cp ~/bootstrap/ansible/ansible.cfg ~/add_soft/ansible/ansible.cfg

cd $HOME/add_soft/ansible && ansible-playbook -i $HOME/add_soft/hosts playbooks/kafka.yml --private-key $HOME/add_soft/ssh-key

cd $HOME/add_soft/ansible && ansible-playbook -i $HOME/add_soft/hosts playbooks/nifi.yml --private-key $HOME/add_soft/ssh-key

git clone https://github.com/vadopolski/data-generator $HOME/data