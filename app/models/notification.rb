# frozen_string_literal: true

class Notification < ApplicationRecord
  belongs_to :tweet, optional: true
  belongs_to :comment, class_name: 'Tweet', optional: true
  belongs_to :visitor, class_name: 'User'
  belongs_to :visited, class_name: 'User'
end
