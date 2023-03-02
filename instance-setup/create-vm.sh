INSTANCE_NAME=$1
MACHINE_TYPE=$2 # n2-highmem-8
REGION=$3 # europe-southwest1
ZONE=$4 # europe-southwest1-a
DATA_DISK_SIZE=$5 #1000

#bash create-ip.sh ${INSTANCE_NAME} ${REGION}

IP_ADDRESS=$(gcloud compute addresses describe ${INSTANCE_NAME} --project=mindful-phalanx-313619 --region=${REGION} |grep 'address:'|cut -d ' ' -f2)
gcloud compute addresses describe merkal --project=mindful-phalanx-313619 --region=europe-southwest1|grep 'address:\s*.*'
gcloud compute instances create ${INSTANCE_NAME} \
    --project=mindful-phalanx-313619 \
    --zone=${ZONE} \
    --machine-type=${MACHINE_TYPE} \
    --network-interface=address=${IP_ADDRESS},network-tier=PREMIUM,subnet=default \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=395150976044-compute@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --tags=http-server,https-server \
    --create-disk=auto-delete=yes,boot=yes,device-name=${INSTANCE_NAME},image=projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20221206,mode=rw,size=100,type=projects/mindful-phalanx-313619/zones/${ZONE}/diskTypes/pd-balanced \
    --create-disk=auto-delete=yes,device-name=${INSTANCE_NAME}-data,mode=rw,name=${INSTANCE_NAME}-data,size=${DATA_DISK_SIZE},type=projects/mindful-phalanx-313619/zones/${ZONE}/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any \
    --deletion-protection

#    --metadata=^,@^ssh-keys=sergey_rozhkov:ecdsa-sha2-nistp256\ \
#AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLY\+h\+y2hE8aFA03Y07TF0i5tJUNimXTg0A2\+JODHAQFnIGkRbuw2V31g4FV59HLNINi38M2lgA9VlICo6SSAh8=\ google-ssh\ \{\"userName\":\"sergey.rozhkov@goalprofit.com\",\"expireOn\":\"2022-12-30T18:11:32\+0000\"\}$'\n'sergey_rozhkov:ssh-rsa\ AAAAB3NzaC1yc2EAAAADAQABAAABAQDYmQ62s2mjhW85\+6Jkb6so9Zx1xLA88egDFzTOIpF/K8Xyf0J4FU/orFZKnZRCTcYYNbzbfLsJH/RYULYcGIMWIVHoujVenVGCdzSrGL/KQs7YxSRUomSL5e/y37bjtXi3BuYBPiTNuBDR\+wHjvfb9mzXeheYTM3XPkdh57NYxvqw70Q2dbMmk9Wz2klK0dhDdZxHjYsuRQa5QwpA9up1toDf9O5wktSg\+p9hNukQruAw5xoR2DOybn0JBvy1vhWvNUYix2h99B8q/SSWQXcR8w7OByko/4cRkOB1aKbeJ1wBvTMdKax\+Mol/9bAh4YnntgEsMUbbwRwcPdHxoeTBP\ google-ssh\ \{\"userName\":\"sergey.rozhkov@goalprofit.com\",\"expireOn\":\"2022-12-30T18:11:47\+0000\"\} \
