import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "subdomainFields",
    "customDomainFields",
    "subdomainInstructions",
    "customDomainInstructions",
    "domainType"
  ]

  connect() {
    this.updateFormDisplay()
  }

  updateFormDisplay() {
    const isSubdomainSelected = this.domainTypeTargets.find(radio => radio.checked).value === "subdomain"

    // Toggle form fields
    this.subdomainFieldsTarget.classList.toggle("hidden", !isSubdomainSelected)
    this.customDomainFieldsTarget.classList.toggle("hidden", isSubdomainSelected)

    // Toggle instructions
    this.subdomainInstructionsTarget.classList.toggle("hidden", !isSubdomainSelected)
    this.customDomainInstructionsTarget.classList.toggle("hidden", isSubdomainSelected)
  }
} 