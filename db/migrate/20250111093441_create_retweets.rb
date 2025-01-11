class CreateRetweets < ActiveRecord::Migration[7.0]
  def change
    create_table :retweets do |t|
      t.integer :user_id
      t.integer :tweet_id

      t.timestamps
    end
    add_index :retweets, :user_id
    add_index :retweets, :tweet_id
    add_index :retweets, %i[user_id tweet_id], unique: true
  end
end
