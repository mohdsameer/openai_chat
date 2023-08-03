import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log('chat-item controller connected!');

    TynApp.Chat.item();
  }
}
