# frozen_string_literal: true

class ObservationsControllerPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    index?
  end

  def create?
    index?
  end

  def new?
    index?
  end

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    index?
  end
end
