/opt/kafka_2.12-2.6.1/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic billing

cat billing_total.json | /opt/kafka_2.12-2.6.1/bin/kafka-console-producer.sh  --bootstrap-server localhost
:9092 --topic billing

/opt/kafka_2.12-2.6.1/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic issue

cat issue_total.json | /opt/kafka_2.12-2.6.1/bin/kafka-console-producer.sh  --bootstrap-server localhost
:9092 --topic issue

/opt/kafka_2.12-2.6.1/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic payment

cat payment_total.json | /opt/kafka_2.12-2.6.1/bin/kafka-console-producer.sh  --bootstrap-server localhost
:9092 --topic payment

/opt/kafka_2.12-2.6.1/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic traffic

cat traffic_total.json | /opt/kafka_2.12-2.6.1/bin/kafka-console-producer.sh  --bootstrap-server localhost
:9092 --topic traffic
