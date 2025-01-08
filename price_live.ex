defmodule BitcoinTrackerWeb.PriceLive do
  use BitcoinTrackerWeb, :live_view
  alias BitcoinTracker.Prices
  require Logger

  @impl true
def mount(_params, _session, socket) do
  if connected?(socket) do
    :timer.send_interval(30_000, self(), :update_price)
  end

  price_data = get_and_store_price()
  historical_prices = Prices.get_recent_prices()

  {:ok,
   assign(socket,
     price: price_data.price,
     timestamp: price_data.timestamp,
     historical_prices: historical_prices
   )}
end

  @impl true
  def handle_info(:update_price, socket) do
    price_data = get_and_store_price()
    historical_prices = Prices.get_recent_prices()

    {:noreply,
     assign(socket,
       price: price_data.price,
       timestamp: price_data.timestamp,
       historical_prices: historical_prices
     )}
  end

  defp get_and_store_price do
    price_data = get_bitcoin_price()
    {:ok, _record} = Prices.create_price_history(price_data)
    price_data
  end

  defp get_bitcoin_price do
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"
    query = URI.encode_query(%{"symbol" => "BTC", "convert" => "USD"})

    headers = [
      {"Accept", "application/json"},
      {"X-CMC_PRO_API_KEY", "e95c9e93-be2d-44a6-9bcd-c70b60fd5e6d"},
      {"User-Agent", "BitcoinTracker"}
    ]

    case HTTPoison.get("#{url}?#{query}", headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"data" => %{"BTC" => %{"quote" => %{"USD" => %{"price" => price}}}}}} ->
            price_string = Float.to_string(price)
            IO.inspect(price_string, label: "Fetched Bitcoin Price")
            %{price: Decimal.new(price_string), timestamp: DateTime.utc_now()}

          {:error, decode_error} ->
            IO.inspect(decode_error, label: "JSON Decode Error")
            IO.inspect(body, label: "Raw Response Body")
            %{price: Decimal.new("50000.00"), timestamp: DateTime.utc_now()}
        end

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.inspect({status_code, body}, label: "API Error Response")
        %{price: Decimal.new("50000.00"), timestamp: DateTime.utc_now()}

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason, label: "HTTP Client Error")
        %{price: Decimal.new("50000.00"), timestamp: DateTime.utc_now()}
    end
  end



  @impl true
  def render(assigns) do
    chart_data = assigns.historical_prices
      |> Enum.map(fn history ->
        %{
          price: history.price |> Decimal.to_string(),
          timestamp: Calendar.strftime(history.timestamp, "%H:%M:%S")
        }
      end)
      |> Jason.encode!()

    assigns = assign(assigns, :chart_data, chart_data)

    ~H"""
    <div class="container mx-auto px-4 py-8">
      <h1 class="text-3xl font-bold mb-4">Bitcoin Price Tracker</h1>

      <div class="bg-white shadow rounded-lg p-6 mb-8">
        <p class="text-2xl font-semibold">
          Current Price: $<%= Number.Currency.number_to_currency(@price) %>
        </p>
        <p class="text-sm text-gray-500">
          Last updated: <%= Calendar.strftime(@timestamp, "%Y-%m-%d %H:%M:%S UTC") %>
        </p>
      </div>

      <div class="bg-white shadow rounded-lg p-6">
        <h2 class="text-xl font-semibold mb-4">Price History</h2>
        <div class="w-full h-64">
          <canvas id="priceChart" data-prices={@chart_data}></canvas>
        </div>
      </div>
    </div>
    """
  end
end
