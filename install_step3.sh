id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | head -n 1 | awk '{print $1;}')

gcloud config set project $id

cd step3

sed -i -e "s/@bucket-name/\"$id\"/g" greenplum/create-instances.tf
cd $HOME/step3/greenplum && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve

cd $HOME/bootstrap/compute && terraform refresh -var-file=$HOME/bootstrap/gcp.tfvars
cd $HOME/bootstrap/template && terraform refresh -var-file=$HOME/bootstrap/gcp.tfvars

