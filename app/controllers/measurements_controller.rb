class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:edit, :update]

  def new
    @measurement = Measurement.new
  end

  def create

    validator = MeasurementParamsValidator.new(measurement_params, @measurement, self)
    return unless validator.validate

    measurement_data = EcgAnalysisService.new(
      measurement_params[:csv_file],
      measurement_params[:measurement_datetime],
      measurement_params[:min_heart_rate_limit].to_i,
      measurement_params[:max_heart_rate_limit].to_i
    ).analyze

    @measurement = Measurement.new(measurement_data)
    @measurement.csv_file.attach(measurement_params[:csv_file])

    if @measurement.save
      redirect_to measurements_path, notice: 'Measurement created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @measurements = Measurement.all.reverse_order
  end

  def edit
    @measurement = Measurement.find(params[:id])
  end

  def update

    validator = MeasurementParamsValidator.new(measurement_params, @measurement, self)
    return unless validator.validate

    csv_file = measurement_params[:csv_file].present? ? measurement_params[:csv_file] : nil
    min_heart_rate_limit = measurement_params[:min_heart_rate_limit].to_i || @measurement.min_heart_rate_limit.to_i
    max_heart_rate_limit = measurement_params[:max_heart_rate_limit].to_i || @measurement.max_heart_rate_limit.to_i
    measurement_datetime = measurement_params[:measurement_datetime] || @measurement.measurement_datetime

    csv_file ||= @measurement.csv_file.blob.open do |file|
      measurement_data = EcgAnalysisService.new(
        file,
        measurement_datetime,
        min_heart_rate_limit,
        max_heart_rate_limit,
      ).analyze

      @measurement.csv_file.attach(measurement_params[:csv_file]) if measurement_params[:csv_file].present?

      if @measurement.update(measurement_data)
        redirect_to measurements_path, notice: 'Measurement updated successfully'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def set_measurement
    @measurement = Measurement.find(params[:id])
  end

  def measurement_params
    params.require(:measurement).permit(:csv_file, :measurement_datetime, :min_heart_rate_limit, :max_heart_rate_limit)
  end
end
