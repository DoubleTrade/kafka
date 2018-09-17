#!/bin/bash

# doubletrade/kafka
# This script is the container's' entrypoint

# Default ENV variables
export KAFKA_LOG_DIRS=${KAFKA_LOG_DIRS:-"/data"}
export K8S_STATEFULSET=${K8S_STATEFULSET:-false}

# Override broker.id with the statefulset ordinal index if this image is used in a statefulset
# test K8S_STATEFULSET=true
if [[ ${K8S_STATEFULSET} == true ]] || [[ ${K8S_STATEFULSET} == "true" ]] ; then
  export K8S_NAMESPACE=${K8S_NAMESPACE:-"default"}
  export K8S_HEADLESS_SERVICE_NAME=${K8S_HEADLESS_SERVICE_NAME:-"kafka"}
  export KAFKA_BROKER_ID=${HOSTNAME##*-}
  export KAFKA_LISTENERS="PLAINTEXT://${HOSTNAME}.${K8S_HEADLESS_SERVICE_NAME}.${K8S_NAMESPACE}.svc.cluster.local:9092"
fi

# Parse the configured ENV variables starting with KAFKA_ keyword
KAFKA_VARS=$(env | grep KAFKA_)
overrideArgs=
for value in ${KAFKA_VARS} 
do
  varname=$(printf $value | cut -d"=" -f1 | awk '{print tolower($0)}')
  value=$(printf $value | cut -d"=" -f2)
  
  # Build override arguments
  # Split var name into an array
  arr=(${varname//_/ })

  # Remove the first entry "KAFKA"
  unset arr[0]

  # Init a parameter var
  parameter=
  # Parse ENV VAR name
  for str in ${arr[@]}
  do
    if [ ${#parameter} != 0 ] 
    then
      parameter+=".${str}"
    else
      parameter+="${str}"
    fi
  done
  overrideArgs+="--override ${parameter}=${value} "
done

# Start kafka 
./bin/kafka-server-start.sh config/server.properties ${overrideArgs}
