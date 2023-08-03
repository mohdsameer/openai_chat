import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
	static values = {
		showBtn: Boolean
	}

  connect() {
    console.log('scroll-btn controller connected!');
  }
}
