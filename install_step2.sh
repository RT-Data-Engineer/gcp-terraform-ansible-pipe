id=$(gcloud projects list --sort-by ~PROJECT_ID | grep rt- | tail -n 1 | awk '{print $1;}')

gcloud config set project $id

gcloud services enable dataproc.googleapis.com

gsutil mb gs://$id-2

gcloud beta dataproc clusters create cluster-243c --enable-component-gateway --bucket $id-2 --region us-central1 --zone us-central1-a --single-node --master-machine-type n1-standard-2 --master-boot-disk-size 40 --image-version 2.0-debian10 --optional-components HIVE_WEBHCAT,ZEPPELIN --project $id
