module ApplicationHelper
  def format_artefact_rate(rate)
    scale = 10.0 ** 5 # get 5 decimal places
    truncated_rate = (rate * scale).floor / scale

    color = if truncated_rate < 1
              'dark'
            else
              'red'
            end

    content_tag(:span, "#{truncated_rate}%", style: "color: #{color};")
  end

end
