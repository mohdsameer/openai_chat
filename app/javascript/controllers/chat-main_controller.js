import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    assideItemId: String
  }

  connect() {
    console.log('chat-main controller connected!');

    $(".tyn-aside-item").removeClass("active");
    $(`#${this.assideItemIdValue}`).addClass("active");
  }
}
