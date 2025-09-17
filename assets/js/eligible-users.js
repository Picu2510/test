// assets/js/eligible-users.js
// Dynamiczne przeładowanie listy #assigned_user_id po zmianie Typ/Podtyp/Zasób.
// CSP-safe: brak inline. Minimalne zależności.

(function () {
  'use strict';

  function $(sel, ctx) { return (ctx || document).querySelector(sel); }
  function $all(sel, ctx) { return Array.prototype.slice.call((ctx || document).querySelectorAll(sel)); }

  function rebuildSelect(selectEl, data, keepValue) {
    if (!selectEl) return;
    const doc = document;
    const current = keepValue || selectEl.value || '';
    // Wyczyść
    while (selectEl.firstChild) selectEl.removeChild(selectEl.firstChild);

    // Placeholder
    const opt0 = doc.createElement('option');
    opt0.value = '';
    opt0.textContent = selectEl.getAttribute('data-placeholder') || '— nie przydzielaj —';
    selectEl.appendChild(opt0);

    if (!data || !Array.isArray(data.users) || data.users.length === 0) {
      return; // brak kandydatów — zostaw placeholder
    }

    // Pogrupuj wg group_label → optgroup
    const byGroup = {};
    data.users.forEach(u => {
      const gl = u.group_label || 'Grupa';
      if (!byGroup[gl]) byGroup[gl] = [];
      byGroup[gl].push(u);
    });

    Object.keys(byGroup).forEach(label => {
      const og = doc.createElement('optgroup');
      og.label = label;
      byGroup[label].forEach(u => {
        const o = doc.createElement('option');
        o.value = String(u.id);
        o.textContent = u.label || ('ID ' + u.id);
        if (String(current) === String(u.id)) o.selected = true;
        og.appendChild(o);
      });
      selectEl.appendChild(og);
    });
  }

  function makeUrl(base, params) {
    const usp = new URLSearchParams();
    Object.keys(params).forEach(k => {
      const v = params[k];
      if (v !== undefined && v !== null && v !== '') usp.set(k, String(v));
    });
    return base + (base.includes('?') ? '&' : '?') + usp.toString();
  }

  function initEligibleUsers() {
    const selAssigned = $('#assigned_user_id');
    if (!selAssigned) return; // pole niewidoczne bez uprawnienia

    const url = selAssigned.getAttribute('data-eligible-users-url');
    if (!url) return;

    const selType   = $('#type_id');
    const selSub    = $('#subtype_id');
    const inpStruct = $('#f_struct'); // hidden

    // Debounce
    let tmr = null;
    let lastPayload = null;

    function payload() {
      return {
        type_id:      (selType && selType.value) ? selType.value : '',
        subtype_id:   (selSub && selSub.value) ? selSub.value : '',
        struktura_id: (inpStruct && inpStruct.value) ? inpStruct.value : ''
      };
    }

    function samePayload(a, b) {
      if (!a || !b) return false;
      return a.type_id === b.type_id && a.subtype_id === b.subtype_id && a.struktura_id === b.struktura_id;
    }

    function refresh() {
      const p = payload();

      // Jeżeli nie wybrano podstaw (typ/zasób) — czyść do placeholdera
      //if (!p.type_id || !p.struktura_id) {
      //  rebuildSelect(selAssigned, { users: [] });
      //  lastPayload = p;
      //  return;
      //}
	if (!p.type_id) {
		rebuildSelect(selAssigned, { users: [] });
		lastPayload = p;
		return;
	}


      if (samePayload(p, lastPayload)) return; // nic się nie zmieniło od ostatniego odświeżenia
      lastPayload = p;

      const keepValue = selAssigned.value || '';
      const fullUrl = makeUrl(url, p);

      fetch(fullUrl, { credentials: 'same-origin', headers: { 'Accept': 'application/json' } })
        .then(r => r.ok ? r.json() : Promise.reject(new Error('HTTP ' + r.status)))
        .then(json => {
          if (!json || json.ok !== true) {
            rebuildSelect(selAssigned, { users: [] }, keepValue);
            return;
          }
          rebuildSelect(selAssigned, json, keepValue);
        })
        .catch(() => {
          rebuildSelect(selAssigned, { users: [] }, keepValue);
        });
    }

    function scheduleRefresh() {
      if (tmr) window.clearTimeout(tmr);
      tmr = window.setTimeout(refresh, 250);
    }

    if (selType) selType.addEventListener('change', scheduleRefresh);
    if (selSub) selSub.addEventListener('change', scheduleRefresh);

    // Hidden input nie zawsze wywoła change — spróbujmy kilku sposobów:
    if (inpStruct) {
      inpStruct.addEventListener('change', scheduleRefresh);

      // Reaguj na custom event emitowany przez picker (jeśli jest)
      window.addEventListener('cmms:structure-picked', scheduleRefresh);

      // Awaryjnie: obserwuj zmianę atrybutu value
      try {
        const mo = new MutationObserver(scheduleRefresh);
        mo.observe(inpStruct, { attributes: true, attributeFilter: ['value'] });
      } catch (e) { /* noop */ }
    }

    // Pierwsze uruchomienie (SSR -> AJAX sync)
    scheduleRefresh();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initEligibleUsers);
  } else {
    initEligibleUsers();
  }
})();
