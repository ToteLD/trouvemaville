import { Controller } from "stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {

  static targets = [ "clipboard" ]
  static values = { url: String }


  toggle() {
    // this.clipboardTarget.classList.toggle("fas fa-clipboard-check")
    // this.clipboardTarget.classList.toggle("far fa-clipboard")

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken(),
        "Accept": "application/json",
        "Content-Type": "application/json"
      }
    }).then(reponse => reponse.json()).then(data => console.log(data))

  }
}
