узнать версию kafka
`/usr/lib/kafka/bin/kafka-topics.sh --version`

список консьюмеров
`/usr/lib/kafka/bin/kafka-consumer-groups.sh --bootstrap-server kb1t-dtln.ovp.ru:9092 --list`

посмотреть настройки для топика
`/usr/lib/kafka/bin/kafka-configs.sh --bootstrap-server kb1t-dtln.ovp.ru:9092 \`
  `--entity-type topics \`
  `--entity-name erp.ref_trade_channels \`
  `--describe`

таким образом можно поставить валидацию для конкретного консьюмера, но все равно нужны классы из confluent
`/usr/lib/kafka/bin/kafka-console-consumer.sh \`
  `--bootstrap-server kb1t-dtln.ovp.ru:9092 \`
  `--topic erp.ref_trade_channels \`
  `--from-beginning \`
  `--property print.key=true \`
  `--property value.deserializer=io.confluent.kafka.serializers.KafkaAvroDeserializer \`
  `--consumer-property schema.registry.url=http://esb1t-dtln.ovp.ru:8081 \`
  `--consumer-property group.id=779ddcd9-89fe-43a4-869c-6aa3e13eb19c`

команды от алексея
```bash
/usr/bin/kafka-topics.sh --list --bootstrap-server esb1t-dtln:2181  
/usr/bin/zookeeper-shell.sh esb1t-dtln:2181  
  
/usr/bin/kafka-topics.sh --bootstrap-server [kb1t-dtln.ovp.ru:9092](https://kb1t-dtln.ovp.ru:9092) --delete --topic nifi_logs  
/usr/bin/kafka-topics.sh --bootstrap-server [kb1t-dtln.ovp.ru:9092](https://kb1t-dtln.ovp.ru:9092) --create --topic nifi_logs --partitions 3  
/usr/bin/kafka-topics.sh --bootstrap-server [kb1t-dtln.ovp.ru:9092](https://kb1t-dtln.ovp.ru:9092) --create --topic nifi_logs --replication-factor 2 --partitions 3  
/usr/bin/kafka-topics.sh --bootstrap-server [kb1t-dtln.ovp.ru:9092](https://kb1t-dtln.ovp.ru:9092) --list  
/usr/bin/kafka-topics.sh --bootstrap-server [kb1-dtln.ovp.ru:9092](https://kb1-dtln.ovp.ru:9092) --list  
/usr/bin/kafka-topics.sh --bootstrap-server [kb1t-dtln.ovp.ru:9092](https://kb1t-dtln.ovp.ru:9092) --describe --topic nifi_logs
```