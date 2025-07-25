// app/javascript/controllers/mobile_navigation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  toggle() {
    document.getElementById("mobile-menu").classList.toggle("hidden");
    this._toggleHamburgerIcon();
  }

  toggleSidebar() {
    const sidebar = document.getElementById('admin-sidebar');
    const overlay = document.getElementById('sidebar-overlay');

    sidebar.classList.toggle('-translate-x-full');
    overlay.classList.toggle('hidden');

    this._toggleHamburgerIcon();
  }

  toggleDropdown(){
    const accountDropdown = document.getElementById('account-dropdown');

    accountDropdown.classList.toggle('hidden');
  }

  _toggleHamburgerIcon(){
    const icon = document.getElementById('icon')

    icon.classList.toggle('fa-bars')
    icon.classList.toggle('fa-times') 
  }
}
