Rails.application.configure do
  config.serviceworker.routes.draw do
    match "/event-worker.js" => 'serviceworkers/event-worker.js'
    match "/manifest.json" => 'serviceworkers/manifest.json'
  end
end
