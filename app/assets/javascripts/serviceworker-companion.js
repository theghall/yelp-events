function isLoggedIn() {
  let loggedIn = false;
  // Check for signed_in cookie created by Warden (see devise.rb)
  const result = document.cookie.match('(^|;)\\s*' + 'signed_in' + '\\s*=\\s*([^;]+)')

  if (result && result[2] === '1') {
    loggedIn = true;
  }

  return loggedIn;

}

// Tell serviceworker to check if offline page needs to be created/updated
function sendCreateOfflinePageMessage() {
  if (isLoggedIn()) {
    navigator.serviceWorker.controller.postMessage('create offline page');
  }
}

async function registerWorker() {
  // If browser supprts service workers register our service worker
  if (navigator.serviceWorker) {
    try {
        const reg = await navigator.serviceWorker.register('/event-worker.js', { scope: '/'});
        const installed = await reg;
        console.log('event-worker registered', installed);
        if (navigator.serviceWorker.controller) {
          // Recreate the offline page when user logs in
          // TODO: restrict to root page
          window.addEventListener('load', sendCreateOfflinePageMessage);
          window.addEventListener('turbolinks:load', sendCreateOfflinePageMessage);
        }
    } catch(err) {
      console.log('event-worker registration failed: ', err);
    }
  }
}

registerWorker();
