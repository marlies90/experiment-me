class CreateMailPreferences < ActiveRecord::Migration[6.1]
  def change
    create_table :mail_preferences do |t|
      t.belongs_to :user, null: false
      t.integer :mail_type, null: false
      t.integer :status, null: false
      t.timestamps
    end
  end
end
