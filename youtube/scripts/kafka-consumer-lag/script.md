# Kafka Consumer Lag: The Metric That Actually Matters

**Tone:** Serious / Educational
**Duration:** ~60 seconds

| Sentence | Type |
|----------|------|
| Your Kafka pipeline is falling behind and you don't know it. | Hook |
| This is consumer lag in 60 seconds. | Title Reveal |
| Consumer lag is the gap between the latest message and your consumer's position. | Introduction |
| A lag of zero means your consumer is keeping up in real time. | Body – Point 1 |
| Rising lag means your consumers are slower than your producers. | Body – Point 1 |
| The cause is usually a slow consumer, too few instances, or a stuck rebalance. | Body – Point 2 |
| Run kafka-consumer-groups describe to see per-partition lag right now. | Body – Point 2 |
| Fix it by scaling consumers — but never beyond your partition count. | Body – Point 3 |
| Extra consumers beyond partition count sit completely idle and help nothing. | Body – Point 3 |
| Broker health metrics tell you nothing about whether consumers are keeping up. | Conclusion |
| Alert on rising consumer lag before your users notice the delay. | CTA |
