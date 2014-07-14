class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :service

  store_accessor :conditions
end
