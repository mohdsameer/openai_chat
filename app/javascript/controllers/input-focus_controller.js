import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log('input-focus controller connected!');

    TynApp.Chat.reply.input();
  }
}
