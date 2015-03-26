class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :friend_email, :friend_name, :token
      t.text :message
      t.timestamps
    end
  end
end
