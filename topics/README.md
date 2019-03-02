# Creating topics scripts

Experiments about scripts for **creating topics** in **[Apache Kafka](https://kafka.apache.org/)**.

## Scripts

### `scripts/create-topics.sh`

The idea is to have the topics.csv file in some GitLab repo and create a pipeline to execute el create-topics.sh script when something changes.
This script takes a CSV file with the name of the topics with this format:

```csv
TOPIC;PARTITIONS;CONFIG
```

- **`TOPIC`** is the topic name can contain a `___ENV___` component which will be replaced by the real environment: `dev`, `prod`, `test`, ...
- **`PARTITIONS`** is the number of partitions for this topic. Default 7 partitions.
- **`CONFIG`** allows to add config options to the topic. For example:
    - `--config cleanup.policy=delete`
    - `--config retention.bytes=-1`
    - `--config retention.ms=-1`

**Script params:**

- `-e`, `--environment=ENV` - To select the environment for the topics (`dev`, `prod`, `test`, ...). Default: `--environment=dev`.
- `-z`, `--zookeeper=SERVER` - The connection string for zookeeper (`host:port`). Default: `--zookeeper=localhost:2181`.
- `-r`, `--replication-factor=FACTOR` - The replication factor for all topics. Default: `--replication-factor=1`.
- `-t`, `--topics-file=FILE` - The CSV topics file. Mandatory.

**Example:**
```
scripts/create-topics.sh --environment dev --zookeeper localhost:2181 --replication-factor 1 --topics-file topics.csv
```

### `scripts/topics.csv`

Example of CSV file for creating the topics.

## Docker support

### `docker/startKafka.sh`

Starts a **`blacktop/kafka`** docker container (Kafka + Zookeeper).

### `docker/stopKafka.sh`

Stops the **`blacktop/kafka`** docker container.

### `docker/bashKafka.sh`

Enters in a bash sesion in the **`blacktop/kafka`** docker container.

### `docker/create-topics.sh`

Executes the **`scripts/create-topics.sh`** script inside the **`blacktop/kafka`** docker container.
