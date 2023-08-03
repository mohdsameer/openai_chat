import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    conversationId: Number,
    isGroupChat: Boolean,
    thisUserName: String
  }

  connect() {
    console.log('message-form controller connected!');

    const chatInput      = document.querySelector("#tynChatInput");
    const submitBtn      = document.querySelector("#send-message-btn");
    const conversationId = this.conversationIdValue;
    const isGroupChat    = this.isGroupChatValue;
    const thisUserName   = this.thisUserNameValue;

    // This is for handle enter key on message form
    chatInput.addEventListener("keydown", async (event) => {
      if (event.key === "Enter" || event.keyCode === 13) {
        event.preventDefault();
        submitBtn.click();
        return false;
      }
    });
  }
}
