/* global $, window, document, localStorage */

/**
 * WYMAGANE W CSS:
 * .is-hidden { display: none; }
 */

// ===================== helpers =====================
function buildPayload($rootOl) {
  const out = [];
  (function walk($ol, parentId, depth) {
    let order = 0;
    $ol.children('li').each(function () {
      order += 1;
      // id może być w formie "ns_123" lub data-id="123"
      let id = this.id ? this.id.replace(/^ns_/, '') : ($(this).data('id') || '').toString();
      id = parseInt(id, 10);
      if (!Number.isFinite(id)) return;
      out.push({ item_id: id, parent_id: parentId, depth, sort_order: order });
      const $child = $(this).children('ol').first();
      if ($child.length) walk($child, id, depth + 1);
    });
  })($rootOl, null, 0);
  return out;
}

function liGetId(li) {
  return li.id || li.dataset.id || li.dataset.key || '';
}
function liGetChildOl(li) {
  return li.querySelector(':scope > ol') || null;
}
function ensureChildOlId(li) {
  const ol = liGetChildOl(li);
  if (!ol) return null;
  if (!ol.id) ol.id = 'children-of-' + (li.dataset.id || li.id || Math.random().toString(36).slice(2));
  return ol.id;
}
function getToggle(li) {
  return li.querySelector(':scope > .node .toggle-node');
}
function isOpenByDOM(li) {
  const ol = liGetChildOl(li);
  if (!ol) return false;
  // otwarty jeśli nie ma .is-hidden i nie ma [hidden]
  const hiddenByClass = ol.classList.contains('is-hidden');
  const hiddenByAttr  = ol.hasAttribute('hidden');
  return !(hiddenByClass || hiddenByAttr);
}
function setOlHidden(ol, hidden) {
  // preferujemy klasę, ale dokładamy fallback [hidden]
  ol.classList.toggle('is-hidden', hidden);
  if (hidden) ol.setAttribute('hidden', '');
  else ol.removeAttribute('hidden');
}
function setOpen(li, open) {
  const ol = liGetChildOl(li);
  if (!ol) return;

  // UI li
  li.classList.toggle('is-collapsed', !open);
  li.classList.toggle('is-expanded', !!open);
  setOlHidden(ol, !open);

  // UI przycisku
  const tgl = getToggle(li);
  if (tgl) {
    tgl.setAttribute('data-state', open ? 'open' : 'closed');
    tgl.setAttribute('aria-expanded', String(!!open));
    tgl.textContent = open ? '[–]' : '[+]';
  }
}
function expandAncestors(li) {
  let p = li.parentElement;
  while (p && p.id !== 'drzewo-sortowalne') {
    if (p.tagName === 'OL') {
      setOlHidden(p, false);
    }
    if (p.tagName === 'LI') {
      p.classList.remove('is-collapsed');
      p.classList.add('is-expanded');
      const tgl = getToggle(p);
      if (tgl) {
        tgl.setAttribute('data-state','open');
        tgl.setAttribute('aria-expanded','true');
        tgl.textContent = '[–]';
      }
    }
    p = p.parentElement;
  }
}

// zbierz ID węzłów, które są aktualnie rozwinięte (wg DOM)
function getOpenIds($wrap) {
  const ids = [];
  $wrap.find('li').each(function () {
    if (isOpenByDOM(this)) {
      const id = parseInt(this.dataset.id, 10);
      if (Number.isFinite(id)) ids.push(id);
    }
  });
  return ids;
}

// przywróć stan rozwinięcia (wspiera id="ns_123" i li[data-id="123"])
function restoreOpen($wrap, ids) {
  (ids || []).forEach(function (id) {
    const $li = $wrap.find('#ns_' + id + ', li[data-id="' + id + '"]').first();
    if (!$li.length) return;
    const li = $li.get(0);
    setOpen(li, true);
    expandAncestors(li);
  });
}

function applySearch(q) {
  const $wrap = $('#drzewo-sortowalne');
  const query = (q || '').toLowerCase().trim();
  if (!query) {
    $wrap.find('li').show();
    return;
  }

  // pokaż tylko dopasowane + przodków + potomków dopasowanych
  $wrap.find('li').each(function () {
    const $li = $(this);
    const name = $li.find('> .node .name').text().toLowerCase();
    const match = name.includes(query);

    $li.toggle(match);
    if (match) {
      // przodkowie widoczni i rozwinięci
      $li.parents('li').each(function () {
        $(this).show();
        const ol = this.querySelector(':scope > ol');
        if (ol) setOlHidden(ol, false);
        const t = getToggle(this);
        if (t) { t.setAttribute('data-state','open'); t.setAttribute('aria-expanded','true'); t.textContent = '[–]'; }
      });
      // całe poddrzewo dopasowanego też widoczne
      $li.find('li').show();
    }
  });
}

