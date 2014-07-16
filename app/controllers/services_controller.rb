class ServicesController < InheritedResources::Base

  def service_params
    params.require(:service).permit!
  end
end
