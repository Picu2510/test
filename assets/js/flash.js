// assets/js/flash.js
(function () {
  function dismiss(el) {
    if (!el || el.classList.contains('is-hiding')) return;
    el.classList.add('is-hiding');
    el.style.animation = 'flash-out .3s ease-in forwards';
    setTimeout(() => el.remove(), 360);
  }

  function arm(el) {
    if (!el || el.dataset.armed) return;
    el.dataset.armed = '1';
    const delay = parseInt(el.getAttribute('data-delay') || '2000', 10);
    let t = setTimeout(() => dismiss(el), delay);
    el.addEventListener('mouseenter', () => { clearTimeout(t); });
    el.addEventListener('mouseleave', () => { t = setTimeout(() => dismiss(el), 1200); });
  }

  function init() {
    document.querySelectorAll('.flash-modal').forEach(arm);
  }

  // Inicjalizacja
  if (document.readyState !== 'loading') init();
  else document.addEventListener('DOMContentLoaded', init);
  window.addEventListener('pageshow', init); // bfcache na mobilkach

  // Delegacja kliknięcia na krzyżyk
  document.addEventListener('click', (e) => {
    const btn = e.target.closest('.flash-modal__close');
    if (btn) dismiss(btn.closest('.flash-modal'));
  });

  // (opcjonalne) sygnał diagnostyczny
  console.debug('[flash.js] ready');
})();
