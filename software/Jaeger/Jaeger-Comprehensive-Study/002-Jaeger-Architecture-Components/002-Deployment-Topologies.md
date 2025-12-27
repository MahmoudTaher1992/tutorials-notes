# Deployment Topologies

- **All-in-One**: Single binary for development/testing
- **Direct to Storage**: Agent -> Collector -> DB
- **Streaming/Asynchronous**: Agent -> Collector -> Kafka -> Ingester -> DB
- When to scale which component
