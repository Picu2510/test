/* /assets/js/cmms.quick-ticket.js */
(() => {
  const $ = (sel, ctx=document) => ctx.querySelector(sel);

  const typeSel = $('#type_id');
  const subSel  = $('#subtype_id');
  const label   = $('#structure_label');
  const sid     = $('#structure_id');

  // 1) Podtypy – dynamiczne ładowanie
  const loadSubtypes = async (typeId, preselect=null) => {
    const url = (typeSel?.dataset?.subtypesUrl) || '/modules/cmms/zgloszenia/api/subtypes.php';
    if (!typeId) { subSel.innerHTML = '<option value="">— wybierz typ najpierw —</option>'; subSel.disabled = true; return; }
    try {
      const res = await fetch(`${url}?type_id=${encodeURIComponent(typeId)}`, {credentials:'same-origin'});
      const json = await res.json();
      subSel.innerHTML = '<option value="">— wybierz —</option>';
      (json?.data || json || []).forEach(row => {
        const opt = document.createElement('option');
        opt.value = row.id;
        opt.textContent = row.name || row.nazwa || `Podtyp #${row.id}`;
        if (preselect && String(preselect) === String(row.id)) opt.selected = true;
        subSel.appendChild(opt);
      });
      subSel.disabled = false;
    } catch(e) {
      console.warn('[QUICK] Nie udało się pobrać podtypów:', e);
      subSel.innerHTML = '<option value="">— błąd pobierania —</option>';
      subSel.disabled = true;
    }
  };

  typeSel?.addEventListener('change', () => {
    localStorage.setItem('quick.type_id', typeSel.value || '');
    loadSubtypes(typeSel.value);
  });

  // 2) Drzewo – otwarcie istniejącego modala i przechwycenie wyboru
  document.addEventListener('click', (e) => {
    const btn = e.target.closest('.js-light-open-tree');
    if (!btn) return;
    // Jeżeli masz helper openModal('modal-struktury'), użyj go:
    if (typeof window.openModal === 'function') window.openModal('modal-struktury');
    // Fallback: link do Twojej strony drzewa
    // else location.href = '/modules/cmms/struktura/drzewo.php?pick=1';
  });

  // Standard zdarzenia – spróbujmy obsłużyć oba warianty
  window.onStructureSelected = (id, name) => {
    sid.value = id;
    label.textContent = name || (`Wybrano #${id}`);
    localStorage.setItem('quick.structure_id', String(id));
  };
  document.addEventListener('cmms:structure:selected', (e) => {
    const {id, label: lbl} = e.detail || {};
    if (!id) return;
    window.onStructureSelected(id, lbl);
    if (typeof window.closeModal === 'function') window.closeModal('modal-struktury');
  });

  // 3) Przywróć ostatnie wybory (opcjonalnie)
  const lastType = localStorage.getItem('quick.type_id');
  if (lastType && typeSel) {
    typeSel.value = lastType;
    loadSubtypes(lastType, localStorage.getItem('quick.subtype_id'));
  }
  subSel?.addEventListener('change', () => {
    localStorage.setItem('quick.subtype_id', subSel.value || '');
  });
  const lastStruct = localStorage.getItem('quick.structure_id');
  if (lastStruct && sid) {
    sid.value = lastStruct;
    label.textContent = `Wybrano #${lastStruct}`;
  }
})();
