class Conversation < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :messages, dependent: :destroy

  # Instance methods
  def last_message
    messages.parent_type&.last&.content
  end

  def broadcast_last_message(message)
    Turbo::StreamsChannel.broadcast_replace_to(
      "conversation-#{id}-last-message",
      partial: "conversations/chat_list/last_message",
      locals: { last_message: message.content, conversation: self },
      target: "conversation-#{id}-last-message"
    )
  end
end
