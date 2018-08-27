function isLoggedIn() {
  const signinDiv = document.getElementById('login');

  if (signinDiv === null) {
    return true;
  } else {
    return false;
  }
}

// Tell serviceworker to check if offline page needs to be created/updated
function sendCreateOfflinePageMessage() {
  if (isLoggedIn()) {
    navigator.serviceWorker.controller.postMessage('create offline page');
  }
}

// If browser supprts service workers register our service worker
if (navigator.serviceWorker) {
  // TODO: refactor to use async/await
  navigator.serviceWorker.register('/event-worker.js', { scope: '/'})
    .then(function(reg) {
      console.log('event-worker registered');
      if (navigator.serviceWorker.controller) {
        // Recreate the offline page when user logs in
        // TODO: restrict to root page
        window.addEventListener('load', sendCreateOfflinePageMessage);
        window.addEventListener('turbolinks:load', sendCreateOfflinePageMessage);
      }
    }())
    .catch(function(err) {
      console.log('event-worker registration failed: ', err);
    });
}