function refreshTree($wrap) {
  const url = $wrap.data('fetch-url');
  if (!url) return;

  const q = ($('#treeSearch').val() || '');

  // Ładujemy nowe drzewo; pamięcią zajmie się treeMemoryJQ (ajaxComplete)
  $wrap.load(url, function () {
    initTree();               // ponowna aktywacja DnD
    window.applyColorMode && window.applyColorMode();
    if (q) {
      $('#treeSearch').val(q);
      applySearch(q);
    }
  });
}

// ===================== DnD + zapisywanie =====================
function initTree() {
  const $wrap = $('#drzewo-sortowalne');
  const $ol   = $wrap.children('ol');

  // ARIA bootstrap dla toggli i dzieci
  $wrap.find('li').each(function () {
    const li = this;
    const t = getToggle(li);
    if (t) {
      t.setAttribute('role', 'button');
      t.setAttribute('tabindex', '0');
      const childId = ensureChildOlId(li);
      if (childId) t.setAttribute('aria-controls', childId);
      t.setAttribute('aria-expanded', String(isOpenByDOM(li)));
    }
  });

  $ol.nestedSortable({
    handle: '.drag-handle',
    items: 'li',
    toleranceElement: '> .node',
    placeholder: 'placeholder',
    isTree: true,
    startCollapsed: false,
    maxLevels: 20,
    helper: 'clone',
    forcePlaceholderSize: true,
    opacity: 0.8,

    stop: function () {
      const payload = buildPayload($ol);
      const saveUrl = $wrap.data('save-url');
      if (!saveUrl) return;

      $.ajax({
        url: saveUrl,
        method: 'POST',
        dataType: 'json',
        data: { struktura: JSON.stringify(payload) }
      }).done(function (resp) {
        if (resp && resp.status === 'success') {
          refreshTree($wrap); // po zapisie przeładuj drzewo
        } else {
          window.alert((resp && resp.message) || 'Błąd zapisu struktury');
        }
      }).fail(function (xhr) {
        console.error('AJAX save failed', xhr.status, xhr.responseText);
        window.alert('Błąd komunikacji z serwerem podczas zapisu.');
      });
    }
  });
}

// ===================== Lazy-load dzieci przy rozwijaniu =====================
$(document).on('click', '#drzewo-sortowalne .toggle-node', function (e) {
  e.preventDefault();
  e.stopPropagation();

  const $li = $(this).closest('li');
  const li = $li.get(0);
  const $kids = $li.children('ol').first();

  // jeśli to lazy placeholder – dociągnij dzieci
  if ($kids.hasClass('lazy') && $kids.data('loaded') !== 1) {
    const parentId = parseInt($li.data('id'), 10);
    const url = 'ajax/pobierz_dzieci.php?parent_id=' + parentId
              + '&aktywny=' + encodeURIComponent(($('select[name=aktywny]').val() || ''));
    $kids.load(url, function () {
      $kids.data('loaded', 1);
      setOlHidden($kids.get(0), false);
      setOpen(li, true);
      // po dociągnięciu zapamiętaj nowy stan i ewentualnie odtwórz (gdy pamięć wskazuje na więcej gałęzi)
      setTimeout(() => { if (window.restoreTreeExpansion) window.restoreTreeExpansion(); }, 0);
    });
    this.setAttribute('data-state','open');
    this.setAttribute('aria-expanded','true');
    this.textContent = '[–]';
    return;
  }

  // zwykłe zwijanie/rozwijanie
  const open = !isOpenByDOM(li);
  setOpen(li, open);
});

// ===================== Klawiatura dla toggle (Enter/Space) =====================
$(document).on('keydown', '#drzewo-sortowalne .toggle-node', function (e) {
  const key = e.key || e.code;
  if (key === 'Enter' || key === ' ' || key === 'Spacebar') {
    e.preventDefault();
    $(this).trigger('click');
  }
});

// ===================== Szukajka (debounce) =====================
let __searchT = null;
$(document).on('input', '#treeSearch', function () {
  clearTimeout(__searchT);
  const v = this.value;
  __searchT = setTimeout(() => applySearch(v), 120);
});

// ===================== Rozwiń / Zwiń wszystko =====================
$(document).on('click', '#expandAll', function () {
  const tree = document.getElementById('drzewo-sortowalne');
  tree.querySelectorAll('li').forEach(li => setOpen(li, true));
});
$(document).on('click', '#collapseAll', function () {
  const tree = document.getElementById('drzewo-sortowalne');
  tree.querySelectorAll('li').forEach(li => setOpen(li, false));
});

// ===================== Kolorowanie – global, by wywołać po refreshu =====================
window.applyColorMode = function (mode) {
  const $wrap = $('#drzewo-sortowalne'); const $mode = $('#colorMode');
  const m = mode || localStorage.getItem('tree.colorMode') || ($mode.val() || 'none');
  $wrap.removeClass('by-none by-typ by-mpk by-element').addClass('by-' + m);
  if ($mode.length) $mode.val(m);
};

function setCollapsedInitial() {
  const tree = document.getElementById('drzewo-sortowalne');
  tree.querySelectorAll('li').forEach(li => setOpen(li, false));
}

