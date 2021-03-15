id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | head -n 1 | awk '{print $1;}')

gcloud config set project $id

cd $HOME/bootstrap/geenplum && terraform init && terraform apply -var-file=$HOME/bootstrap/gcp.tfvars -auto-approve
