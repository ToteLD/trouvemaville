import { Controller } from "stimulus"
import { csrfToken } from "@rails/ujs"

export default class extends Controller {

  static targets = [ "clipboard", "span" ]
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
    }).then(reponse => reponse.json()).then(data => {
      if (data.status === "created") {
        this.spanTarget.innerText = "Retirer du comparateur"
        this.clipboardTarget.classList.add("fas")
        this.clipboardTarget.classList.add("fa-clipboard-check")
        this.clipboardTarget.classList.remove("fa-clipboard")
        this.clipboardTarget.classList.remove("far")
      } else if (data.status === "destroyed") {
        this.spanTarget.innerText = "Ajouter au comparateur"
        this.clipboardTarget.classList.remove("fas")
        this.clipboardTarget.classList.remove("fa-clipboard-check")
        this.clipboardTarget.classList.add("fa-clipboard")
        this.clipboardTarget.classList.add("far")
      } else if (data.status === "failed") {
        this.spanTarget.innerText = "Comparateur déjà plein"
      }
    })

  }
}
