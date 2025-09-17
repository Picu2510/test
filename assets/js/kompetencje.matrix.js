// assets/js/kompetencje.matrix.js
const qs  = (s, r = document) => r.querySelector(s);
const qsa = (s, r = document) => [...r.querySelectorAll(s)];
const $filters = qs('#filters');
const $table   = qs('#matrix');
const $loading = qs('#matrix-loading');
const $error   = qs('#matrix-error');
const $prev    = qs('#prev');
const $next    = qs('#next');
const $pageinfo= qs('#pageinfo');

// Bootstrap modal refs
const $modal      = qs('#rateModal');
const $rmScale    = qs('#rm-scale');
const $rmExam     = qs('#rm-exam');
const $rmExamWrap = qs('#rm-exam-wrap');
const $rmSave     = qs('#rm-save');
const $rmCancel   = qs('#rm-cancel');
const $btnClose   = $modal?.querySelector('.btn-close');
const $rmCtx      = qs('#rm-context');

const $rmHistWrap  = qs('#rm-history');
const $rmHistList  = qs('#rm-history-list');
const $rmHistRef   = qs('#rm-history-refresh');

const bs = window.bootstrap || {};
let modalInstance = null;
let backdropEl = null;

function ensureBsInstance() {
  if (!$modal || !bs?.Modal) return null;
  if ($modal.parentNode !== document.body) document.body.appendChild($modal);
  if (!modalInstance) modalInstance = bs.Modal.getOrCreateInstance($modal, { backdrop: 'static', keyboard: true });
  return modalInstance;
}

const modalCtl = {
  show() {
    if ($modal.parentNode !== document.body) document.body.appendChild($modal);
    const inst = ensureBsInstance();
    if (inst) { inst.show(); return; }
    $modal.classList.add('show', 'fallback-open');
    $modal.removeAttribute('aria-hidden');
    $modal.setAttribute('role','dialog');
    $modal.setAttribute('aria-modal','true');
    document.body.classList.add('modal-open');
    if (!backdropEl) {
      backdropEl = document.createElement('div');
      backdropEl.className = 'modal-backdrop fade show';
      document.body.appendChild(backdropEl);
    }
  },
  hide() {
    if (document.activeElement && $modal.contains(document.activeElement)) {
      document.activeElement.blur();
    }
    const inst = ensureBsInstance();
    if (inst) { inst.hide(); return; }
    $modal.classList.remove('show', 'fallback-open');
    $modal.setAttribute('aria-hidden','true');
    document.body.classList.remove('modal-open');
    if (backdropEl) { backdropEl.remove(); backdropEl = null; }
  },
  isOpen() {
    const inst = ensureBsInstance();
    if (inst) return $modal.classList.contains('show');
    return $modal.classList.contains('show');
  }
};

let state = { page: 1, per_page: 50, typ: 'all', q: '' };
let cols = [];
let rows = [];
let values = {};
let recs = {}; // user_id -> znormalizowana rekomendacja
let abortCtrl = null;
let saveQueue = [];
let saveTimer = null;
let ctx = null; // {userId, compId, typ, raterLevel}

function getCsrf() {
  const m = qs('meta[name="csrf"]'); if (m) return m.content;
  const match = document.cookie.match(/(?:^|;\s*)csrf_token=([^;]+)/i);
  return match ? decodeURIComponent(match[1]) : '';
}
function params(obj) {
  const p = new URLSearchParams();
  Object.entries(obj).forEach(([k,v]) => (v!=null && v!=='') && p.append(k, String(v)));
  return p.toString();
}
function setLoading(on) {
  $loading.hidden = !on;
  $table.classList.toggle('is-loading', !!on);
}
function showError(msg) {
  $error.textContent = msg || 'Nieznany błąd';
  $error.hidden = false;
}
function clearError() { $error.hidden = true; $error.textContent = ''; }

