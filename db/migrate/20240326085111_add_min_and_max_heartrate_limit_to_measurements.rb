class AddMinAndMaxHeartrateLimitToMeasurements < ActiveRecord::Migration[7.0]
  def change
    add_column :measurements, :min_heart_rate_limit, :integer
    add_column :measurements, :max_heart_rate_limit, :integer
  end
end
