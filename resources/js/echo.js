import Echo from 'laravel-echo';

import Pusher from 'pusher-js';
window.Pusher = Pusher;

<<<<<<< HEAD
const reverb = window.Laravel?.reverb ?? {};
const key = reverb.key ?? import.meta.env.VITE_REVERB_APP_KEY;

if (!key) {
    window.Echo = {
        channel: () => ({
            listen: () => {},
        }),
    };
} else {
    window.Echo = new Echo({
        broadcaster: 'reverb',
        key,
        wsHost: reverb.host ?? import.meta.env.VITE_REVERB_HOST,
        wsPort: reverb.port ?? import.meta.env.VITE_REVERB_PORT ?? 80,
        wssPort: reverb.port ?? import.meta.env.VITE_REVERB_PORT ?? 443,
        forceTLS: (reverb.scheme ?? import.meta.env.VITE_REVERB_SCHEME ?? 'https') === 'https',
        enabledTransports: ['ws', 'wss'],
    });
}
=======
window.Echo = new Echo({
    broadcaster: 'reverb',
    key: import.meta.env.VITE_REVERB_APP_KEY,
    wsHost: import.meta.env.VITE_REVERB_HOST,
    wsPort: import.meta.env.VITE_REVERB_PORT ?? 80,
    wssPort: import.meta.env.VITE_REVERB_PORT ?? 443,
    forceTLS: (import.meta.env.VITE_REVERB_SCHEME ?? 'https') === 'https',
    enabledTransports: ['ws', 'wss'],
});
>>>>>>> 8d654fd50fd5611c4ef05a01dc141414a821a1f3
