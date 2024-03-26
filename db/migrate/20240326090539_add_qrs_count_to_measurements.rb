class AddQrsCountToMeasurements < ActiveRecord::Migration[7.0]
  def change
    add_column :measurements, :qrs_count, :integer
  end
end
