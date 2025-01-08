defmodule BitcoinTracker.PriceHistory do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:price, :timestamp]}

  schema "price_histories" do
    field :price, :decimal
    field :timestamp, :utc_datetime

    timestamps()
  end

  def changeset(price_history, attrs) do
    price_history
    |> cast(attrs, [:price, :timestamp])
    |> validate_required([:price, :timestamp])
  end
end
