(function(){
  const $ = s => document.querySelector(s);
  const $$ = s => Array.from(document.querySelectorAll(s));
  const norm = s => (s||'').toString().trim().toLowerCase();

  const q = $('#perm-search');
  const moduleDetails = $$('details.card[data-module]');
  const rows = () => $$('tbody tr[data-module]');

  function applySearch(){
    const needle = norm(q?.value);
    const visibleByModule = {};
    moduleDetails.forEach(d => d.open = true);
    rows().forEach(tr=>{
      const hay = norm(tr.dataset.text);
      const show = !needle || hay.includes(needle);
      tr.hidden = !show;
      if (show) visibleByModule[tr.dataset.module] = true;
    });
    moduleDetails.forEach(d => d.open = !!visibleByModule[d.dataset.module]);
  }
  q?.addEventListener('input', applySearch);

  // Zaznacz/odznacz moduł (przyciski w <summary>)
  document.addEventListener('click', (e) => {
  const btn = e.target.closest('.mod-check');
  if (!btn) return;

  e.preventDefault();
  e.stopPropagation();

  const mod = (btn.dataset.mod || '').toLowerCase();
  const state = btn.dataset.state; // 'all' | 'none'

  document.querySelectorAll(`tbody tr[data-module="${mod}"] input[type=checkbox]`)
    .forEach(cb => {
      if (!cb.closest('tr').hidden) cb.checked = (state === 'all');
    });
});
})();