// ===================== Start – tylko przy pierwszym załadowaniu strony =====================
$(function () {
  initTree();
  setCollapsedInitial();          // na starcie domyślnie zwinięte
  window.applyColorMode();

  $(document).on('change', '#colorMode', function () {
    const m = $(this).val();
    localStorage.setItem('tree.colorMode', m);
    window.applyColorMode(m);
  });

  // natychmiastowe odtworzenie stanu po Twojej inicjalizacji
  if (window.restoreTreeExpansion) {
    window.restoreTreeExpansion();
  }
});

// ===================== PAMIĘĆ ROZWINIĘCIA DRZEWA (jQuery wersja) =====================
(function treeMemoryJQ(){
  const tree = document.getElementById('drzewo-sortowalne');
  if (!tree) return;

  // unikalny klucz pamięci (np. zależny od filtra) – możesz dodać data-tree-key w HTML
  const KEY = tree.dataset.treeKey || 'structTree.v1';
  const SCROLL_KEY = KEY + ':scroll';
  const getId = (li) => liGetId(li);

  // sprawdź/ustaw rozwinięcie (obsługa klas/hidden)
  const isOpen = (li) => isOpenByDOM(li);

  // storage helpers
  const loadSet = () => {
    try { return new Set(JSON.parse(localStorage.getItem(KEY) || '[]')); }
    catch { return new Set(); }
  };
  const saveSet = (set) => localStorage.setItem(KEY, JSON.stringify(Array.from(set)));
  const collect = () => {
    const s = new Set();
    tree.querySelectorAll('li').forEach(li => { if (isOpen(li)) { const id = getId(li); if (id) s.add(id); } });
    return s;
  };

  // przywracanie po podmianie DOM / starcie
  const restore = () => {
    const stored = loadSet();
    if (stored.size) {
      // zwinąć deterministycznie
      tree.querySelectorAll('li').forEach(li => setOpen(li, false));
      // rozwinąć zapamiętane
      stored.forEach(id => {
        const sel = `li#${CSS.escape(id)}, li[data-id="${CSS.escape(id)}"], li[data-key="${CSS.escape(id)}"]`;
        const li = tree.querySelector(sel);
        if (!li) return;
        setOpen(li, true);
        expandAncestors(li);
      });
    }
    // przywróć scroll
    const y = parseInt(localStorage.getItem(SCROLL_KEY) || '0', 10);
    if (y > 0) $('#drzewo-sortowalne').scrollTop(y);
  };

  // 1) Kliknięcia w togglery oraz expand/collapse all -> zapisz stan
  document.addEventListener('click', (e) => {
    const t = e.target;
    if (t.closest('.toggle-node') || t.id === 'expandAll' || t.id === 'collapseAll') {
      setTimeout(() => saveSet(collect()), 0);
    }
  });

  // 2) Zapisz stan PRZED zapisem drzewa (jQuery AJAX)
  if (window.jQuery) {
    jQuery(document).on('ajaxSend', function(_e, _xhr, settings){
      if (!settings || !settings.url) return;
      if (settings.url.indexOf('zapisz_drzewo.php') !== -1) {
        // zapisz rozwinięcia + scroll
        saveSet(collect());
        localStorage.setItem(SCROLL_KEY, String($('#drzewo-sortowalne').scrollTop()));
      }
    });

    // 3) Przywróć stan PO podmianie drzewa (po pobraniu nowego HTML)
    jQuery(document).on('ajaxComplete', function(_e, _xhr, settings){
      if (!settings || !settings.url) return;
      if (
        settings.url.indexOf('pobierz_drzewo.php') !== -1 ||
        settings.url.indexOf('zapisz_drzewo.php') !== -1
      ) {
        // daj czas na .html(...) i ewentualną inicjalizację nestedSortable
        setTimeout(restore, 0);
        requestAnimationFrame(() => requestAnimationFrame(restore));
      }
    });
  }

  // 4) Fallback: nasłuchuj fizycznej podmiany #drzewo-sortowalne
  const mo = new MutationObserver((muts) => {
    for (const m of muts) {
      if (m.type === 'childList' && m.addedNodes.length) {
        setTimeout(restore, 0);
        requestAnimationFrame(() => requestAnimationFrame(restore));
        break;
      }
    }
  });
  mo.observe(tree, { childList: true, subtree: false });

  // 5) Zapisz przed odświeżeniem / wyjściem (na wypadek full reload)
  window.addEventListener('beforeunload', () => {
    localStorage.setItem(SCROLL_KEY, String($('#drzewo-sortowalne').scrollTop()));
    saveSet(collect());
  });

  // 6) Start + powrót z BFCache
  const tryRestore = () => { restore(); requestAnimationFrame(restore); };
  document.addEventListener('DOMContentLoaded', tryRestore);
  window.addEventListener('pageshow', (e) => { if (e.persisted) tryRestore(); });

  // hook do ręcznego wywołania po własnych initach
  window.restoreTreeExpansion = restore;
})();
