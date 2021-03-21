students=(
  student1
  student2
  student3
)

id=projectid


for student in "${students[@]}"; do
    
gcloud iam service-accounts create svc-$student \
    --description="$student-Service-Account" \
    --display-name="$student-ServiceAccount"

gcloud projects add-iam-policy-binding $student \
    --member="serviceAccount:svc-$student@$id.iam.gserviceaccount.com" \
    --role="roles/viewer"

gcloud iam service-accounts keys create $HOME/$student-credentials.json \
  --iam-account svc-$student@$id.iam.gserviceaccount.com
  
gsutil mb gs://$id-$student

gsutil iam ch serviceAccount:svc-$student@$id.iam.gserviceaccount.com:objectAdmin gs://$id-$student

done
