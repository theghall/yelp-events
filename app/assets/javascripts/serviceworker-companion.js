if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/event-worker.js', { scope: '/'})
    .then(function(reg) {
      console.log('event-worker registered');
    })
    .catch(function(err) {
      console.log('event-worker registration failed: ', err);
    });
}
