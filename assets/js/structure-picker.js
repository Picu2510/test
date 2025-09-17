// assets/js/structure-picker.js
// Modalowy picker struktury + auto-uzupełnianie etykiety i MPK
(function () {
  'use strict';

  // Utils
  const byId = (id) => document.getElementById(id);
  const debounce = (fn, ms) => { let t; return (...a) => { clearTimeout(t); t = setTimeout(() => fn(...a), ms); }; };
  const toInt = (v) => { const n = parseInt(v, 10); return Number.isNaN(n) ? 0 : n; };

  // DOM
  const modal     = byId('structModal');
  const openBtn   = byId('btn-struct-pick');
  const clearBtn  = byId('btn-struct-clear');

  const idInput    = byId('f_struct');        // HIDDEN: name="struktura_id"
  const labelInput = byId('f_struct_label');  // READONLY: label obok pola

  const typeSel   = byId('type_id');
  const subSel    = byId('subtype_id');
  const mpkRO     = byId('mpk_readonly');
  const mpkHidden = byId('mpk_id');

  const treeEl    = byId('structContainer');
  const searchEl  = byId('structSearch');
  const loadingEl = byId('structLoading');
  const errorEl   = byId('structError');

  // Endpoints
  function getTreeApi() {
    return (modal && modal.dataset.api) || '/api/structure/tree.php';
  }
  function getLabelApi() {
    return (modal && (modal.dataset.labelApi || modal.dataset.metaApi))
        || (idInput && idInput.dataset.labelApi)
        || (window.ROOT_URL ? (window.ROOT_URL + 'api/structure/label.php') : '/api/structure/label.php');
  }

  async function fetchStructMeta(params) {
    const url = getLabelApi() + '?' + params.toString();
    const res = await fetch(url, { headers: { 'Accept': 'application/json' }, credentials: 'same-origin', cache: 'no-store' });
    if (!res.ok) throw new Error('HTTP ' + res.status);
    return res.json();
  }

  // Modal helpers + sticky offset dla search
  function setStickyOffset() {
    const head = modal?.querySelector('.modal-header');
    const body = modal?.querySelector('.tree-modal__body');
    if (head && body) body.style.setProperty('--headH', (head.offsetHeight + 8) + 'px');
  }
  let headRO = null;



/*
  function openModal() {
    if (!modal) return;
    modal.classList.add('open');
    modal.setAttribute('aria-hidden', 'false');
   if (getComputedStyle(modal).display === 'none') modal.style.display = 'block';
    setStickyOffset();
    try {
      const head = modal.querySelector('.modal-header');
      if (head && !headRO) {
        headRO = new ResizeObserver(setStickyOffset);
        headRO.observe(head);
      }
    } catch {}
    searchEl?.focus();
  }
  
  function closeModal() {
    if (!modal) return;
    modal.classList.remove('open');
    modal.setAttribute('aria-hidden', 'true');
    modal.style.display = '';
  }
*/  

function openModal() {
  if (!modal) return;
  modal.classList.add('open');
  modal.setAttribute('aria-hidden', 'false'); // <— to było brakujące
  modal.style.display = 'block';
  // focus po next frame, żeby DOM się narysował
  requestAnimationFrame(() => { try { searchEl?.focus(); } catch(_){} });
}

function closeModal() {
  if (!modal) return;
  modal.classList.remove('open');
  modal.setAttribute('aria-hidden', 'true');  // <— wracamy do true
  modal.style.display = '';
}




  modal?.querySelectorAll('[data-close]').forEach(b => b.addEventListener('click', closeModal));
  modal?.addEventListener('click', (e) => { if (e.target === modal) closeModal(); });

  // Drzewo – stan + indeks
  let treeData = null, loaded = false;
  const flatIndex = new Map();   // id -> node
  const parentIdx = new Map();   // id -> parentId

  function indexTree(root) {
    flatIndex.clear(); parentIdx.clear();
    if (!root) return;
    const st = [root];
    parentIdx.set(root.id, null);
    while (st.length) {
      const n = st.pop();
      flatIndex.set(n.id, n);
      (n.children || []).forEach(c => { parentIdx.set(c.id, n.id); st.push(c); });
    }
  }

  function buildPath(id) {
    const parts = [];
    let cur = id;
    const guard = new Set();
    while (cur !== null && flatIndex.has(cur) && !guard.has(cur)) {
      guard.add(cur);
      const n = flatIndex.get(cur);
      if (n?.name) parts.push(n.name);
      cur = parentIdx.get(cur);
    }
    // wytnij ewentualny sztuczny root
    const last = parts[parts.length - 1];
    if (last === 'Zakład' || last === 'ROOT') parts.pop();
    return parts.reverse().join(' / ');
  }

  function setLoading(on) { loadingEl?.classList.toggle('hidden', !on); }
  function setError(msg) {
    if (!errorEl) return;
    if (msg) { errorEl.textContent = msg; errorEl.classList.remove('hidden'); }
    else { errorEl.textContent = ''; errorEl.classList.add('hidden'); }
  }

  // render + interakcja
  function renderTree(filter) {
    if (!treeData?.root || !treeEl) return;

    const q = (filter || '').toLowerCase();
    treeEl.innerHTML = '';

    const matches = n => !q || (n.name && n.name.toLowerCase().includes(q));
    const anyDesc = n => matches(n) || (n.children || []).some(anyDesc);

    function makeNode(n) {
      const li = document.createElement('li');

      const row = document.createElement('div');
      row.className = 'node';
      row.setAttribute('data-id', n.id);

      const hasChildren = (n.children?.length || 0) > 0;

      const toggle = document.createElement('button');
      toggle.type = 'button';
      toggle.className = 'toggle';
      toggle.disabled = !hasChildren;
      toggle.setAttribute('aria-expanded', q ? 'true' : (hasChildren ? 'false' : 'true'));
      toggle.setAttribute('data-id', n.id);
      row.appendChild(toggle);

      const label = document.createElement('span');
      label.className = 'label';
      label.textContent = n.name;
      row.appendChild(label);

      if (n.id !== 0) {
        const badge = document.createElement('span');
        badge.className = 'badge';
        badge.textContent = 'ID ' + n.id;
        row.appendChild(badge);
      }

      li.appendChild(row);

      let childUL = null;
      if (hasChildren) {
        childUL = document.createElement('ul');
        if (!q) childUL.style.display = 'none';
        n.children.slice().sort((a, b) => a.name.localeCompare(b.name)).forEach(c => {
          if (!q || anyDesc(c)) childUL.appendChild(makeNode(c));
        });
        li.appendChild(childUL);
      }

      // expand/collapse
      toggle.addEventListener('click', (ev) => {
        ev.stopPropagation();
        const open = toggle.getAttribute('aria-expanded') === 'true';
        toggle.setAttribute('aria-expanded', open ? 'false' : 'true');
        if (childUL) childUL.style.display = open ? 'none' : '';
      });

      // wybór: klik w CAŁY wiersz (poza toggle) lub w sam label
      function selectThis() {
        // zdejmij poprzedni „is-active”
        treeEl.querySelectorAll('.node.is-active').forEach(el => el.classList.remove('is-active'));
        treeEl.querySelectorAll('.label.selected').forEach(el => el.classList.remove('selected'));

        row.classList.add('is-active');
        label.classList.add('selected');

        if (n.id !== 0) {
          window.cmmsOnStructurePicked({
            id: n.id,
            name: n.name,
            path: buildPath(n.id)
          });
          closeModal();
        }
      }
      row.addEventListener('click', (ev) => { if (!ev.target.closest('.toggle')) selectThis(); });
      label.addEventListener('click', (ev) => { ev.stopPropagation(); selectThis(); });

      return li;
    }

    const ul = document.createElement('ul');
    (treeData.root.children || []).forEach(c => { if (!q || anyDesc(c)) ul.appendChild(makeNode(c)); });
    treeEl.appendChild(ul);

    // Preselekcja (jeśli formularz ma wartość)
    highlightSelected();
  }

  function highlightSelected() {
    const pre = toInt(idInput?.value || '0');
    treeEl.querySelectorAll('.node.is-active').forEach(el => el.classList.remove('is-active'));
    treeEl.querySelectorAll('.label.selected').forEach(el => el.classList.remove('selected'));

    if (!pre || !flatIndex.has(pre)) return;

    // rozwiń łańcuch
    const chain = [];
    let cur = pre; const seen = new Set();
    while (cur != null && flatIndex.has(cur) && !seen.has(cur)) {
      seen.add(cur); chain.push(cur);
      cur = parentIdx.get(cur);
    }
    chain.reverse();

    for (const id of chain) {
      const row = treeEl.querySelector(`.node[data-id="${id}"]`);
      if (!row) continue;
      const ul = row.nextElementSibling && row.nextElementSibling.tagName === 'UL' ? row.nextElementSibling : null;
      const toggle = row.querySelector('.toggle');
      if (ul) ul.style.display = '';
      if (toggle) { toggle.disabled = false; toggle.setAttribute('aria-expanded', 'true'); }
    }

    const row = treeEl.querySelector(`.node[data-id="${pre}"]`);
    if (row) {
      row.classList.add('is-active');
      row.querySelector('.label')?.classList.add('selected');
      try { row.scrollIntoView({ block: 'center', inline: 'nearest' }); } catch {}
    }
  }

  async function loadTreeOnce() {
    if (loaded) { renderTree(searchEl?.value?.trim() || ''); return; }
    setError(null); setLoading(true);
    try {
      const url = getTreeApi();
      const res = await fetch(url, { headers: { 'Accept': 'application/json' }, credentials: 'same-origin' });
      const raw = await res.text();
      if (!res.ok) throw new Error('HTTP ' + res.status);
      let data; try { data = JSON.parse(raw); } catch { throw new Error('INVALID_JSON'); }
      if (!data?.root) throw new Error('NO_ROOT');
      treeData = data;
      indexTree(data.root);
      renderTree('');
      loaded = true;
    } catch (e) {
      console.error('[STRUCT PICKER] load error:', e);
      setError('Nie mogę wczytać drzewa (' + (e?.message || 'unknown') + ').');
    } finally {
      setLoading(false);
    }
  }

  // Meta: label + MPK (bez dublowania nazwy/ID)
  async function refreshStructMeta() {
    const sid = toInt(idInput?.value || '0');
    const tid = typeSel ? toInt(typeSel.value) : 0;
    const sub = (subSel && subSel.value !== '') ? toInt(subSel.value) : null;

    if (!sid) {
      if (labelInput) labelInput.value = '';
      if (mpkRO) mpkRO.value = '';
      if (mpkHidden) mpkHidden.value = '0';
      return;
    }

    try {
      const params = new URLSearchParams();
      params.set('id', String(sid));
      if (tid) params.set('type_id', String(tid));
      if (sub !== null) params.set('subtype_id', String(sub));

      const j = await fetchStructMeta(params);

      // Etykieta: preferuj gotowe j.label (np. „A / B / C”), potem path, potem name
      if (labelInput) {
        const lbl = (typeof j?.label === 'string' && j.label.trim())
          ? j.label.trim()
          : (j?.path || j?.name || '');
        labelInput.value = lbl;
        labelInput.title = j?.path || '';
      }

      // MPK do UI i hidden
      const mpkId   = j?.mpk_id ? parseInt(j.mpk_id, 10) : 0;
      const mpkName = j?.mpk_name || '';
      const mpkCode = j?.mpk_code || '';
      let mpkDisplay = '';
      if (mpkName && mpkCode) mpkDisplay = `${mpkName} (${mpkCode})`;
      else if (mpkName)       mpkDisplay = mpkName;
      else if (mpkCode)       mpkDisplay = mpkCode;
      else                    mpkDisplay = String(mpkId || 0);
      if (mpkRO)     mpkRO.value     = mpkDisplay;
      if (mpkHidden) mpkHidden.value = String(mpkId || 0);
    } catch (e) {
      console.warn('[structure-picker] meta error:', e);
    }
  }

  // Publiczne API – ustawianie wyboru z drzewa
  window.cmmsOnStructurePicked = function (node) {
    if (!node || !('id' in node) || !idInput) return;
    idInput.value = String(node.id);

    // w polu pokaż pełną ścieżkę (bez duplikacji nazwy)
    if (labelInput) {
      const path = buildPath(node.id);
      labelInput.value = path || node.name || '';
      labelInput.title = path || '';
    }

    idInput.dispatchEvent(new Event('input',  { bubbles: true }));
    idInput.dispatchEvent(new Event('change', { bubbles: true }));

    // po wyborze przelicz meta (MPK)
    refreshStructMeta();
  };

  window.cmmsClearStructure = function () {
    if (!idInput) return;
    idInput.value = '';
    if (labelInput) labelInput.value = '';
    if (mpkRO) mpkRO.value = '';
    if (mpkHidden) mpkHidden.value = '0';
    idInput.dispatchEvent(new Event('input', { bubbles: true }));
    idInput.dispatchEvent(new Event('change', { bubbles: true }));
  };

  // Init / hooki
  function init() {
    if (!modal || !treeEl || !openBtn) return;

    clearBtn?.addEventListener('click', () => window.cmmsClearStructure());

    idInput?.addEventListener('change', refreshStructMeta);
    idInput?.addEventListener('input',  refreshStructMeta);
    typeSel?.addEventListener('change', refreshStructMeta);
    subSel?.addEventListener('change',  refreshStructMeta);

    //openBtn.addEventListener('click', async () => {
    //  openModal();
    //  await loadTreeOnce();
      // po każdym otwarciu rozwiń i oznacz bieżący wybór czerwonym obramowaniem
    //  highlightSelected();
    //});

openBtn?.addEventListener('click', async () => {
  openModal();
  await loadTreeOnce();
  const preSel = toInt(idInput?.value || '0');
  if (preSel && flatIndex.has(preSel)) expandAncestors(preSel);
});

    searchEl?.addEventListener('input', debounce(() => {
      renderTree(searchEl.value.trim());
    }, 150));

    // startowo (np. edycja istniejącego zgłoszenia)
    refreshStructMeta();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
