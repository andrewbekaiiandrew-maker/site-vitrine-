/* ===== Mobile Navigation Toggle ===== */
const navToggle = document.getElementById('navToggle');
const navMenu = document.getElementById('navMenu');

navToggle.addEventListener('click', () => {
  navToggle.classList.toggle('active');
  navMenu.classList.toggle('active');
});

document.querySelectorAll('.nav-menu a').forEach(link => {
  link.addEventListener('click', () => {
    navToggle.classList.remove('active');
    navMenu.classList.remove('active');
  });
});

/* ===== Navbar Scroll Effect ===== */
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  if (window.scrollY > 50) {
    navbar.classList.add('scrolled');
  } else {
    navbar.classList.remove('scrolled');
  }
});

/* ===== Scroll Animations ===== */
const animateElements = document.querySelectorAll('.animate-fade-up, .animate-fade-left, .animate-fade-right');

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry, index) => {
    if (entry.isIntersecting) {
      setTimeout(() => {
        entry.target.classList.add('visible');
      }, index * 100);
      observer.unobserve(entry.target);
    }
  });
}, {
  threshold: 0.15,
  rootMargin: '0px 0px -50px 0px'
});

animateElements.forEach(el => observer.observe(el));

/* ===== WhatsApp Button ===== */
const whatsappBtn = document.querySelector('.whatsapp-btn');
if (whatsappBtn) {
  whatsappBtn.addEventListener('click', (e) => {
    const phoneNumber = '[NuméroWhatsApp]';
    const message = encodeURIComponent('Bonjour, je souhaiterais plus d\'informations.');
    window.open(`https://wa.me/${phoneNumber}?text=${message}`, '_blank', 'noopener');
  });
}

/* ===== Form Submission ===== */
const contactForm = document.querySelector('.contact-form');
if (contactForm) {
  contactForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const nom = document.getElementById('nom').value;
    alert(`Merci ${nom} ! Votre message a bien été envoyé. Nous vous répondrons très bientôt.`);
    contactForm.reset();
  });
}

/* ===== Current Year ===== */
const yearEl = document.getElementById('year');
if (yearEl) {
  yearEl.textContent = new Date().getFullYear();
}
