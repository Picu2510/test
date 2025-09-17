// /assets/js/delete-modal.js
(() => {
  const DBG = location.search.includes('dbgmodal=1');
  const log  = (...a) => { if (DBG) console.log('[delete-modal]', ...a); };
  const warn = (...a) => { if (DBG) console.warn('[delete-modal]', ...a); };

  function els() {
    // pobieraj ZA KAŻDYM RAZEM aktualne referencje z DOM (leniwie)
    return {
      modal   : document.getElementById('modal-delete'),
      nameEl  : document.getElementById('del-name'),
      idEl    : document.getElementById('del-id'),
      submitB : document.getElementById('del-submit'),
      form    : document.getElementById('del-form'),
      idInput : document.getElementById('del-id-input'),
    };
  }

  function openModal(m) { m.classList.add('show'); m.setAttribute('aria-hidden','false'); }
  function closeModal(m) { m.classList.remove('show'); m.setAttribute('aria-hidden','true'); }

  function getId(btn){
    let id = Number.parseInt(btn.dataset.id || '', 10);
    if (!Number.isFinite(id) || id <= 0) {
      const href = btn.getAttribute('href') || '';
      const m = href.match(/[?&]id=(\d+)/);
      if (m) id = Number.parseInt(m[1], 10);
    }
    return Number.isFinite(id) && id > 0 ? id : null;
  }
  function getName(btn){
    const n = (btn.dataset.name || '').trim();
    if (n) return n;
    const row  = btn.closest('tr');
    const cell = row && row.querySelector('.item-name, .col-name, [data-col="name"]');
    return cell ? cell.textContent.trim() : '';
  }

  document.addEventListener('DOMContentLoaded', () => {
    log('loaded; .btn-del count =', document.querySelectorAll('.btn-del').length);

    // delegacja – działa też po odświeżeniu tabeli
    document.addEventListener('click', (e) => {
      const btn = e.target.closest('.btn-del');
      if (!btn) return;

      e.preventDefault();

      const id   = getId(btn);
      const name = getName(btn) || (id ? `#${id}` : '—');

      const { modal, nameEl, idEl, form, idInput, submitB } = els();
      log('click .btn-del', { hasModal: !!modal, hasForm: !!form, id, name });

      if (!modal || !form || !idInput || !submitB) {
        warn('Brak wymaganych elementów (#modal-delete, #del-form, #del-id-input, #del-submit).');
        return;
      }
      if (!id) {
        warn('Nie udało się wyliczyć ID do skasowania (brak data-id i id w href).');
        return;
      }

      // ustaw wartości w modalu/formie
      if (nameEl) nameEl.textContent = name;
      if (idEl)   idEl.textContent   = ` (#${id})`;
      idInput.value = String(id);
      form.action   = 'delete.php'; // relatywnie względem list.php

      // podpinamy potwierdzenie (za każdym otwarciem nadpisujemy handler)
      submitB.onclick = () => {
        log('confirm -> submit POST to', form.action, 'with id', idInput.value);
        if (form.requestSubmit) form.requestSubmit();
        else form.submit();
      };

      openModal(modal);
    });

    // zamykanie modala (klik tło / [x] / Escape)
    document.addEventListener('click', (e) => {
      const { modal } = els();
      if (!modal) return;
      if (e.target === modal || e.target.hasAttribute('data-close')) {
        closeModal(modal);
      }
    });
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        const { modal } = els();
        if (modal) closeModal(modal);
      }
    });
  });
})();