function vKeyFor(colOrTyp, id) {
  if (typeof colOrTyp === 'object') return `${colOrTyp.typ}:${colOrTyp.id}`;
  return `${colOrTyp}:${id}`;
}
function normalizeValues(raw) {
  const out = {};
  Object.keys(raw || {}).forEach(uid => {
    out[uid] = {};
    const row = raw[uid] || {};
    Object.keys(row).forEach(cid => {
      const v = row[cid];
      const typ = v?.typ || 'hard';
      out[uid][`${typ}:${cid}`] = v;
    });
  });
  return out;
}
function getVal(uid, col) {
  return values?.[uid]?.[vKeyFor(col)] ?? null;
}
function labelForScale(col, symbol) {
  if (!symbol) return null;
  const x = (col?.skala_values || []).find(v => v.symbol === symbol);
  return x?.opis ? `${symbol} — ${x.opis}` : symbol;
}


function toast(msg, type='success') {
  const t = document.createElement('div');
  t.textContent = msg;
  t.style.position = 'fixed';
  t.style.top = '16px';
  t.style.right = '16px';
  t.style.zIndex = '2000';
  t.style.padding = '10px 14px';
  t.style.borderRadius = '8px';
  t.style.color = '#fff';
  t.style.background = type === 'success' ? '#198754' : '#dc3545';
  document.body.appendChild(t);
  setTimeout(() => t.remove(), 2400);
}

// === PATCH fetchMatrix (robust error handling) ===
async function fetchMatrix() {
  abortCtrl?.abort();
  abortCtrl = new AbortController();
  setLoading(true); clearError();

  const url = `/modules/kompetencje/api/matrix_fetch.php?${params({...state, reco: 1, debug: 1})}`;
  try {
    const res  = await fetch(url, { signal: abortCtrl.signal, credentials: 'same-origin' });
    const text = await res.text();

    // spróbuj zparsować JSON nawet gdy HTTP != 200
    let json = null;
    try { json = JSON.parse(text); } catch {}

    if (!res.ok || !json || json.ok !== true) {
      const msg = (json && json.error) ? json.error : `HTTP ${res.status}`;
      console.error('matrix_fetch error', { url, status: res.status, body: text });
      showError(msg);
      // wyczyść UI aby nie sugerował powodzenia
      $table.innerHTML = '';
      renderPager({page: 1, per_page: state.per_page, total: 0});
      setLoading(false);
      return;
    }

    // sukces
    cols   = json.columns || [];
    rows   = json.rows || [];
    //values = json.values || {};
    values = normalizeValues(json.values || {});
	recs   = {};

    // jeśli backend dodał rekomendacje do wierszy, użyj ich od razu
    rows.forEach(r => { if (r && r.id && r.reco) recs[Number(r.id)] = normalizeReco(r.reco); });

    renderTable();
    renderPager(json.paging);

    // fallback – tylko jeśli nie dostaliśmy reco w rows
    if (!Object.keys(recs).length) {
      const uids = rows.map(r => Number(r.id)).filter(Boolean);
      if (uids.length) await loadRecommendations(uids);
    } else {
      applyRecsToTable();
    }

  } catch (e) {
    if (e.name !== 'AbortError') {
      console.error('matrix_fetch exception', e);
      showError(e.message || 'Błąd pobierania');
      $table.innerHTML = '';
      renderPager({page: 1, per_page: state.per_page, total: 0});
    }
  } finally {
    setLoading(false);
  }
}


async function loadRecommendations(uids) {
  try {
    const url = `/modules/kompetencje/api/rekomendacje_fetch.php?user_ids=${uids.join(',')}`;
    const res = await fetch(url, { credentials: 'same-origin' });
    const json = await res.json();
    if (!res.ok || !json.ok) throw new Error(json.error || `HTTP ${res.status}`);
    const raw = json.data || {};
    // znormalizuj kształt
    recs = {};
    Object.keys(raw).forEach(k => { recs[Number(k)] = normalizeReco(raw[k]); });
    applyRecsToTable();
  } catch (e) {
    console.warn('Rekomendacje (fallback) niedostępne:', e?.message || e);
  }
}

