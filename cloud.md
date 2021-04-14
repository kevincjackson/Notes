# Cloud Notes

## Intergration Patterns
- Messaging
  - Remote Procedure Call: a non local function call, BLOCKS.
  - Async Messaging: send and forget, non blocking, commonly used in pub-sub. Use brokers for durabiliy.
- Data
  - Shared Database: Good for consistency, bad b/c tight coupling.
  - File Transfer: Bad for consistency, good for loose coupling.
