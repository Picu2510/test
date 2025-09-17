// assets/js/cmms.worklog.js
(function(){
  const panel = document.getElementById('worklog-panel');
  if (!panel) return;

  const ticketId = Number(panel.dataset.ticket);
  const whoNowEl = document.getElementById('who-now');

  function getCsrf(){
    const el = document.querySelector('meta[name="csrf-token"]');
    return el ? el.getAttribute('content') : '';
  }

  async function refreshWhoNow(){
    try{
      const r = await fetch(`/modules/cmms/zgloszenia/actions/worklog_active_for_ticket.php?ticket_id=${ticketId}`, {cache:'no-store'});
      const data = await r.json();
      if (!Array.isArray(data) || data.length===0){
        whoNowEl.textContent = 'Nikt nie pracuje teraz nad zgłoszeniem.';
        return;
      }
      whoNowEl.innerHTML = data.map(x=>{
        const name = [x.imie, x.nazwisko].filter(Boolean).join(' ') || x.login || ('Użytkownik #'+x.user_id);
        const since = new Date(x.start_at);
        return `<span class="chip" title="od ${since.toLocaleString()}">${name}</span>`;
      }).join(' ');
    }catch(e){
      whoNowEl.textContent = 'Błąd odświeżania.';
    }
  }

  function bindForm(id){
    const f = document.getElementById(id);
    if(!f) return;
    f.addEventListener('submit', async (ev)=>{
      ev.preventDefault();
      const fd = new FormData(f);
      const r = await fetch(f.action, {
        method:'POST',
        headers:{'X-CSRF-Token': getCsrf(), 'Accept':'application/json'},
        body: fd
      });
      try {
        const j = await r.json();
        if (!r.ok || !j.ok) { alert(j.error || 'Nie udało się wykonać akcji.'); return; }
      } catch(_e) { alert('Nie udało się wykonać akcji.'); return; }
      refreshWhoNow();
    });
  }

  bindForm('wl-start');
  bindForm('wl-stop');
  refreshWhoNow();
  setInterval(refreshWhoNow, 15000);
})();
