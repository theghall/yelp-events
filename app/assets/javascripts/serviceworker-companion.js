function isLoggedIn() {
  const signinDiv = document.getElementById('login');

  if (signinDiv === null) {
    return true;
  } else {
    return false;
  }
}

if (navigator.serviceWorker) {
  // TODO: refactor to use async/await
  navigator.serviceWorker.register('/event-worker.js', { scope: '/'})
    .then(function(reg) {
      console.log('event-worker registered');
      if (navigator.serviceWorker.controller) {
        // Recreate the offline page when user logs in
        // TODO: restrict to root page
        window.addEventListener('load', function() {
          if (isLoggedIn()) {
            navigator.serviceWorker.controller.postMessage('create offline page');
          }
        });
      }
    })
    .catch(function(err) {
      console.log('event-worker registration failed: ', err);
    });
}
