{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load();

(async () => {
  const status = document.getElementById('offline-status');
  const show = (text) => { status.textContent = text; };
  if (!('serviceWorker' in navigator) || !window.isSecureContext) {
    show('O modo offline precisa de HTTPS ou localhost.');
    return;
  }
  try {
    const registration = await navigator.serviceWorker.register(
      new URL('service-worker.js', document.baseURI), {updateViaCache: 'none'});
    const ready = () => show(navigator.onLine
      ? 'Pronto para estudar offline'
      : 'Sem conexão · estudo disponível offline');
    if (registration.active && navigator.serviceWorker.controller) ready();
    navigator.serviceWorker.addEventListener('controllerchange', ready);
    window.addEventListener('online', ready);
    window.addEventListener('offline', () => {
      if (navigator.serviceWorker.controller) ready();
    });
    const watch = () => {
      const worker = registration.installing;
      if (!worker) return;
      worker.addEventListener('statechange', () => {
        if (worker.state === 'installed' && registration.waiting) {
          show('Atualização pronta. Feche e reabra o app para atualizar.');
        } else if (worker.state === 'redundant' && !registration.active) {
          show('Não foi possível preparar o modo offline. Reconecte e reabra o app.');
        }
      });
    };
    registration.addEventListener('updatefound', watch);
    watch();
    // Ask for protection from automatic eviction after a user interaction.
    document.addEventListener('pointerdown', () => {
      navigator.storage?.persist?.().catch(() => {});
    }, {once: true});
  } catch (error) {
    show('Modo offline indisponível. Use o build PWA e tente novamente com conexão.');
    console.warn('Não foi possível preparar o modo offline.', error);
  }
})();
