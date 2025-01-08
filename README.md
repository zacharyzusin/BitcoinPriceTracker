# Bitcoin Price Tracker

A real-time Bitcoin price tracking application built with Elixir/Phoenix, featuring LiveView for real-time updates and PostgreSQL for price history storage. This project was created as a learning exercise for working with Elixir, Phoenix LiveView, and PostgreSQL.

## Features
- Real-time Bitcoin price updates using CoinMarketCap API
- Historical price tracking with PostgreSQL
- Interactive price chart using Chart.js
- Auto-updating UI with Phoenix LiveView

## Prerequisites
- Erlang 27.2
- Elixir 1.18
- Phoenix Framework 1.7
- PostgreSQL

## Setup Instructions

1. Create a new Phoenix project with LiveView:
```bash
mix phx.new bitcoin_tracker --live
cd bitcoin_tracker
```

2. Set up the database:
```bash
mix ecto.create
mix ecto.migrate
```

3. Add the following dependencies to `mix.exs`:
```elixir
defp deps do
  [
    # ... default phoenix deps ...
    {:httpoison, "~> 2.0"},
    {:number, "~> 1.0"}
  ]
end
```

4. Install dependencies:
```bash
mix deps.get
```

## Key Project Files

bitcoin_tracker/
├── lib/
│   ├── bitcoin_tracker/
│   │   ├── price_history.ex      # Schema for price history
│   │   └── prices.ex             # Context for price operations
│   └── bitcoin_tracker_web/
│       └── live/
│           └── price_live.ex     # LiveView for price updates
├── priv/
│   └── repo/migrations/          # Database migrations
└── assets/
    └── js/
        └── app.js               # JavaScript for Chart.js


Below are the unique files created for this project. Add them into your Phoenix project after setup.

### Database Schema and Context
`priv/repo/migrations/[timestamp]_create_price_histories.ex`:
- Creates the price_histories table
- Stores price and timestamp data
- Includes an index on the timestamp column

`lib/bitcoin_tracker/price_history.ex`:
- Defines the PriceHistory schema
- Handles JSON encoding for API responses
- Validates required fields

`lib/bitcoin_tracker/prices.ex`:
- Contains database interaction logic
- Provides functions for creating and querying price history

### LiveView Component
`lib/bitcoin_tracker_web/live/price_live.ex`:
- Main LiveView module
- Handles real-time price updates
- Manages CoinMarketCap API interaction
- Renders the price display and chart

### Asset Modifications
Update `assets/js/app.js` to include the Chart.js code.

### Layout Modifications
Update `lib/bitcoin_tracker_web/components/layouts/app.html.heex` to include Chart.js CDN.

### Router Configuration
Update `lib/bitcoin_tracker_web/router.ex` to point the root path to PriceLive.

## Running the Project

After setting up Phoenix and copying the project files:

1. Start PostgreSQL
2. Start the Phoenix server:
```bash
mix phx.server
```
3. Visit [`localhost:4000`](http://localhost:4000)
