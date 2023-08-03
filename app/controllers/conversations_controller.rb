class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_conversation, only: [:show]

  def index
    conversations
  end

  def show
    # Fetching messages of current conversation
    @messages = @conversation.messages.order(created_at: :desc)

    # Fetching other conversations list of current_user to show in left sidebar
    @conversations = current_user.conversations.includes(:messages)
  end

  def create
    @conversation = current_user.conversations.create

    redirect_to conversation_path(@conversation)
  end

  private

  def find_conversation
    # Fetching current conversation
    @conversation ||= conversations.find(params[:id])
  end

  def conversations
    @conversations ||= current_user.conversations.order(created_at: :desc)
  end
end
