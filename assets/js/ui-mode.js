// /assets/js/ui-mode.js
(() => {
    const path = location.pathname;
  if (/^\/(login\.php|logout\.php|assets\/|api\/)/.test(path)) return;

  const isCmmsLightView = /^\/modules\/cmms\/zgloszenia\/show_light\.php$/i.test(path);
  if (isCmmsLightView) {
    console.debug('[ui-mode] allow show_light.php, no redirect');
    return;
  }

  const COOKIE = 'ui_mode';
  if (document.cookie.includes(`${COOKIE}=`)) {
    console.debug('[ui-mode] cookie present, doing nothing');
    return;
  }
  const setGlobal = (val) => {
    clearAll();
    document.cookie = `${COOKIE}=${val}; Max-Age=${60*60*24*180}; Path=/; SameSite=Lax`;
  };

  // ⬇️ 2) Cookie? To nic nie rób (ale CMMS-light już przepuściliśmy wyżej)
  if (document.cookie.includes(`${COOKIE}=`)) return;

  const isMobile = () =>
    (navigator.userAgentData && navigator.userAgentData.mobile) ||
    matchMedia('(pointer:coarse)').matches ||
    (window.innerWidth <= 900);

  const mode = isMobile() ? 'light' : 'full';
  setGlobal(mode);

  const onLight = path.startsWith('/light/');

  if (mode === 'light' && !onLight) {
    const ret = encodeURIComponent(path + location.search);
    location.replace(`/light/index.php?return=${ret}`);
  } else if (mode === 'full' && onLight) {
    location.replace('/dashboard.php');
  }
})();
