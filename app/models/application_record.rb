require 'rails/all'
require 'csv'
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
