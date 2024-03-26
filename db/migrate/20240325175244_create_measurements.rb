class CreateMeasurements < ActiveRecord::Migration[7.0]
  def change
    create_table :measurements do |t|
      t.integer :mean_heart_rate
      t.datetime :min_heart_rate_time
      t.datetime :max_heart_rate_time
      t.datetime :measurement_datetime
      t.integer :min_heart_rate
      t.integer :max_heart_rate

      t.timestamps
    end
  end
end
