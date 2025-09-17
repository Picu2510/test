// CSP-safe JS for edit_permissions
(function(){
  const $  = s => document.querySelector(s);
  const $$ = s => Array.from(document.querySelectorAll(s));
  const norm = s => (s||'').toString().trim().toLowerCase();

  // --- dane z data-* ---
  const dataEl = $('#permData');
  const ROLE_PERMS = (()=>{ try{ return JSON.parse(dataEl?.dataset.rolePerms || '{}'); }catch{ return {}; }})();
  const PRESELECTED = (()=>{ try{ return JSON.parse(dataEl?.dataset.preselectedRoles || '[]'); }catch{ return []; }})();

	const roleSelect = document.querySelector('select[name="role_id"]')
					   || document.querySelector('select[name="roles[]"]');

  const searchInput = $('#perm-search');

  const detailModules = $$('details.card[data-module]');
  const rows = () => $$('tbody tr[data-pid]');

  // --- wyszukiwarka ---
  function applySearch(){
    const needle = norm(searchInput?.value);
    detailModules.forEach(d => d.open = true);
    const visibleByModule = {};
    rows().forEach(tr=>{
      const hay = norm(tr.dataset.text);
      const show = !needle || hay.includes(needle);
      tr.hidden = !show;
      if (show) visibleByModule[tr.dataset.module] = true;
    });
    detailModules.forEach(d => { d.open = !!visibleByModule[d.dataset.module]; });
  }
  searchInput?.addEventListener('input', applySearch);

  // --- operacje na widocznych ---
  function setVisible(state){
    rows().forEach(tr=>{
      if (tr.hidden) return;
      const input = tr.querySelector(`input[type=radio][value="${state}"]`);
      if (input) input.checked = true;
    });
  }
  $('#btn-allow-visible') ?.addEventListener('click', ()=>setVisible('allow'));
  $('#btn-deny-visible')  ?.addEventListener('click', ()=>setVisible('deny'));
  $('#btn-inherit-visible')?.addEventListener('click', ()=>setVisible('inherit'));
  $('#toggle-visible')    ?.addEventListener('change', e=> setVisible(e.target.checked ? 'allow' : 'inherit'));

  // --- grupy per moduł ---
	$$('.group-allow').forEach(btn=>{
	  btn.addEventListener('click', (e)=>{
		e.preventDefault(); e.stopPropagation();
		setGroup(btn.dataset.group, 'allow');
	  });
	});
	$$('.group-deny').forEach(btn=>{
	  btn.addEventListener('click', (e)=>{
		e.preventDefault(); e.stopPropagation();
		setGroup(btn.dataset.group, 'deny');
	  });
	});
	$$('.group-inherit').forEach(btn=>{
	  btn.addEventListener('click', (e)=>{
		e.preventDefault(); e.stopPropagation();
		setGroup(btn.dataset.group, 'inherit');
	  });
	});

  function setGroup(module, state){
    $$(`tbody tr[data-module="${module}"]`).forEach(tr=>{
      if (tr.hidden) return;
      const input = tr.querySelector(`input[type=radio][value="${state}"]`);
      if (input) input.checked = true;
    });
  }

  // --- efektywne uprawnienia z ról + [AUTO-INHERIT] ---
	function getSelectedRoleIds(){
	  if (!roleSelect) return [];
	  if (roleSelect.multiple) {
		return Array.from(roleSelect.selectedOptions).map(o=>+o.value).filter(Number.isFinite);
	  }
	  const v = parseInt(roleSelect.value, 10);
	  return Number.isFinite(v) ? [v] : [];
	}

  function computeEffectiveFromRoles(roleIds){
    const allowed = new Set();
    (roleIds||[]).forEach(rid=>{
      (ROLE_PERMS[rid]||[]).forEach(pid => allowed.add(pid));
    });
    return allowed;
  }
  function updateEffectiveBadgesAndAutoInherit(){
    const allowedSet = computeEffectiveFromRoles(getSelectedRoleIds());
    rows().forEach(tr=>{
      const pid = parseInt(tr.dataset.pid,10);
      const badge = tr.querySelector('.by-role-badge');
      const checked = tr.querySelector('input[type=radio][name^="perm_override["]:checked');
      const isOverride = checked && checked.value !== 'inherit';

      if (!isOverride && allowedSet.has(pid)) {
	  badge.hidden = false;
	} else {
	  badge.hidden = true;
	}

    });
  }

  // --- init ---
  applySearch();
  updateEffectiveBadgesAndAutoInherit();
  roleSelect?.addEventListener('change', updateEffectiveBadgesAndAutoInherit);
  document.addEventListener('change', ev=>{
    if (ev.target && ev.target.matches('input[type=radio][name^="perm_override["]')) {
      updateEffectiveBadgesAndAutoInherit();
    }
  });
  
function markRow(tr, state){
  const input = tr.querySelector(`input[type=radio][value="${state}"]`);
  if (input) {
    input.checked = true;
    // opcjonalnie: powiadom innych listenerów
    input.dispatchEvent(new Event('change', {bubbles:true}));
  }
}

function setVisible(state){
  rows().forEach(tr => { if (!tr.hidden) markRow(tr, state); });
  updateEffectiveBadgesAndAutoInherit(); // <<< ważne
}

function setGroup(module, state){
  document.querySelectorAll(`tbody tr[data-module="${module}"]`)
    .forEach(tr => { if (!tr.hidden) markRow(tr, state); });
  updateEffectiveBadgesAndAutoInherit(); // <<< ważne
}

// przyciski z toolbaru
document.getElementById('btn-allow-visible')
  ?.addEventListener('click', e => { e.preventDefault(); setVisible('allow'); });
document.getElementById('btn-deny-visible')
  ?.addEventListener('click', e => { e.preventDefault(); setVisible('deny'); });
document.getElementById('btn-inherit-visible')
  ?.addEventListener('click', e => { e.preventDefault(); setVisible('inherit'); });

// przyciski grupowe (siedzą w <summary> – wyłącz przełączanie details)
document.querySelectorAll('.group-allow').forEach(btn=>{
  btn.addEventListener('click', e => { e.preventDefault(); e.stopPropagation(); setGroup(btn.dataset.group, 'allow'); });
});
document.querySelectorAll('.group-deny').forEach(btn=>{
  btn.addEventListener('click', e => { e.preventDefault(); e.stopPropagation(); setGroup(btn.dataset.group, 'deny'); });
});
document.querySelectorAll('.group-inherit').forEach(btn=>{
  btn.addEventListener('click', e => { e.preventDefault(); e.stopPropagation(); setGroup(btn.dataset.group, 'inherit'); });
});

// checkbox „Zaznacz/odznacz widoczne”
document.getElementById('toggle-visible')
  ?.addEventListener('change', e => setVisible(e.target.checked ? 'allow' : 'inherit'));

  
})();
