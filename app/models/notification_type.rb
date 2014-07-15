class NotificationType < ActiveRecord::Base
  belongs_to :service
  belongs_to :condition
end
