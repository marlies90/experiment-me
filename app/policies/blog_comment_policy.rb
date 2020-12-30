# frozen_string_literal: true

class BlogCommentPolicy < ApplicationPolicy
  def create?
    true
  end
end
