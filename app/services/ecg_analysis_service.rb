require 'csv'
class EcgAnalysisService
  def initialize(file, start_time, min_heart_rate_limit=10, max_heart_rate_limit=300)
    @file = file
    @start_time = DateTime.parse(start_time)
    @min_heart_rate = 999
    @max_heart_rate = 0
    @min_heart_rate_time = nil
    @max_heart_rate_time = nil
    @previous_qrs_end = nil
    @heart_rates = []
    @row_count = 0
    @min_heart_rate_limit = min_heart_rate_limit
    @max_heart_rate_limit = max_heart_rate_limit
    @noise_count = 0
    @qrs_count = 0
  end

  def analyze


    CSV.foreach(@file.path, headers: false) do |row|
      @row_count += 1
      next if row.first != 'QRS'

      type, onset, offset = row.first(3)
      onset = onset.to_i
      offset = offset.to_i
      @qrs_count += 1

      if @previous_qrs_end
        raise ArgumentError, "current QRS complex time is before the previous QRS complex time. Check data" if onset < @previous_qrs_end
        interval = onset - @previous_qrs_end
        heart_rate = 60_000 / interval.to_f

        if heart_rate < @min_heart_rate_limit || heart_rate > @max_heart_rate_limit # enable user to change those values
          @noise_count += 1
          next
        end

        if heart_rate < @min_heart_rate
          @min_heart_rate = heart_rate
          @min_heart_rate_time = @start_time + (@previous_qrs_end / 1000.0).seconds
        end

        if heart_rate > @max_heart_rate
          @max_heart_rate = heart_rate
          @max_heart_rate_time = @start_time + (@previous_qrs_end / 1000.0).seconds
        end

        @heart_rates << heart_rate
      end
      @previous_qrs_end = offset
    end

    raise ArgumentError, "CSV file must contain data" if @row_count < 2 
    raise ArgumentError, "CSV file must contain at least one QRS complex" if @qrs_count.zero?
    # We could do more, like checking if the CSV has the correct minimum amount of qrs complexes

    {
      min_heart_rate: @min_heart_rate,
      min_heart_rate_time: @min_heart_rate_time,
      max_heart_rate: @max_heart_rate,
      max_heart_rate_time: @max_heart_rate_time,
      mean_heart_rate: @heart_rates.sum / @heart_rates.size,
      min_heart_rate_limit: @min_heart_rate_limit,
      max_heart_rate_limit: @max_heart_rate_limit,
      noise_count: @noise_count,
      measurement_datetime: @start_time,
      artefact_rate: (@noise_count.to_f / @row_count) * 100, # We could compared it with @qrs_count to see the proportion of QRS rows that are artefacts
      qrs_count: @qrs_count
    }


  end

end
