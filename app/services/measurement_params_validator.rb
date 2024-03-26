# app/services/measurement_params_validator.rb
class MeasurementParamsValidator
  def initialize(params, model, controller)
    @params = params
    @model = model
    @controller = controller
  end

  def validate
    return false unless validate_csv_file
    return false unless validate_content_type
    return false unless validate_datetime
    return false unless validate_min_heart_rate_limit
    return false unless validate_max_heart_rate_limit
    return false unless validate_heart_rate_limits
    true
  end

  private

  def csv_file
    @params[:csv_file] || @model&.csv_file
  end

  def min_heart_rate_limit
    @params[:min_heart_rate_limit].to_i || @model.min_heart_rate_limit.to_i
  end

  def max_heart_rate_limit
    @params[:max_heart_rate_limit].to_i || @model.max_heart_rate_limit.to_i
  end

  def measurement_datetime
    @params[:measurement_datetime] || @model.measurement_datetime
  end

  def validate_csv_file
    if csv_file.nil?
      @controller.redirect_back(fallback_location: @controller.new_measurement_path, alert: 'Please select a CSV file')
      false
    else
      true
    end
  end

  def validate_content_type
    if csv_file.content_type != 'text/csv'
      @controller.redirect_back(fallback_location: @controller.new_measurement_path, alert: 'Please select a CSV file')
      false
    else
      true
    end
  end

  def validate_datetime
    if measurement_datetime.blank?
      @controller.redirect_back(fallback_location: @controller.new_measurement_path, alert: 'Please select a date and time')
      false
    else
      true
    end
  end

  def validate_min_heart_rate_limit
    if min_heart_rate_limit <= 0
      @controller.redirect_back(fallback_location: @controller.new_measurement_path, alert: 'Please enter a valid minimum heart rate limit')
      false
    else
      true
    end
  end

  def validate_max_heart_rate_limit
    if max_heart_rate_limit <= 0
      @controller.redirect_back(fallback_location: @controller.new_measurement_path, alert: 'Please enter a valid maximum heart rate limit')
      false
    else
      true
    end
  end

  def validate_heart_rate_limits
    if min_heart_rate_limit >= max_heart_rate_limit
      @controller.redirect_back(fallback_location: @controller.new_measurement_path, alert: 'Minimum heart rate limit must be less than maximum heart rate limit')
      false
    else
      true
    end
  end
end
