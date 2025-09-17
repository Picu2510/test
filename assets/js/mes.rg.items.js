(() => {
  const treeEl = document.getElementById('tree');
  if (!treeEl) return;

  const mode = treeEl.getAttribute('data-mode');
  const groupId = treeEl.getAttribute('data-group-id');
  const csrf = document.getElementById('csrf-token')?.value || '';

  async function fetchTree() {
    const r = await fetch('/api/structure/tree.php', { credentials:'same-origin' });
    if (!r.ok) throw new Error('tree load failed');
    const j = await r.json();
    return j.root;
  }

  function postForm(action, payload) {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = `items.php?id=${encodeURIComponent(groupId)}`;
    const act = document.createElement('input');
    act.type='hidden'; act.name='act'; act.value=action;
    form.appendChild(act);
    const csrfIn = document.createElement('input');
    csrfIn.type='hidden'; csrfIn.name='csrf'; csrfIn.value=csrf;
    form.appendChild(csrfIn);
    Object.entries(payload||{}).forEach(([k,v])=>{
      const inp = document.createElement('input');
      inp.type='hidden'; inp.name=k; inp.value=String(v);
      form.appendChild(inp);
    });
    document.body.appendChild(form);
    form.submit();
  }

  function renderNode(node) {
    const li = document.createElement('li');
    li.className = 'tree-node';

    const row = document.createElement('div');
    row.className = 'tree-row';
    const toggle = document.createElement('button');
    toggle.type='button';
    toggle.className='btn btn-sm';
    toggle.textContent = node.children && node.children.length ? '▸' : '•';
    toggle.setAttribute('aria-expanded','false');

    const title = document.createElement('span');
    title.textContent = `${node.name} (#${node.id})`;
    title.className = 'tree-title';

    row.appendChild(toggle);
    row.appendChild(title);

    const actions = document.createElement('span');
    actions.className='tree-actions';

    if (mode === 'explicit') {
      const addOne = document.createElement('button');
      addOne.type='button'; addOne.className='btn btn-sm';
      addOne.textContent='➕ dodaj';
      addOne.addEventListener('click', ()=> postForm('add_one', { struktura_id: node.id }));

      const addSub = document.createElement('button');
      addSub.type='button'; addSub.className='btn btn-sm';
      addSub.textContent='🌳 poddrzewo';
      addSub.addEventListener('click', ()=> postForm('add_subtree', { root_id: node.id }));

      actions.appendChild(addOne);
      actions.appendChild(addSub);
    } else {
      const setRoot = document.createElement('button');
      setRoot.type='button'; setRoot.className='btn btn-sm';
      setRoot.textContent='🌳 ustaw jako root';
      setRoot.addEventListener('click', ()=> postForm('set_root', { root_id: node.id }));
      actions.appendChild(setRoot);
    }
    row.appendChild(actions);
    li.appendChild(row);

    const ul = document.createElement('ul');
    ul.className='tree-children';
    ul.style.display='none';

    (node.children||[]).forEach(ch => ul.appendChild(renderNode(ch)));
    li.appendChild(ul);

    toggle.addEventListener('click', ()=>{
      const open = ul.style.display !== 'none';
      ul.style.display = open ? 'none' : 'block';
      toggle.textContent = open ? '▸' : '▾';
      toggle.setAttribute('aria-expanded', String(!open));
    });

    return li;
  }

  function renderTree(root) {
    const ul = document.createElement('ul');
    ul.className = 'tree-root';
    (root.children||[]).forEach(ch => ul.appendChild(renderNode(ch)));
    treeEl.innerHTML = '';
    treeEl.appendChild(ul);
  }

  // Podgląd subtree (prawa strona) – dociągnij nazwy przez by_ids.php
  const prevTbody = document.getElementById('subtree-preview');
  async function hydratePreview() {
    if (!prevTbody) return;
    const ids = prevTbody.getAttribute('data-ids');
    if (!ids) return;
    const r = await fetch(`/api/structure/by_ids.php?ids=${encodeURIComponent(ids)}`, { credentials:'same-origin' });
    if (!r.ok) return;
    const data = await r.json();
    prevTbody.innerHTML = data.map(row => (
      `<tr><td>${row.id}</td><td>${row.nazwa}</td></tr>`
    )).join('');
  }

  (async () => {
    try {
      const tree = await fetchTree();
      renderTree(tree);
      hydratePreview();
    } catch (e) {
      treeEl.textContent = 'Błąd wczytywania drzewa.';
    }
  })();
})();
