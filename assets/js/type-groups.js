// assets/js/type-groups.js
(() => {
  const $type      = document.querySelector('#type_id');
  const $subtype   = document.querySelector('#subtype_id'); // może nie istnieć
  const $group     = document.querySelector('#group_id');
  const $structure = document.querySelector('#f_struct');   // hidden input z ID zasobu

  if (!$type || !$group) return;

  let aborter = null;
  let userPickedSubtype = false; // patrz: 1.2 – użyj podtypu dopiero po świadomym wyborze

  function setLoading(text) {
    $group.disabled = true;
    $group.innerHTML = '';
    const opt = document.createElement('option');
    opt.value = '';
    opt.textContent = text || 'Ładowanie…';
    $group.appendChild(opt);
  }
  function setOptions(items) {
    $group.innerHTML = '';
    const ph = document.createElement('option');
    ph.value = '';
    ph.textContent = '— Wybierz... —';
    $group.appendChild(ph);

    if (!items || !items.length) {
      $group.disabled = true;
      return;
    }
    const frag = document.createDocumentFragment();
    for (const it of items) {
      const opt = document.createElement('option');
      opt.value = String(it.id);
      opt.textContent = it.nazwa || ('Grupa #'+it.id);
      frag.appendChild(opt);
    }
    $group.appendChild(frag);
    $group.disabled = false;
  }

  async function fetchGroups() {
    const typeId = $type.value || '';
    if (!typeId) { setOptions([]); return; }

    const api = $group.getAttribute('data-groups-url') || '/api/cmms/groups_by_type.php';
    if (aborter) aborter.abort();
    aborter = new AbortController();

    const q = new URLSearchParams({ type_id: typeId });

    // podtyp – tylko po świadomym wyborze (jak w 1.2)
    if ($subtype && userPickedSubtype && $subtype.value && $subtype.selectedIndex > 0) {
      q.set('subtype_id', $subtype.value);
    }

    // struktura – jeśli jest ID w hidden input
    if ($structure && $structure.value) {
      q.set('structure_id', $structure.value);
    }

    setLoading('Ładowanie grup…');
    try {
      const res  = await fetch(`${api}?${q.toString()}`, {
        method: 'GET',
        credentials: 'same-origin',
        signal: aborter.signal,
        headers: { 'Accept':'application/json' }
      });
      const json = await res.json().catch(()=>null);
      if (!res.ok || !json || json.ok === false) { setOptions([]); return; }
      setOptions(json.data || []);
    } catch (e) {
      if (e.name !== 'AbortError') setOptions([]);
    }
  }

  // Init
  fetchGroups();

  // Typ: reset wyboru podtypu i ładuj na nowo
  $type.addEventListener('change', () => {
    userPickedSubtype = false;
    if ($subtype) $subtype.selectedIndex = 0;
    fetchGroups();
  });

  // Podtyp: oznacz jako wybrany i ładuj
  if ($subtype) {
    $subtype.addEventListener('change', () => {
      userPickedSubtype = !!$subtype.value && $subtype.selectedIndex > 0;
      fetchGroups();
    });
    // prefill (edycja istniejącego zgłoszenia)
    if ($subtype.value && $subtype.selectedIndex > 0) userPickedSubtype = true;
  }

  // Struktura: nasłuch change/input + watchdog na wypadek custom pickera
  if ($structure) {
    $structure.addEventListener('change', fetchGroups);
    $structure.addEventListener('input',  fetchGroups);
    let lastVal = $structure.value;
    setInterval(() => {
      if ($structure.value !== lastVal) {
        lastVal = $structure.value;
        fetchGroups();
      }
    }, 500);
    // jeśli Twój picker emituje eventy niestandardowe:
    ['structure:selected','structure:changed','structure:cleared'].forEach(ev =>
      $structure.addEventListener(ev, fetchGroups)
    );
  }
})();
