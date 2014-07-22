class NotificationsController < InheritedResources::Base

  def new
    @notification_type = NotificationType.find(params[:notification_type])
    @notification = Notification.new
  end

  def permitted_params
    params.permit!
  end
end
