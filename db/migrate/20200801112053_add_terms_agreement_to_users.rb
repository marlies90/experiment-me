# frozen_string_literal: true

class AddTermsAgreementToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :terms_agreement, :boolean, null: false, default: false
  end
end
