# frozen_string_literal: true

class BlogPost < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates_presence_of :name, :summary, :description, :publish_date

  has_many :blog_comments, as: :commentable, dependent: :destroy
  has_one_attached :image

  scope :newest_first, -> { order("created_at DESC") }
  scope :published, -> { where("publish_date < ?", Date.current + 1) }
end
