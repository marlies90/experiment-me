# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #:lockable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :timeoutable
  validates :first_name, length: { maximum: 40 }
  validates :first_name, :time_zone, presence: true
  validates :terms_agreement, acceptance: true

  enum role: {
    standard: 0,
    admin: 1
  }

  has_many :journal_entries, dependent: :destroy
  has_many :experiment_users, dependent: :destroy
  has_many :experiments, through: :experiment_users, dependent: :destroy
end
