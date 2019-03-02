# Registering schemas scripts

Experiments about scripts for **registering schemas** in the **[Confluent Schema Registry](https://docs.confluent.io/current/schema-registry/docs/index.html)**.

## Scripts

### `scripts/register-schema.sh`

This script will **upload a schema** to the schema registry.
The idea is to have a GitLab repository with all the contracts (schemas) and a pipeline to upload the schemas to the schema registry when a contract changes. 

The contracts should be in **AVSC** format (**AV**ro **SC**hema) which is a JSON file.

The script also needs to know the **subject** which is the **topic name** plus **value** or **key**. For example `customer-value`.

**Script params:**

- `-u`, `--url=[URL]` - The schema registry base URL. Default: `--url=http://localhost:8081/`.
- `-s`, `--subject=[SUBJECT]` - Mandatory. The subject in the form `topic-key` or `topic-value`.
- `-f`, `--file=[FILE]` - Mandatory. The schema file in AVSC format.

**Example:**
```
./register-schema.sh -u http://localhost:8081/ -s customer-value -f curstomer.v1.avsc
```

**Based on:**

[Schema Registry API Reference](https://docs.confluent.io/current/schema-registry/docs/api.html).

### `scripts/curstomer.XX.avsc` where `XX` is `v1`, `v2`, `v3` and `v4`

Examples of AVSC files with a schema.
They are different versions of the same schema to test the evolution of a schema.

### `scripts/curstomer.no-comp.avsc`

Example of AVSC file with the same schema, but breaking the compatibility.


## Docker support

For testing the script.

###`docker/startKafka.sh`

Starts a **`landoop/fast-data-dev`** docker container (Kafka + Zookeeper + Schema Registry + REST Proxy).

###`docker/stopKafka.sh`

Stops the **`landoop/fast-data-dev`** docker container.

### `docker/bashKafka.sh`

Enters in a bash sesion in the **`landoop/fast-data-dev`** docker container.