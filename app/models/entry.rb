# frozen_string_literal: true

class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room

  def self.get_another_entries(room_id, current_user)
    Entry.preload(:user).where(room_id:).where.not(user_id: current_user.id)
  end
end
