module Helpers
  MILLIS_PER_SECOND = 1000
  MINUTES_BETWEEN_BGS = 5
  MINUTES_IN_A_DAY = 24*60

  def self.mock_api_bgs(last_datetime, number_of_values=1)
    (number_of_values - 1).downto(0)
      .map { |index| index * MINUTES_BETWEEN_BGS }
      .map { |delay_in_minutes| minutes_to_datetime_delta(delay_in_minutes) }
      .map { |datetime_delta| mock_api_bg(last_datetime - datetime_delta) }
  end

  def self.mock_api_bg(datetime)
    unix_timestamp = datetime.to_time.to_i
    unix_timestamp_in_millis = unix_timestamp * 1000

    {
      'DT': "/Date(#{unix_timestamp_in_millis}+0000)/",
      'ST': "/Date(#{unix_timestamp_in_millis})/",
      'Trend': 4,
      'Value': 96,
      'WT': "/Date(#{unix_timestamp_in_millis})/"
    }
  end

  def self.minutes_to_datetime_delta(minutes)
    minutes.to_f / MINUTES_IN_A_DAY
  end
end