function normalizeReco(r) {
  // Obsłuż oba formaty: (A) wbudowany z matrix_fetch (stanowisko_nazwa/stopien/score/inside)
  // oraz (B) ewentualny zewnętrzny (stanowisko/poziom_*/punkty/match).
  const stanowisko = r.stanowisko_nazwa ?? r.stanowisko ?? '';
  const poziom     = r.stopien ?? r.poziom_nazwa ?? r.poziom_kod ?? '';
  const score      = (r.score != null) ? r.score : (r.punkty != null ? r.punkty : null);
  let match = r.match;
  if (!match && (r.prog_min != null && r.prog_max != null && score != null)) {
    match = (score < r.prog_min) ? 'below' : (score > r.prog_max ? 'above' : 'in_range');
  } else if (!match && r.inside != null) {
    match = r.inside ? 'in_range' : 'unknown';
  }
  return {
    stanowisko,
    poziom_nazwa: poziom || null,
    punkty: score,
    pensja_min: r.pensja_min ?? null,
    pensja_max: r.pensja_max ?? null,
    waluta: r.waluta ?? 'PLN',
    match
  };
}

function renderPager(p) {
  const total = p?.total ?? 0, page = p?.page ?? 1, per = p?.per_page ?? state.per_page;
  const pages = Math.max(1, Math.ceil(total / per));
  state.page = page; state.per_page = per;
  $pageinfo.textContent = `Strona ${page} z ${pages} • ${total} osób`;
  $prev.disabled = page <= 1;
  $next.disabled = page >= pages;
  $prev.onclick = () => { state.page = Math.max(1, page-1); fetchMatrix(); };
  $next.onclick = () => { state.page = Math.min(pages, page+1); fetchMatrix(); };
}

function findCol(compId, typ) {
  return cols.find(c => c.id === compId && c.typ === typ);
}
function findSymbolByValue(col, wartosc_num) {
  const v = (col?.skala_values || []).find(x => Number(x.wartosc_num) === Number(wartosc_num));
  return v?.symbol || null;
}

function renderRecCell(uid) {
  const r = recs[uid];
  if (!r) return `<span class="text-muted">—</span>`;
  const pay = (r.pensja_min != null || r.pensja_max != null)
    ? `${r.pensja_min != null ? formatMoney(r.pensja_min) : '—'}–${r.pensja_max != null ? formatMoney(r.pensja_max) : '—'}`
    : '—';
  const tip = [
    `Poziom: ${r.stopien ?? r.poziom_nazwa ?? r.poziom_kod ?? ''}`,
    `Próg: ${Number(r.prog_min).toFixed(2)} – ${Number(r.prog_max).toFixed(2)}`,
    `Pensja: ${pay} ${r.waluta || 'PLN'}`
  ].join('\n');

  const matchBadge = r.inside ? '' : ' <span class="badge bg-warning text-dark">poza widełkami</span>';
  return `
    <div class="text-nowrap" data-bs-toggle="tooltip" data-bs-placement="top" title="${escapeHtml(tip)}">
      <strong>${escapeHtml(r.stanowisko_nazwa || r.stanowisko || '—')}</strong>
      ${r.stopien ? ` <span class="badge bg-secondary">${escapeHtml(String(r.stopien))}</span>` : ''}
      ${matchBadge}
      <div class="small text-muted">${Math.round(r.score)} pkt • ${pay}</div>
    </div>
  `;
}


function formatMoney(x) {
  try { return new Intl.NumberFormat('pl-PL', { style:'currency', currency:'PLN', maximumFractionDigits:0 }).format(x); }
  catch { return `${x} PLN`; }
}

