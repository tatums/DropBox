class CreateHistories < ActiveRecord::Migration
  def self.up
    create_table :histories do |t|
      t.integer :user_id
      t.string :user_name
      t.string :remote_ip
      t.string :action_type
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :histories
  end
end
