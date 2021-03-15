id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | head -n 1 | awk '{print $1;}')

gcloud config set project $id

sed -i -e "s/@bucket-name/\"$id\"/g" greenplum/create-instances.tf
cd $HOME/bootstrap/geenplum && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

cd $HOME/bootstrap/compute && terraform refresh -var-file=$HOME/bootstrap/gcp.tfvars
cd $HOME/bootstrap/template && terraform init && terraform destroy -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve
cd $HOME/bootstrap/template && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

