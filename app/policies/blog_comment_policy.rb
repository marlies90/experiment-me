# frozen_string_literal: true

class BlogCommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    user&.admin?
  end
end
