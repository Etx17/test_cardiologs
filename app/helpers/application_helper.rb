module ApplicationHelper
  def format_artefact_rate(rate)
    scale = 10.0 ** 5 # to get 5 decimal places
    truncated_rate = (rate * scale).floor / scale
    truncated_rate
  end

end
