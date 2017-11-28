# notuscloud/kafka

# usage

`docker run -ti --rm -p 9092:9092 -v $(pwd):/data notuscloud/kafka:<tag>`

# Kafka parameters

Kafka will start with it's default parameters but you can
override any parameter using ENV variable.

Let's say you want to override the `broker.id` value, use the `KAFKA_BROKER_ID` ENV variable.
If you want to change `num.network.threads`, use the `KAFKA_NUM_NETWORK_THREADS` ENV variable.

## Running kafka as a statefulset in kubernetes

The following env variables are required:

* `K8S_STATEFULSET=true`
* `K8S_HEADLESS_SERVICE_NAME`: Name of the headless svc associated with your statefulset
* `K8S_NAMESPACE`: the namespace where your statefulset is running

# Port

The default exposed port will be `9092`.

# Volume

Kafka logs are stored in `/data`
