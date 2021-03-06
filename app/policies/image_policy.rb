# frozen_string_literal: true

class ImagePolicy < ApplicationPolicy
  def create?
    user&.admin?
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    create?
  end

  def destroy?
    create?
  end
end
