// assets/js/subtype-loader.js
(() => {
  const $type = document.querySelector('#type_id');
  const $sub  = document.querySelector('#subtype_id');
  if (!$type || !$sub) return;

  let aborter = null;

  function setPlaceholder(text) {
    $sub.innerHTML = '';
    const opt = document.createElement('option');
    opt.value = '';
    opt.textContent = text || '— Wybierz... —';
    $sub.appendChild(opt);
  }

  function setLoading() {
    $sub.disabled = true;
    setPlaceholder('Ładowanie podtypów…');
  }

  function normalizeData(json) {
    // Akceptujemy: [ {id,name} ] albo { ok:true, data:[...] }
    const raw = Array.isArray(json) ? json : (json && Array.isArray(json.data) ? json.data : []);
    return raw.map(it => ({
      id: Number(it.id),
      name: it.name || it.nazwa || it.label || String(it.id)
    })).filter(it => it.id > 0);
  }

  function fillOptions(items, preselectId = 0) {
    setPlaceholder('— Wybierz... —');
    if (!items.length) {
      $sub.disabled = true;
      // emituj change, aby np. lista grup wróciła do trybu „tylko Typ”
      $sub.dispatchEvent(new Event('change', { bubbles: true }));
      return;
    }
    const frag = document.createDocumentFragment();
    for (const it of items) {
      const opt = document.createElement('option');
      opt.value = String(it.id);
      opt.textContent = it.name;
      if (preselectId && Number(preselectId) === it.id) opt.selected = true;
      frag.appendChild(opt);
    }
    $sub.appendChild(frag);
    $sub.disabled = false;
    // poinformuj pozostałe skrypty (np. type-groups.js), że podtyp się zmienił
    $sub.dispatchEvent(new Event('change', { bubbles: true }));
  }

  async function loadSubtypes({ keepSelection = false } = {}) {
    const typeId = $type.value;
    if (!typeId) {
      setPlaceholder('— Wybierz Typ —');
      $sub.disabled = true;
      $sub.dispatchEvent(new Event('change', { bubbles: true }));
      return;
    }

    const preselected = keepSelection ? ($sub.value || Number($sub.getAttribute('data-current') || 0)) : 0;

    const api =
      $type.getAttribute('data-subtypes-url') ||
      '/api/cmms/ticket_subtypes.php';

    const url = new URL(api, window.location.origin);
    url.searchParams.set('type_id', typeId);

    if (aborter) aborter.abort();
    aborter = new AbortController();

    setLoading();
    try {
      const res = await fetch(url.toString(), {
        method: 'GET',
        credentials: 'same-origin',
        signal: aborter.signal,
        headers: { 'Accept': 'application/json' }
      });
      const json = await res.json().catch(() => (Array.isArray(window.__fallback_subtypes) ? window.__fallback_subtypes : []));
      if (!res.ok) throw new Error('HTTP ' + res.status);

      const items = normalizeData(json);
      fillOptions(items, preselected);
    } catch (e) {
      if (e.name === 'AbortError') return;
      // awaryjnie wyczyść i zablokuj
      setPlaceholder('Brak danych podtypów');
      $sub.disabled = true;
      $sub.dispatchEvent(new Event('change', { bubbles: true }));
      // console.warn('[subtype-loader] error:', e);
    }
  }

  // Inicjalizacja
  // Jeśli typ już ustawiony (edycja) — załaduj i spróbuj wybrać data-current
  if ($type.value) {
    loadSubtypes({ keepSelection: true });
  } else {
    setPlaceholder('— Wybierz Typ —');
    $sub.disabled = true;
  }

  // Reaguj na zmianę typu
  $type.addEventListener('change', () => {
    // resetuj wybór podtypu
    $sub.selectedIndex = 0;
    // przeładuj podtypy dla nowego typu
    loadSubtypes({ keepSelection: false });
  });
})();
