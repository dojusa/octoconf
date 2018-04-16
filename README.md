# Octoconf

## What is it?
This repo is just a example of my talk at the ElixirConf EU 2018. 
Here you find a fairly simple approach of how to use GenStage e GenServer to apply
back-pressure when consuming differents queues.

## Why this approach?
The main reason is due to third party constraints. When you are dealing the applications
that are not in your domain, specially with request limits and unexpected unaviability, 
we need to make sure our process keep going without overloading the nodes.

## After Everything is in Place
After all the abstractions are implemented, you just need to declare the name of the queue, 
which module is going to handle the messages and how many messages should be 
processed concurrently. Here is a config example:

```elixir
config :octoconf,
  queues: [
    %{
      name: "stock",
      handler: Octoconf.Handlers.Product,
      concurrency: 10
    },
    %{
      name: "invoice",
      handler: Octoconf.Handlers.Order,
      concurrency: 20
    }
  ]
```
