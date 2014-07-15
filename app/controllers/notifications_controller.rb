class NotificationsController < InheritedResources::Base

  def update
    @notification = Notification.find(params[:id])
    if @notification.update_attributes(permitted_params)
      @notification.conditions.merge!(params[:notification][:conditions])
      @notification.save
    end
    redirect_to @notification
  end

  def permitted_params
    params.require(:notification).permit!
  end
end
