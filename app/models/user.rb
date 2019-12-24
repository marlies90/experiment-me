class User < ApplicationRecord
  extend FriendlyId
  friendly_id :date_slug, :use => :slugged
  include DateConcern

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  enum role: [:standard, :admin]

  has_many :journal_entries
end
