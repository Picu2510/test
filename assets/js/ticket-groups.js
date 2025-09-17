// assets/js/ticket-groups.js
(() => {
  const $type      = document.querySelector('#type_id');
  const $subtype   = document.querySelector('#subtype_id');
  const $structure = document.querySelector('#f_struct'); // hidden input z id zasobu
  const $group     = document.querySelector('#group_id');

  if (!$type || !$subtype || !$group) return;

  let aborter = null;

  function setLoading(select, text) {
    select.disabled = true;
    select.innerHTML = '';
    const opt = document.createElement('option');
    opt.value = '';
    opt.textContent = text || 'Ładowanie…';
    select.appendChild(opt);
  }
  function setOptions(select, items) {
    select.innerHTML = '';
    if (!items || !items.length) {
      const opt = document.createElement('option');
      opt.value = '';
      opt.textContent = 'Brak dopasowanych grup';
      select.appendChild(opt);
      select.disabled = true;
      return;
    }
    const frag = document.createDocumentFragment();
    const ph = document.createElement('option');
    ph.value = '';
    ph.textContent = '— Wybierz... —';
    frag.appendChild(ph);
    for (const it of items) {
      const opt = document.createElement('option');
      opt.value = String(it.id);
      opt.textContent = it.nazwa || ('Grupa #'+it.id);
      frag.appendChild(opt);
    }
    select.appendChild(frag);
    select.disabled = false;
  }

  async function fetchGroups() {
    const api = $group.getAttribute('data-groups-url') || '/api/cmms/responsibilities.php';
    const typeId      = $type.value || '';
    const subtypeId   = $subtype.value || '';
    const structureId = $structure ? ($structure.value || '') : '';
    const mpkHidden   = document.querySelector('#mpk_id');
    const mpkId       = mpkHidden ? (mpkHidden.value || '') : '';

    if (!typeId) { setOptions($group, []); return; }

    if (aborter) aborter.abort();
    aborter = new AbortController();

    setLoading($group, 'Ładowanie grup…');

    const q = new URLSearchParams();
    q.set('type_id', typeId);
    if (subtypeId)   q.set('subtype_id', subtypeId);
    if (structureId) q.set('structure_id', structureId);
    if (mpkId)       q.set('mpk_id', mpkId);

    try {
      const res  = await fetch(`${api}?${q.toString()}`, {
        method: 'GET',
        credentials: 'same-origin',
        signal: aborter.signal,
        headers: { 'Accept':'application/json' }
      });
      const json = await res.json().catch(()=>null);
      if (!res.ok || !json || json.ok === false) {
        setOptions($group, []);
        return;
      }
      setOptions($group, json.data || []);
    } catch (e) {
      if (e.name !== 'AbortError') setOptions($group, []);
    }
  }

  // Reaguj na zmiany
  $type.addEventListener('change', fetchGroups);
  $subtype.addEventListener('change', fetchGroups);

  if ($structure) {
    $structure.addEventListener('change', fetchGroups);
    $structure.addEventListener('input',  fetchGroups);
    // gdy picker nie emituje eventów, wykryj zmianę value cyklicznie
    let lastVal = $structure.value;
    setInterval(() => {
      if ($structure.value !== lastVal) {
        lastVal = $structure.value;
        fetchGroups();
      }
    }, 500);
    // nasłuch potencjalnych custom eventów pickera
    ['structure:selected','structure:changed','structure:cleared'].forEach(ev =>
      $structure.addEventListener(ev, fetchGroups)
    );
  }

  // prefill (np. edycja istniejącego zgłoszenia)
  fetchGroups();
})();
