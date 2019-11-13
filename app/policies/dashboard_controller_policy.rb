class DashboardControllerPolicy < ApplicationPolicy
  def overview?
    user.present?
  end

  def settings?
    overview?
  end

  def progress?
    overview?
  end

  def admin?
    user&.admin?
  end
end
