// Minimal Firebase Messaging Service Worker
// This file is required to prevent "Unsupported MIME type ('text/html')" errors in Chrome
// when Firebase attempts to register the service worker for Web Push notifications.

importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

firebase.initializeApp({
    // The SDK automatically uses the web configuration from your Firebase project
    // if you leave this empty or if you are using the FlutterFire CLI.
    // Note: For actual push notifications to work, you might need to paste your 
    // firebaseConfig here if it's not being injected.
    messagingSenderId: "dummy-id"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/favicon.png'
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});
