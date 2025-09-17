document.addEventListener('DOMContentLoaded', ()=>{
  const input = document.getElementById('photos');
  if (!input) return;
  const zone = document.createElement('div');
  zone.className = 'previews';
  input.closest('form')?.insertBefore(zone, input.closest('form').querySelector('.actions-row'));
  input.addEventListener('change', ()=>{
    zone.innerHTML = '';
    [...input.files].slice(0, 8).forEach(file=>{
      if (!file.type.startsWith('image/')) return;
      const fr = new FileReader();
      fr.onload = ()=> {
        const img = document.createElement('img');
        img.src = String(fr.result);
        img.alt = file.name;
        img.style.maxWidth = '120px';
        img.style.maxHeight = '120px';
        img.style.marginRight = '8px';
        zone.appendChild(img);
      };
      fr.readAsDataURL(file);
    });
  });
});
