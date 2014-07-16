class NotificationType < ActiveRecord::Base
  belongs_to :service
  has_many   :condition
end
