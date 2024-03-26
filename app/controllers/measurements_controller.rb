class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:edit, :update]

  def new
    # Renders the form for file upload and datetime input.
  end

  def create
    # Service object processes the file and returns measurement data
    measurement_data = EcgAnalysisService.new(measurement_params[:file], measurement_params[:measurement_datetime], measurement_params[:min_heart_rate_limit], measurement_params[:max_heart_rate_limit]).analyze

    # Persist the results in the database
    @measurement = Measurement.create(measurement_data)

    # Redirect to the index action to display the saved measurements
    redirect_to measurements_path
  end

  def index
    # Fetch all the measurements from the database
    @measurements = Measurement.all
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
    params.require(:measurement).permit(:file, :measurement_datetime, :min_heart_rate_limit, :max_heart_rate_limit)
  end
end
