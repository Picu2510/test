(() => {
  'use strict';

  const typeEl = document.getElementById('type_id');
  const subEl  = document.getElementById('subtype_id');
  if (!typeEl || !subEl) return;

  const url = typeEl.dataset.subtypesUrl || '';
  if (!url) {
    console.warn('[ZGŁOSZENIA] Brak data-subtypes-url na #type_id – pomijam AJAX podtypów');
    return;
  }

  const ALL_VALUE = '0'; // w HTML używamy "0" dla "Wszystkie"
  const currentSubtype = subEl.dataset.current || ALL_VALUE;

  function fillSubtypes(list, preselectId) {
    subEl.innerHTML = '';
    const optAll = document.createElement('option');
    optAll.value = ALL_VALUE;
    optAll.textContent = subEl.querySelector('option')?.textContent || 'Wszystkie';
    subEl.appendChild(optAll);

    list.forEach(row => {
      const opt = document.createElement('option');
      opt.value = String(row.id);
      opt.textContent = row.name;
      if (preselectId && String(preselectId) === String(row.id)) {
        opt.selected = true;
      }
      subEl.appendChild(opt);
    });
  }

  async function loadSubtypes(typeId, preselectId = ALL_VALUE) {
    if (!typeId || String(typeId) === ALL_VALUE) {
      fillSubtypes([], ALL_VALUE);
      return;
    }
    try {
      const res = await fetch(`${url}?type_id=${encodeURIComponent(typeId)}`, {
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
      });
      if (!res.ok) {
        fillSubtypes([], ALL_VALUE);
        return;
      }
      const list = await res.json();
      fillSubtypes(list, preselectId);
    } catch {
      fillSubtypes([], ALL_VALUE);
    }
  }

  // Zmiana typu -> dociągamy podtypy i resetujemy wybór
  typeEl.addEventListener('change', () => loadSubtypes(typeEl.value, ALL_VALUE));

  // Inicjalizacja po załadowaniu
  document.addEventListener('DOMContentLoaded', () => {
    // Jeśli już mamy wybrany typ z URL-a, zsynchronizuj podtypy
    if (typeEl.value && String(typeEl.value) !== ALL_VALUE) {
      loadSubtypes(typeEl.value, currentSubtype);
    }
  });
})();
