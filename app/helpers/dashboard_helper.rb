module DashboardHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def start_or_cancel_experiment
    if params[:status] == "cancelled"
      "Stop"
    else
      "Start"
    end
  end
end
