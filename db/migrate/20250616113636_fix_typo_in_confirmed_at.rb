class FixTypoInConfirmedAt < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :confirmet_at, :confirmed_at
  end
end
