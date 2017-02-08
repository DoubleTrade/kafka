#!/bin/bash

# notuscloud/kafka
# This script is the container's' entrypoint

# Default ENV variables
export KAFKA_LOG_DIRS=${KAFKA_LOG_DIRS:-"/data"}

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