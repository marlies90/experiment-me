# frozen_string_literal: true

class BlogComment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :blog_comments, as: :commentable, dependent: :destroy

  validates_presence_of :author_name, :email, :comment

  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }

  scope :oldest_first, -> { order("created_at ASC") }
  scope :newest_first, -> { order("created_at DESC") }
end
