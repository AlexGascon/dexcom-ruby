# frozen_string_literal: true

require 'dexcom/blood_glucose/api_handler'
require 'dexcom/blood_glucose/class_methods'

module Dexcom
  class BloodGlucose
    extend BloodGlucoseUtils::ApiHandler
    extend BloodGlucoseUtils::ClassMethods
  end
end
