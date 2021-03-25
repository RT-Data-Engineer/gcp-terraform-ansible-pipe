students=(
  student6
  student2
  student3
)
id=project-308318
for student in "${students[@]}"; do
gcloud iam service-accounts create $student \
    --description="$student-Service-Account" \
    --display-name="$student-ServiceAccount"
gcloud projects add-iam-policy-binding $id \
    --member="serviceAccount:$student@$id.iam.gserviceaccount.com" \
    --role="roles/viewer"
gcloud iam service-accounts keys create $HOME/$student-credentials.json \
  --iam-account $student@$id.iam.gserviceaccount.com
gsutil mb gs://$id-$student
gsutil iam ch serviceAccount:$student@$id.iam.gserviceaccount.com:objectAdmin gs://$id-$student
done
#gcloud auth activate-service-account --project=project-308318 --key-file=/home/root/student3-credentials.json