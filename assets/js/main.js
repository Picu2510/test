// assets/js/main.js
(function () {
  'use strict';

  const burger  = document.querySelector('[data-burger]');
  const sidebar = document.querySelector('.sidebar');

  const isMobile = () => window.matchMedia('(max-width: 768px)').matches;

  function syncLayout() {
    if (!sidebar) return;
    if (isMobile()) {
      // Na mobile nie używamy "collapsed"
      document.body.classList.remove('sidebar-collapsed');
    } else {
      // Na desktopie nie trzymamy off-canvas
      sidebar.classList.remove('is-open');
      document.body.classList.remove('no-scroll');
    }
  }

  // start
  syncLayout();

  if (burger && sidebar) {
    burger.addEventListener('click', () => {
      if (isMobile()) {
        // Tryb mobilny: off-canvas (pełna szerokość, etykiety widoczne)
        document.body.classList.remove('sidebar-collapsed');
        sidebar.classList.toggle('is-open');
        // (opcjonalnie) blokuj scroll tła gdy menu otwarte
        document.body.classList.toggle('no-scroll', sidebar.classList.contains('is-open'));
      } else {
        // Desktop: mini-sidebar (ikony)
        sidebar.classList.remove('is-open');
        document.body.classList.toggle('sidebar-collapsed');
      }
    });
  }

  // PODMENU (submenu z animacją + akordeon po atrybucie data-accordion="true")
  const toggles = Array.from(document.querySelectorAll('.menu-toggle'));
  const ACCORDION_SELECTOR = '.sidebar-nav[data-accordion="true"]';

  const keyFor = (el) => el.dataset.menuKey || (el.textContent || '').trim().toLowerCase().slice(0, 64);
  const storageGet = (k) => { try { return localStorage.getItem('submenu:' + k) === 'open'; } catch { return false; } };
  const storageSet = (k, open) => { try { open ? localStorage.setItem('submenu:' + k, 'open') : localStorage.removeItem('submenu:' + k); } catch {} };

  toggles.forEach((toggle) => {
    const parent = toggle.closest('.has-submenu');
    const submenu = parent?.querySelector('.submenu');
    if (!parent || !submenu) return;

    const k = keyFor(toggle);
    const shouldOpen = parent.classList.contains('open') || storageGet(k);
    parent.classList.toggle('open', !!shouldOpen);
    toggle.setAttribute('aria-expanded', shouldOpen ? 'true' : 'false');
    submenu.style.maxHeight = shouldOpen ? submenu.scrollHeight + 'px' : null;

    toggle.addEventListener('click', (e) => {
      e.preventDefault();
      const container = toggle.closest(ACCORDION_SELECTOR);
      const isOpen = parent.classList.contains('open');

      if (container && !isOpen) {
        container.querySelectorAll('.has-submenu.open').forEach((other) => {
          if (other === parent) return;
          const sm = other.querySelector('.submenu');
          const tg = other.querySelector('.menu-toggle');
          other.classList.remove('open');
          sm && (sm.style.maxHeight = null);
          tg && tg.setAttribute('aria-expanded', 'false');
          tg && storageSet(keyFor(tg), false);
        });
      }

      parent.classList.toggle('open');
      const nowOpen = parent.classList.contains('open');
      toggle.setAttribute('aria-expanded', nowOpen ? 'true' : 'false');
      submenu.style.maxHeight = nowOpen ? submenu.scrollHeight + 'px' : null;
      storageSet(k, nowOpen);
    });
  });

  // Re-sync po zmianie rozmiaru: czyść stany nieadekwatne do trybu
  let rAF = null;
  window.addEventListener('resize', () => {
    if (rAF) cancelAnimationFrame(rAF);
    rAF = requestAnimationFrame(() => {
      syncLayout();
      document.querySelectorAll('.has-submenu.open .submenu').forEach((sm) => {
        sm.style.maxHeight = sm.scrollHeight + 'px';
      });
    });
  });

  // Linki z data-confirm (global)
  document.addEventListener('click', (e) => {
    const a = e.target.closest('a[data-confirm]');
    if (!a) return;
    const msg = a.getAttribute('data-confirm') || 'Czy na pewno?';
    if (!confirm(msg)) e.preventDefault();
  });

  // Formularze .ajax-form (opcjonalnie)
  document.addEventListener('submit', async (e) => {
    const form = e.target.closest('form.ajax-form');
    if (!form) return;
    e.preventDefault();
    const res = await fetch(form.action, { method: form.method || 'POST', body: new FormData(form) });
    const json = await res.json().catch(() => null);
    if (json && json.ok) {
      if (json.redirect) window.location.assign(json.redirect);
      else alert(json.message || 'OK');
    } else {
      alert((json && json.error) || 'Błąd');
    }
  });
  
	  // Auto-submit języka (bez inline handlers – zgodnie z CSP)
	document.addEventListener('change', (e) => {
	  const sel = e.target.closest('.lang-switcher select');
	  if (!sel) return;
	  sel.form?.requestSubmit ? sel.form.requestSubmit() : sel.form.submit();
	});

	// Gdy JS działa – ukryj przycisk OK (progressive enhancement)
	document.addEventListener('DOMContentLoaded', () => {
	  document.querySelectorAll('.lang-switcher .lang-submit').forEach(btn => {
		btn.style.display = 'none';
	  });
	});
	
	// === Auth tabs (Hasło / PIN) ===
	document.addEventListener('click', (e) => {
		  const tab = e.target.closest('.auth-tab');
		  if (!tab) return;

		  const mode = tab.dataset.authTab; // 'password' | 'pin'
		  document.querySelectorAll('.auth-tab').forEach(t => t.classList.remove('is-active'));
		  tab.classList.add('is-active');

		  const pass = document.getElementById('auth-pass');
		  const pin  = document.getElementById('auth-pin');
		  if (mode === 'pin') {
				pass?.classList.add('is-hidden');
				pin?.classList.remove('is-hidden');
				document.querySelector('input[name="mode"][value="pin"]')?.closest('form')?.querySelector('input,select,textarea')?.focus?.();
		  } else {
				pin?.classList.add('is-hidden');
				pass?.classList.remove('is-hidden');
				document.getElementById('username')?.focus?.();
		  }
	});

	// Generator PIN bez zagnieżdżonego formularza
	document.addEventListener('click', async (e) => {
	  const btn = e.target.closest('.pin-gen-btn');
	  if (!btn) return;

	  // znajdź główny formularz i token CSRF
	  const form = btn.closest('form');
	  const tokenInput = form?.querySelector('input[name="csrf"]');
	  const token = tokenInput?.value;
	  if (!token) {
		alert('Brak CSRF tokenu. Odśwież stronę.');
		return;
	  }

	  try {
		const res = await fetch(btn.dataset.url, {
		  method: 'POST',
		  headers: { 'X-CSRF-Token': token }
		  // body niepotrzebne – endpoint czyta token z nagłówka
		});
		const data = await res.json();
		if (!data.ok) throw new Error(data.error || 'Błąd generatora PIN');

		const input = btn.closest('.pin-row')?.querySelector('input[name="pin"]');
		if (input) {
		  input.value = data.pin;
		  input.dispatchEvent(new Event('input', { bubbles: true }));
		}
	  } catch (err) {
		alert(err.message || 'Nie udało się wygenerować PIN.');
	  }
	});

	// Auto-dodawanie przełącznika "pokaż hasło" dla input[type=password]
	document.addEventListener('DOMContentLoaded', () => {
	  document.querySelectorAll('input[type="password"]:not([data-no-toggle])').forEach((inp) => {
		const wrap = inp.closest('.input-wrap') || inp.parentElement;
		if (!wrap || wrap.querySelector('.pwd-toggle')) return;
		const btn = document.createElement('button');
		btn.type = 'button';
		btn.className = 'pwd-toggle';
		btn.setAttribute('aria-label','Pokaż/ukryj hasło');
		btn.textContent = '👁';
		btn.addEventListener('click', () => {
		  const isPwd = inp.type === 'password';
		  inp.type = isPwd ? 'text' : 'password';
		  btn.textContent = isPwd ? '🙈' : '👁';
		  inp.focus();
		});
		// Umieść przy prawej krawędzi pola
		wrap.style.position = wrap.style.position || 'relative';
		wrap.appendChild(btn);
	  });
	});
	/*
	document.addEventListener('DOMContentLoaded', () => {
	  const typeEl = document.getElementById('type_id');
	  const subEl  = document.getElementById('subtype_id');
	  if (!typeEl || !subEl) return;

	  const url = typeEl.dataset.subtypesUrl;
	  const chooseLabel = subEl.querySelector('option[value=""]')?.textContent || 'Wybierz...';

	  async function loadSubtypes(typeId, preselectId = null) {
		// wyczyść
		subEl.innerHTML = '';
		const opt0 = document.createElement('option');
		opt0.value = '';
		opt0.textContent = chooseLabel;
		subEl.appendChild(opt0);

		if (!typeId) return;

		try {
		  const res = await fetch(`${url}?type_id=${encodeURIComponent(typeId)}`, {
			headers: { 'Accept': 'application/json' },
			credentials: 'same-origin'
		  });
		  if (!res.ok) return;
		  const list = await res.json();
		  list.forEach(row => {
			const opt = document.createElement('option');
			opt.value = String(row.id);
			opt.textContent = row.name;
			if (preselectId && String(preselectId) === String(row.id)) {
			  opt.selected = true;
			}
			subEl.appendChild(opt);
		  });
		} catch (e) {
		  // cicho – UI musi nadal działać
		}
	  }

	  // On change: przeładuj podtypy i wyczyść wybór
	  typeEl.addEventListener('change', () => {
		loadSubtypes(typeEl.value, null);
	  });

	  // Po załadowaniu strony: jeśli jest wybrany typ, zsynchronizuj listę podtypów.
	  const currentSubtype = subEl.dataset.current || null;
	  if (typeEl.value) {
		loadSubtypes(typeEl.value, currentSubtype);
	  }
	});
*/

const root = document.documentElement;
  const mq   = window.matchMedia('(prefers-color-scheme: dark)');
  const apply = (mode) => {
    // mode: 'dark' | 'light' | 'auto'
    const dark = mode === 'dark' || (mode === 'auto' && mq.matches);
    dark ? root.setAttribute('data-theme', 'dark')
         : root.removeAttribute('data-theme');
    localStorage.setItem('theme', mode);
  };
  apply(localStorage.getItem('theme') || 'auto');
  mq.addEventListener('change', () => apply(localStorage.getItem('theme') || 'auto'));
  document.addEventListener('click', (e) => {
    const btn = e.target.closest('[data-action="toggle-theme"]');
    if (!btn) return;
    const isDark = root.hasAttribute('data-theme');
    apply(isDark ? 'light' : 'dark');
    btn.innerHTML = isDark ? '🌙' : '☀️';
  });
})();
