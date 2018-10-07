# Functional Programming From First Principes
By Eric Meijer

## Side Effects
Deal with side effects directly.
```
Get :: () -> T
Set :: T -> ()
```
## Handling Sequences of Values: Pull vs Push
### Pull Based Protocol
Enumerable Pattern
```
# Consumer asks the producer when it's interested.
# The consumer gets function from the producer like getSomething() or nextSomething() when it's interested.
# Yield something, nothing, or an error
next() -> T + () + Exception

```

### Push Based Protocol
Observer Pattern
```
# The producer notifies the consumer when something interesting happens.
# The consumer sends different functions to the producer and the producer takes care of it
# The producer yields nothing.
T + () + Exception -> ()
onNext(value)
onComplete()
onError()
```

### Single Values Sequencing! Lazy vs Task / Queue
Lazy
```
# Get something when I ask for it.
Lazy(t) ->
  T { get }
```
Task (Comonad?)
```
# Similar to above the producer is handed time based code.
# Task has a ContinueWith function
#   The ContinueWith function takes a function that takes a Task that returns a value
#   And Task has a Result function
Task(T)
  Task(S) ContinueWith(S)
    (Function(T,s))
  Return
```
