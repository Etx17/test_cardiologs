class Measurement < ApplicationRecord
  has_one_attached :file
  validates :file, presence: true
  validates :measurement_datetime, presence: true
  validates :min_heart_rate_limit, presence: true
  validates :max_heart_rate_limit, presence: true
  validates :min_heart_rate_limit, numericality: { greater_than: 0 }
  validates :max_heart_rate_limit, numericality: { greater_than: 0 }
  validate :correct_content_type


  private

  def correct_content_type
    if file.attached? && !file.content_type.in?(%w(text/csv))
      errors.add(:file, 'Must be a CSV file')
    end
  end
end