function renderCellContent(r, c) {
  //const v = (values[r.id] && values[r.id][c.id]) || null;
  const v = getVal(r.id, c);
  const can = !!r.can_edit;
  const label = (() => {
    if (!v) return '—';
    if (c.typ === 'soft') return v.symbol || '—';
    const sym = findSymbolByValue(c, v.wartosc_num);
    return sym || (v.wartosc_num ?? '—');
  })();

  const badge = (c.typ === 'hard' && v?.is_exam) ? ' <span class="badge bg-info ms-1">Egz</span>' : '';
  const norm = (v && typeof v.norm === 'number') ? Math.max(0, Math.min(1, v.norm)) * 100 : null;

  if (!can) {
    return `
      <div>
        <div><strong>${escapeHtml(String(label))}</strong>${badge}</div>
        ${norm !== null ? `<div class="progress mt-1" role="progressbar" aria-valuenow="${norm}" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar" style="width:${norm}%"></div></div>` : ''}
      </div>`;
  }

	return `
	  <div>
		<button
		  class="btn btn-outline-secondary btn-sm cell-edit"
		  data-user="${Number(r.id)}"
		  data-comp="${Number(c.id)}"
		  data-typ="${c.typ}">
		  ${escapeHtml(String(label))}
		</button>${badge}
		${norm !== null ? `<div class="progress mt-1" role="progressbar" aria-valuenow="${norm}" aria-valuemin="0" aria-valuemax="100"><div class="progress-bar" style="width:${norm}%"></div></div>` : ''}
	  </div>`;
}

function renderTable() {
  const thead = [];
  thead.push('<thead><tr>');
  thead.push('<th class="text-nowrap">Pracownik</th>');
  thead.push('<th class="text-nowrap">Rekomendacja</th>');
  cols.forEach(c => thead.push(`<th data-col="${c.id}" data-typ="${c.typ}">${escapeHtml(c.nazwa)}<br><small>${c.typ.toUpperCase()}</small></th>`));
  thead.push('</tr></thead>');

  const tbody = [];
  tbody.push('<tbody>');
  rows.forEach(r => {
    const full = `${r.nazwisko ?? ''} ${r.imie ?? ''}`.trim() || (r.email ?? '');
    const canEditClass = r.can_edit ? '' : ' class="table-secondary"';
    tbody.push(`<tr data-user="${r.id}" data-depth="${r.depth_level}"${canEditClass}>`);
    tbody.push(`<td class="text-nowrap"><div><strong>${escapeHtml(full)}</strong><div class="text-muted small">${escapeHtml(r.email || '')}</div>${r.can_edit?'':'<div class="badge bg-secondary mt-1">podgląd</div>'}</div></td>`);
    // Rekomendacja – jeśli mamy już znormalizowaną recs, pokaż od razu; jeśli nie, placeholder
    const initialRec = recs[Number(r.id)] ? renderRecCell(Number(r.id)) : `<span class="text-muted">—</span>`;
    tbody.push(`<td class="text-nowrap" data-rec="${r.id}">${initialRec}</td>`);
    cols.forEach(c => {
      tbody.push('<td>');
      tbody.push(renderCellContent(r, c));
      tbody.push('</td>');
    });
    tbody.push('</tr>');
  });
  tbody.push('</tbody>');

  $table.innerHTML = thead.join('') + tbody.join('');
  qsa('.cell-edit', $table).forEach(el => el.addEventListener('click', openModal));
  
  if (window.bootstrap?.Tooltip) {
  [...document.querySelectorAll('[data-bs-toggle="tooltip"]')].forEach(el => {
    new window.bootstrap.Tooltip(el);
  });
}
}

function applyRecsToTable() {
  Object.keys(recs).forEach(k => {
    const uid = Number(k);
    const cell = $table.querySelector(`td[data-rec="${uid}"]`);
    if (cell) cell.innerHTML = renderRecCell(uid);
  });
}

function openModal(e) {
  const btn = e.currentTarget.closest('button.cell-edit');
  if (!btn) return;

  const userId = Number(btn.dataset.user);
  const compId = Number(btn.dataset.comp);
  let typ = String(btn.dataset.typ || '').toLowerCase();

  // awaryjnie – jeśli z jakiegoś powodu dataset nie zawiera typ
  if (typ !== 'soft' && typ !== 'hard') {
    typ = (cols.find(x => x.id === compId && x.typ === 'soft')) ? 'soft' : 'hard';
  }

  // znajdź kolumnę i wiersz
  const col = cols.find(x => x.id === compId && x.typ === typ);
  const row = rows.find(rr => Number(rr.id) === userId);
  if (!col || !row) {
    console.warn('openModal: missing col/row', { userId, compId, typ, col, row });
    return;
  }

  // poziom oceniającego z wiersza
  const tr = btn.closest('tr');
  const depth = Number(tr?.dataset.depth || 1);
  const raterLevel = (depth === 1 || depth === 2) ? depth : 1;

  ctx = { userId, compId, typ, raterLevel };

  // nagłówek modala
  const fullName = `${row?.nazwisko ?? ''} ${row?.imie ?? ''}`.trim() || (row?.email ?? '');
  if ($rmCtx) {
    $rmCtx.textContent = `${fullName} • ${col?.nazwa ?? ''} (${typ === 'hard' ? 'twarda' : 'miękka'})`;
  }

  // skala
  const opts = (col?.skala_values || []).map(v => {
    const text = v.opis ? `${v.symbol} — ${v.opis}` : String(v.symbol);
    return `<option value="${v.id}">${text}</option>`;
  }).join('');
  $rmScale.innerHTML = `<option value="">— wybierz —</option>` + opts;

  // aktualna wartość z macierzy
  const v = getVal(userId, col); // UPEWNIJ się, że masz helper getVal z wcześniejszego patcha
  $rmScale.value = v?.skala_wartosc_id ? String(v.skala_wartosc_id) : '';

  // egzamin tylko dla twardych
  const isHard = (typ === 'hard');
  $rmExamWrap.style.display = isHard ? '' : 'none';
  $rmExam.checked = isHard && !!(v?.is_exam);

  // pokaż modal
  modalCtl.show();

  // i ściągnij historię (z logiem)
  loadHistory(userId, compId, typ, col).catch(console.error);
}


// submit w modalu
qs('#rateForm')?.addEventListener('submit', (e) => {
  e.preventDefault();
  if (!ctx) return;
  if (!$rmScale.value) { qs('#rateForm')?.classList.add('was-validated'); return; }

  const payload = {
    pracownik_id: ctx.userId,
    kompetencja_id: ctx.compId,
    typ: ctx.typ,
    rater_level: ctx.raterLevel,
    skala_wartosc_id: Number($rmScale.value)
  };
  if (ctx.typ === 'hard') payload.is_exam = $rmExam?.checked ? 1 : 0;

  saveQueue.push(payload);
  scheduleSave();
  modalCtl.hide();
  ctx = null;
});

// Anuluj / X / ESC
$rmCancel?.addEventListener('click', (e) => { e.preventDefault(); modalCtl.hide(); ctx = null; });
$btnClose?.addEventListener('click', (e) => { e.preventDefault(); modalCtl.hide(); ctx = null; });
window.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && modalCtl.isOpen()) { e.preventDefault(); modalCtl.hide(); ctx = null; }
});

function scheduleSave() {
  if (saveTimer) clearTimeout(saveTimer);
  saveTimer = setTimeout(flushSaves, 200);
}

async function flushSaves() {
  if (!saveQueue.length) return;
  const chunk = saveQueue.splice(0, saveQueue.length);
  clearError();

  const csrf = getCsrf();
  try {
    const res = await fetch('/modules/kompetencje/api/matrix_save.php', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF': csrf,
        'X-CSRF-Token': csrf
      },
      credentials: 'same-origin',
      body: JSON.stringify(chunk)
    });
    const txt = await res.text();
    let json = null;
    try { json = JSON.parse(txt); }
    catch {
      const m = txt.match(/\{[\s\S]*\}/);
      if (m) { try { json = JSON.parse(m[0]); } catch {} }
    }
    if (!json || json.ok !== true) {
      const errMsg = (json && json.error) ? json.error : `HTTP ${res.status}`;
      toast(`Błąd zapisu: ${errMsg}`, 'error');
      showError(errMsg);
      return;
    }
    toast('Zapisano');

    // odśwież macierz (reco wierszy przyjdzie od razu w rows[].reco)
    await fetchMatrix();
  } catch (e) {
    console.error(e);
    toast('Błąd zapisu (sieć)', 'error');
    showError(e.message || 'Błąd zapisu');
  }
}

function escapeHtml(s) {
  return (s ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
}

async function loadHistory(uid, cid, typ, col) {
  if (!$rmHistList) return;
  const url = `/modules/kompetencje/api/matrix_history.php?uid=${uid}&cid=${cid}&typ=${encodeURIComponent(typ)}&limit=10`;
  console.log('loadHistory →', { uid, cid, typ, url }); // <— DOPISZ TO
  $rmHistList.innerHTML = `<div class="list-group-item text-muted">Ładowanie…</div>`;
  try {
    const res = await fetch(url, { credentials: 'same-origin' });
    const txt = await res.text();
    let json = null; try { json = JSON.parse(txt); } catch {}
    if (!res.ok || !json || json.ok !== true) {
      const msg = (json && json.error) ? json.error : `HTTP ${res.status}`;
      $rmHistList.innerHTML = `<div class="list-group-item text-danger">${escapeHtml(msg)}</div>`;
      return;
    }
    renderHistory(json.items || [], col, typ);
  } catch (e) {
    $rmHistList.innerHTML = `<div class="list-group-item text-danger">${escapeHtml(e.message || 'Błąd')}</div>`;
  }
}


function renderHistory(items, col, typ) {
  if (!items.length) {
    $rmHistList.innerHTML = `<div class="list-group-item text-muted">Brak danych</div>`;
    return;
  }
  const rows = items.map(it => {
    const dt = it.data_oceny || '';
    const sym = it.symbol || (typeof it.wartosc_num === 'number' ? String(it.wartosc_num) : '—');
    const pretty = labelForScale(col, sym) || sym;
    const exam = (typ === 'hard' && Number(it.is_exam) === 1)
      ? `<span class="badge bg-info text-dark ms-1">Egz</span>` : '';
    const lvl = it.rater_level ? `<span class="badge bg-secondary ms-1">${escapeHtml(String(it.rater_level))}</span>` : '';
    return `
      <div class="list-group-item d-flex justify-content-between align-items-center">
        <div class="text-muted">${escapeHtml(dt)} ${lvl}</div>
        <div><strong>${escapeHtml(pretty)}</strong>${exam}</div>
      </div>`;
  }).join('');
  $rmHistList.innerHTML = rows;
}

$rmHistRef?.addEventListener('click', () => {
  if (!ctx) return;
  const col = findCol(ctx.compId, ctx.typ);
  loadHistory(ctx.userId, ctx.compId, ctx.typ, col).catch(console.error);
});


function applyFiltersFromForm() {
  const fd = new FormData($filters);
  state.q = (fd.get('q') || '').toString().trim();
  state.typ = (fd.get('typ') || 'all').toString();
  state.per_page = Number(fd.get('per_page') || 50) || 50;
  state.page = 1;
}

$filters.addEventListener('submit', (e) => {
  e.preventDefault();
  applyFiltersFromForm();
  fetchMatrix();
});
qs('#reset').addEventListener('click', () => {
  qsa('input, select', $filters).forEach(el => {
    if (el.name === 'typ') el.value = 'all';
    else if (el.name === 'per_page') el.value = '50';
    else el.value = '';
  });
  applyFiltersFromForm();
  fetchMatrix();
});

applyFiltersFromForm();
fetchMatrix();
