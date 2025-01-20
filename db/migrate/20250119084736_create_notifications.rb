class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false
      t.integer :visited_id, null: false
      t.integer :tweet_id
      t.integer :comment_id
      t.string :action_type, null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
  end
end
