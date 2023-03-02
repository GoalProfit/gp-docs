INSTANCE_NAME=$1
REGION=$2
gcloud compute addresses create ${INSTANCE_NAME} --project=mindful-phalanx-313619 --region=${REGION}
