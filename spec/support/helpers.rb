module Helpers
  def self.mock_api_bgs(last_datetime, number_of_values=1)
    mock_api_bg(last_datetime) * number_of_values
  end

  def self.mock_api_bg(datetime)
    unix_timestamp = datetime.to_time.to_i
    unix_timestamp_in_millis = unix_timestamp * 1000

    [{
      'DT': "/Date(#{unix_timestamp_in_millis}+0000)/",
      'ST': "/Date(#{unix_timestamp_in_millis})/",
      'Trend': 4,
      'Value': 96,
      'WT': "/Date(#{unix_timestamp_in_millis})/"
    }]
  end
end
