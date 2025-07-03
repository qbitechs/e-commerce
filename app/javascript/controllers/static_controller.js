import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  connect() {
    this.setupScrollAnimation();
    this.setupBillingToggle();
  }

  setupScrollAnimation() {
    const observerOptions = {
      threshold: 0.1,
      rootMargin: '0px 0px -50px 0px'
    };
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate');
        }
      });
    }, observerOptions);
    document.querySelectorAll('.animate-on-scroll').forEach(el => {
      observer.observe(el);
    });
  }

  setupBillingToggle() {
    const billingToggle = document.getElementById('billing-toggle');
    if (!billingToggle) return;
    const monthlyPrices = document.querySelectorAll('.monthly-price');
    const yearlyPrices = document.querySelectorAll('.yearly-price');
    let isYearly = false;
    billingToggle.addEventListener('click', () => {
      isYearly = !isYearly;
      if (isYearly) {
        billingToggle.classList.add('bg-primary');
        billingToggle.querySelector('span').classList.add('translate-x-6');
        monthlyPrices.forEach(price => price.classList.add('hidden'));
        yearlyPrices.forEach(price => price.classList.remove('hidden'));
      } else {
        billingToggle.classList.remove('bg-primary');
        billingToggle.querySelector('span').classList.remove('translate-x-6');
        monthlyPrices.forEach(price => price.classList.remove('hidden'));
        yearlyPrices.forEach(price => price.classList.add('hidden'));
      }
    });
  }
} 