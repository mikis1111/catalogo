import "@hotwired/turbo-rails"
import "./rails-ujs"

import { Application } from "@hotwired/stimulus"
import StimulusControllers from "./controllers"
window.Stimulus = Application.start()

document.addEventListener("DOMContentLoaded", function () {
  const elems = document.querySelectorAll(".tooltipped");
  if (window.M && M.Tooltip) M.Tooltip.init(elems);

  const checkbox = document.getElementById("book_borrowed");
  const fields = document.getElementById("borrower-fields");

  if (checkbox && fields) {
    const toggleFields = () => {
      fields.style.display = checkbox.checked ? "block" : "none";
    };

    checkbox.addEventListener("change", toggleFields);
    toggleFields();
  }
});


