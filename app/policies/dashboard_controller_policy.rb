# frozen_string_literal: true

class DashboardControllerPolicy < ApplicationPolicy
  def lab?
    user.present?
  end

  def journal?
    lab?
  end

  def experiments?
    lab?
  end

  def settings?
    lab?
  end

  def charts?
    lab?
  end

  def admin?
    user&.admin?
  end
end
