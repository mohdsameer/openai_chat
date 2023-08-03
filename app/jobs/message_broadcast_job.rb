class MessageBroadcastJob < ApplicationJob
  def perform(message_id:)
    message      = Message.find(message_id)
    conversation = message.conversation

    Turbo::StreamsChannel.broadcast_prepend_to(
      conversation,
      partial: "messages/message",
      target:  "tynMessages",
      locals:  { message: message,
                 author_id: message.conversation.user_id },
    )

    Turbo::StreamsChannel.broadcast_replace_to(
      conversation,
      partial: "conversations/chat_content/scroll_messages",
      locals:  {  },
      target:  "scrollMessages"
    )

    conversation.broadcast_last_message(message) if message.parent_id.nil?
  end
end
