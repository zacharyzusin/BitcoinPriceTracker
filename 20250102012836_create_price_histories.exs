defmodule BitcoinTracker.Repo.Migrations.CreatePriceHistories do
  use Ecto.Migration

  def change do
    create table(:price_histories) do
      add :price, :decimal, precision: 20, scale: 2, null: false
      add :timestamp, :utc_datetime, null: false

      timestamps()
    end

    create index(:price_histories, [:timestamp])
  end
end
