import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log('scroll-messages controller connected!');

    $("#tynChatInput").val("");

    function scrollToBottom() {
      if (!TynApp.Chat.reply.scroll()) {
        let chatBody = document.querySelector('#tynChatBody');
        let height = chatBody.querySelector('.simplebar-content > *').scrollHeight;
        $("#tynChatBody").find($(".simplebar-content-wrapper")).scrollTop(height);
      }
    }

    setTimeout(scrollToBottom, 200)
  }
}
