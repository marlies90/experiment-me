# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  validates_presence_of :first_name

  enum role: {
    standard: 0,
    admin: 1
  }

  has_many :journal_entries
  has_many :experiment_users
  has_many :experiments, through: :experiment_users
end
