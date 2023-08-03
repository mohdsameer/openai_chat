import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    createdAt: String,
    messageId: Number
  }

  connect() {
    console.log('message-item controller connected!');

    TynApp.ImageViewer();
  }
}
