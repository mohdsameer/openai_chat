class Message < ApplicationRecord
  include ActionView::Helpers::DateHelper

  # Associations
  belongs_to :conversation

  belongs_to :parent, class_name: 'Message', foreign_key: :parent_id, optional: true
  has_one :reply, class_name: 'Message', foreign_key: :parent_id

  # Attachements
  has_one_attached :file

  # Scopes
  scope :parent_type, -> { where(parent_id: nil) }

  # Callbacks
  after_create_commit -> { broadcast_message }

  # Instance Methods
  def time_distance
    distance_of_time_in_words(created_at, Time.current)
  end

  def message_date
    created_at.to_date
  end

  def broadcast_message
    MessageBroadcastJob.perform_later(message_id: id)
  end

  def broadcast_content_change
    broadcast_replace_to(
      self,
      partial: "messages/message",
      target: "message-item-#{id}",
      locals: { message: self }
    )
  end
end
