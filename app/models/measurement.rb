class Measurement < ApplicationRecord
  has_one_attached :csv_file
  validates :csv_file, presence: true
  validates :measurement_datetime, presence: true
  validates :min_heart_rate_limit, presence: true
  validates :max_heart_rate_limit, presence: true
  validates :min_heart_rate_limit, numericality: { greater_than: 0 }
  validates :max_heart_rate_limit, numericality: { greater_than: 0 }
  validates :measurement_datetime, presence: true
end
