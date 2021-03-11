id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | head -n 1 | awk '{print $1;}')

gcloud config set project $id

if [ "$(gcloud compute instances describe postgres-kafka-nifi --zone europe-west4-a | grep RUNNING)" == "status: RUNNING" ]; then echo ok; else gcloud compute instances start postgres-kafka-nifi --zone europe-west4-a; fi

sleep 1m

gcloud services enable dataproc.googleapis.com

gsutil mb gs://$id-dataproc

gcloud beta dataproc clusters create cluster-dataproc --enable-component-gateway --bucket $id-dataproc --region us-central1 --zone us-central1-a --single-node --master-machine-type n1-standard-2 --master-boot-disk-size 40 --image-version 2.0-debian10 --optional-components HIVE_WEBHCAT,ZEPPELIN --project $id

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367

sudo echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main" | sudo tee /etc/apt/sources.list.d/ansible.list

sudo apt-get update && sudo apt-get install ansible -y

sudo apt-get install git 


git clone https://github.com/RT-Data-Engineer/gcp-terraform-ansible-pipe.git $HOME/step2

cp ~/bootstrap/hosts ~/step2/hosts
cp ~/bootstrap/ssh-key ~/step2/ssh-key
cp ~/bootstrap/ssh-key.pub ~/step2/ssh-key.pub
cp ~/bootstrap/ansible/ansible.cfg ~/step2/ansible/ansible.cfg



cd $HOME/step2/ansible && ansible-playbook -i $HOME/step2/hosts playbooks/nifi.yml --private-key $HOME/step2/ssh-key
cd $HOME/step2/ansible && ansible-playbook -i $HOME/step2/hosts playbooks/kafka.yml --private-key $HOME/step2/ssh-key



