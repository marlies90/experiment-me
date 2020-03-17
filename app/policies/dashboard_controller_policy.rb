# frozen_string_literal: true

class DashboardControllerPolicy < ApplicationPolicy
  def overview?
    user.present?
  end

  def journal?
    overview?
  end

  def experiments?
    overview?
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
