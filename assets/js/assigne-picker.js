// assets/js/assigne-picker.js
(() => {
  document.addEventListener('DOMContentLoaded', () => {
    const selType = document.getElementById('type_id');
    const selSub  = document.getElementById('subtype_id');
    if (!selType || !selSub) return;

    const getSubtypesUrl = () =>
      selType.getAttribute('data-subtypes-url') || '/api/cmms/ticket_subtypes.php';

    const setLoading = (select, text) => {
      select.disabled = true;
      select.innerHTML = '';
      const opt = document.createElement('option');
      opt.value = '';
      opt.textContent = text || 'Ładowanie…';
      select.appendChild(opt);
    };
    const setOptions = (select, rows, placeholder = '— Wybierz... —') => {
      select.innerHTML = '';
      if (!rows || !rows.length) {
        const opt = document.createElement('option');
        opt.value = '';
        opt.textContent = 'Brak podtypów';
        select.appendChild(opt);
        select.disabled = true;
        return;
      }
      const frag = document.createDocumentFragment();
      const ph = document.createElement('option');
      ph.value = '';
      ph.textContent = placeholder;
      frag.appendChild(ph);
      for (const r of rows) {
        const opt = document.createElement('option');
        opt.value = String(r.id);
        opt.textContent = r.name || r.nazwa || ('#'+r.id);
        frag.appendChild(opt);
      }
      select.appendChild(frag);
      select.disabled = false;
    };

    let aborter = null;
    async function loadSubtypes() {
      const typeId = selType.value || '';
      if (!typeId) { setOptions(selSub, []); return; }

      if (aborter) aborter.abort();
      aborter = new AbortController();

      setLoading(selSub, 'Ładowanie podtypów…');
      try {
        const res = await fetch(`${getSubtypesUrl()}?type_id=${encodeURIComponent(typeId)}`, {
          method: 'GET',
          credentials: 'same-origin',
          signal: aborter.signal,
          headers: { 'Accept': 'application/json' }
        });

        let json = null;
        try { json = await res.json(); } catch (_) {}
        let rows = Array.isArray(json) ? json : (Array.isArray(json?.data) ? json.data : []);
        rows = rows
          .filter(r => r && r.id != null && (r.name != null || r.nazwa != null))
          .map(r => ({ id: r.id, name: r.name ?? r.nazwa }));

        const current = selSub.getAttribute('data-current') || '';
        setOptions(selSub, rows);
        if (current && Array.from(selSub.options).some(o => o.value === String(current))) {
          selSub.value = String(current);
        } else {
          selSub.value = '';
        }

        selSub.dispatchEvent(new Event('change', { bubbles: true }));
      } catch (e) {
        if (e.name !== 'AbortError') {
          console.error('[assigne-picker] subtypes fetch error', e);
          setOptions(selSub, []);
        }
      }
    }

    selType.addEventListener('change', loadSubtypes);

    const prepopulated = (selSub.getAttribute('data-prepopulated') || '0') === '1';
    if (!prepopulated) {
      loadSubtypes();
    }
  });
})();
