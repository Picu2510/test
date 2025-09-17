(function(){
  console.log('[color-sync] loaded');

  window.addEventListener('DOMContentLoaded', function () {
    console.log('[color-sync] DOM ready');

    var probe  = document.getElementById('js-probe');
    if (probe) probe.textContent = 'JS: OK';

    var color = document.getElementById('kolor_native');
    var hex   = document.getElementById('kolor_hex');

    console.log('[color-sync] elements found:', { native: !!color, hex: !!hex });
    if (!color || !hex) return;

    var RE = /^#?(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})$/;
    function expand(v){
      v = String(v || '').trim().replace('#','');
      if (v.length === 3) v = v[0]+v[0]+v[1]+v[1]+v[2]+v[2];
      return '#'+v.toUpperCase();
    }

    function syncFromColor() {
      hex.value = expand(color.value);
      hex.setCustomValidity('');
      // console.debug('[color-sync] palette ->', hex.value);
    }

    function syncFromHex() {
      var v = hex.value.trim();
      if (v.charAt(0) !== '#') v = '#'+v;
      if (RE.test(v)) {
        v = expand(v);
        hex.value   = v;
        color.value = v;
        hex.setCustomValidity('');
        // console.debug('[color-sync] text ->', v);
      } else {
        hex.setCustomValidity('Podaj kolor w formacie #RGB lub #RRGGBB');
      }
    }

    // start – normalizacja
    syncFromHex();

    // nasłuchy
    color.addEventListener('input',  syncFromColor);
    color.addEventListener('change', syncFromColor);
    hex.addEventListener('input',    syncFromHex);
    hex.addEventListener('change',   syncFromHex);
  });
})();
