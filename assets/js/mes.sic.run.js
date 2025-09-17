(() => {
  const root = document.querySelector('main.page');
  if (!root) return;

  const runId = Number(root.getAttribute('data-run-id'));
  const intervalMin = Number(root.getAttribute('data-interval-min'));
  if (!runId || !intervalMin) return;

  const chan = new BroadcastChannel(`sic-run-${runId}`);
  const KEY = `sic:lastTick:${runId}`;

  let leader = false;
  let lastTick = Number(localStorage.getItem(KEY) || '0');

  // Lider karty, by nie dublować popupów
  chan.onmessage = (e) => {
    if (e.data === 'who') chan.postMessage(leader ? 'me' : 'not-me');
    if (e.data === 'me') leader = false;
    if (e.data === 'refresh') refresh();
  };
  chan.postMessage('who');
  setTimeout(() => { if (leader === false) leader = true; }, 300);

  // Modal open/close
  function openModal() {
    document.getElementById('sic-modal')?.classList.add('open');
    document.getElementById('sic-input-ok')?.focus();
  }
  document.querySelectorAll('.modal-close').forEach(btn => {
    btn.addEventListener('click', () => btn.closest('.modal')?.classList.remove('open'));
  });

  // Przełączanie trybu formularza
  function updateMode() {
    const mode = document.querySelector('input[name="mode"]:checked')?.value;
    document.querySelector('[data-mode="production"]')?.classList.toggle('hidden', mode !== 'production');
    document.querySelector('[data-mode="activity"]')?.classList.toggle('hidden', mode !== 'activity');
  }
  document.querySelectorAll('input[name="mode"]').forEach(r => r.addEventListener('change', updateMode));
  updateMode();

  // Harmonogram popupu
  function msUntilNext() {
    const period = intervalMin * 60 * 1000;
    if (!lastTick) return 0; // pierwszy wpis: pokaż od razu
    return Math.max(0, lastTick + period - Date.now());
  }
  function schedule() {
    if (!leader) return;
    setTimeout(showIfDue, msUntilNext() + 50);
  }
  function showIfDue() {
    if (!leader) return;
    if (msUntilNext() === 0) openModal();
    schedule();
  }

  // Submit wpisu
  const form = document.getElementById('sic-form');
  form?.addEventListener('submit', async (e) => {
    e.preventDefault();
    const res = await fetch(form.action, {
      method:'POST',
      body:new FormData(form),
      credentials:'same-origin'
    });
    if (!res.ok) { alert('Błąd zapisu'); return; }
    const json = await res.json();
    if (json.status === 'ok') {
      lastTick = json.serverTs ? new Date(json.serverTs).getTime() : Date.now();
      localStorage.setItem(KEY, String(lastTick));
      document.getElementById('sic-modal')?.classList.remove('open');
      chan.postMessage('refresh');
    }
  });

  // Odśwież tablicę i KPI
  async function refresh() {
    const r = await fetch(`api/get_dashboard.php?run_id=${runId}`, { credentials:'same-origin' });
    if (!r.ok) return;
    const data = await r.json();

    // KPI
    const kpiCum = document.getElementById('kpi-cum');
    const kpiPerf = document.getElementById('kpi-perf');
    if (kpiCum) kpiCum.textContent = `${data.kpi?.cum_ok ?? 0} / ${data.kpi?.target_cum ?? '—'}`;
    if (kpiPerf) kpiPerf.textContent = (data.kpi?.performance_pct ?? null) !== null ? `${data.kpi.performance_pct}%` : '—';

    // Tabela
    const wrap = document.getElementById('sic-table');
    if (wrap) {
      const rows = (data.entries||[]).map(e => {
        const t = new Date(e.ts.replace(' ','T'));
        const hh = String(t.getHours()).padStart(2,'0');
        const mm = String(t.getMinutes()).padStart(2,'0');
        const mode = e.mode === 'production' ? 'P' : 'A';
        const qty = e.mode === 'production' ? `${e.qty_ok ?? 0} (+${e.qty_scrap ?? 0})` : '—';
        return `<tr>
          <td>${hh}:${mm}</td>
          <td>${mode}</td>
          <td>${qty}</td>
          <td><span class="badge sic-${e.status_kolor}">${e.status_kolor}</span></td>
        </tr>`;
      }).join('');
      wrap.innerHTML = `
        <table class="table">
          <thead><tr><th>TS</th><th>Mode</th><th>Qty</th><th>Status</th></tr></thead>
          <tbody>${rows}</tbody>
        </table>`;
    }
  }

  document.addEventListener('visibilitychange', () => {
    if (!document.hidden && leader && msUntilNext() === 0) openModal();
  });

  refresh();
  schedule();
})();
