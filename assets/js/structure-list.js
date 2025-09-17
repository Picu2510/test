/* assets/js/structure-list.js */
(function ($) {
  'use strict';

  // === Kolorowanie
  function applyColorMode(mode) {
    var $wrap = $('#list-wrapper');
    var $mode = $('#colorMode');
    var m = mode || localStorage.getItem('list.colorMode') || ($mode.val() || 'none');

    $wrap.removeClass('by-none by-typ by-mpk by-element').addClass('by-' + m);
    if ($mode.length) $mode.val(m);
  }

  // === Filtrowanie tabeli
  function bindSearch() {
    var $input = $('#tableSearch');
    if (!$input.length) return;

    var $rows = $('.list-table tbody tr');

    $input.on('input', function () {
      var q = (this.value || '').toLowerCase().trim();
      if (!q) {
        $rows.show();
        return;
      }
      $rows.each(function () {
        var $tr = $(this);
        // przeszukujemy wszystkie kolumny w wierszu
        var txt = $tr.find('td').text().toLowerCase();
        $tr.toggle(txt.indexOf(q) !== -1);
      });
    });
  }

  // === Init
  $(function () {
    // ustaw kolorowanie z pamięci/selektora
    applyColorMode();

    // zmiana trybu kolorowania przez użytkownika
    $(document).on('change', '#colorMode', function () {
      var m = $(this).val();
      localStorage.setItem('list.colorMode', m);
      applyColorMode(m);
    });

    // szukajka
    bindSearch();
  });

})(jQuery);
