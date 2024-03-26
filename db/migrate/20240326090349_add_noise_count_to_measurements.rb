class AddNoiseCountToMeasurements < ActiveRecord::Migration[7.0]
  def change
    add_column :measurements, :noise_count, :integer
  end
end
