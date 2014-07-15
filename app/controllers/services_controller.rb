class ServicesController < InheritedResources::Base

  def permitted_params
    params.permit(:service => [:name, :description, :url])
  end
end
