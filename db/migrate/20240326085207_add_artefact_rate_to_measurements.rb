class AddArtefactRateToMeasurements < ActiveRecord::Migration[7.0]
  def change
    add_column :measurements, :artefact_rate, :float
  end
end
