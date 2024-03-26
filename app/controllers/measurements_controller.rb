class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:edit, :update]

  def new
    # Renders the form for file upload and datetime input.
    @measurement = Measurement.new
  end

  def create
    # Service object processes the file and returns measurement data
    measurement_data = EcgAnalysisService.new(
      measurement_params[:csv_file],
      measurement_params[:measurement_datetime],
      measurement_params[:min_heart_rate_limit].to_i,
      measurement_params[:max_heart_rate_limit].to_i
    ).analyze

    # Persist the results in the database

    @measurement = Measurement.new(measurement_data)
    @measurement.csv_file.attach(measurement_params[:csv_file])

    if @measurement.save
      flash[:notice] = 'Measurement saved successfully'
      redirect_to measurements_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    # Fetch all the measurements from the database
    @measurements = Measurement.all.reverse_order
  end

  def edit
    # Renders the form for editing the measurement
  end

  def update
    # Update the measurement and redirect
    if @measurement.update(measurement_params)
      redirect_to measurements_path
    else
      render :edit
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
