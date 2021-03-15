id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | head -n 1 | awk '{print $1;}')

gcloud config set project $id

cd step3

rm -rf ~/bootstrap/hosts

sed -i -e "s/@bucket-name/\"$id\"/g" greenplum/create-instances.tf

sed -i -e "s/@bucket-name/\"$id\"/g" template/ansible_template.tf

cd $HOME/step3/greenplum && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

cd $HOME/step3/template && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve
