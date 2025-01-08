defmodule BitcoinTracker.Prices do
  import Ecto.Query
  alias BitcoinTracker.Repo
  alias BitcoinTracker.PriceHistory

  def create_price_history(attrs \\ %{}) do
    %PriceHistory{}
    |> PriceHistory.changeset(attrs)
    |> Repo.insert()
  end

  def get_recent_prices(limit \\ 24) do
    PriceHistory
    |> order_by(desc: :timestamp)
    |> limit(^limit)
    |> Repo.all()
  end
end
