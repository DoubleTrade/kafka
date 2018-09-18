# IMAGE: doubletrade/kafka

# Stage1
FROM alpine as builder

ENV kafka_version 0.11.0.2
ENV kafka_scala 2.11

# Prepare the docker image
RUN apk update && apk add curl bash

# Create the install directory and install Kafka
RUN mkdir /install
WORKDIR /install
#RUN curl -O http://apache.mirrors.ovh.net/ftp.apache.org/dist/kafka/${kafka_version}/kafka_${kafka_scala}-${kafka_version}.tgz
RUN curl -O https://archive.apache.org/dist/kafka/${kafka_version}/kafka_${kafka_scala}-${kafka_version}.tgz
RUN tar xvf kafka_${kafka_scala}-${kafka_version}.tgz 
RUN rm kafka_${kafka_scala}-${kafka_version}.tgz
RUN mv kafka_${kafka_scala}-${kafka_version} kafka

# Stage2
# As Kafka require JAVA, we build this image from openjdk
FROM openjdk:8u171-alpine

RUN apk update && apk add bash

RUN mkdir /install
WORKDIR /install

COPY --from=builder /install/kafka /install/kafka

# Expose ports
# The default port is 9092
EXPOSE 9092

# Volumes
VOLUME /data

# Defining entrypoint
WORKDIR /install/kafka
COPY entrypoint.sh /install/kafka/entrypoint.sh
RUN chmod 755 entrypoint.sh

# Defining CMD
CMD ["/install/kafka/entrypoint.sh"]
