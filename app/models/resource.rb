class Resource < ApplicationRecord
  belongs_to :experiment, optional: true
end
