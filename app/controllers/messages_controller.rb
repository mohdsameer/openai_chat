class MessagesController < ApplicationController
  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @message      = @conversation.messages.create(message_params)

    @reply        = @message.create_reply(content: 'I am generating your result, please wait!',
                                          conversation: @conversation)

    generate_open_ai_response
  end

  private

  def generate_open_ai_response
    AiResponseJob.perform_later(message_id: @message.id, reply_id: @reply.id)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
