# frozen_string_literal: true

class JournalStatement < ApplicationRecord
  validates_presence_of :name, :category

  scope :id_asc, -> { order("id ASC") }
end
