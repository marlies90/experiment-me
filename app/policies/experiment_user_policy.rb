# frozen_string_literal: true

class ExperimentUserPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def show?
    create?
  end

  def new?
    create?
  end

  def update?
    create?
  end
end
