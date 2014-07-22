class NotificationType < ActiveRecord::Base
  belongs_to :service
  has_many   :conditions
end
