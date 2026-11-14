# Frontend

## Stack
- Inertia 3 + React 19 + TypeScript, Tailwind CSS 4 via the Vite plugin, built with Vite+ (`vp`).
- Routes in TypeScript come from Wayfinder (`@/routes`, `@/actions`); never hard-code URLs.
- Lint and format: `npm run lint` (Oxlint), `npm run format:check` (Oxfmt), `npm run types` (tsc).

## Pages and components
- Pages: `resources/js/pages/<module>/<page>.tsx`, rendered by `Inertia::render('<module>/<page>')`.
- Layouts: `resources/js/layouts/`. Shared components: `resources/js/components/` and `components/ui/` (shadcn style). Keep the existing lowercase folder names.
- Reuse existing components (Button, Input, Card, Dialog, Table). Add a new shared component only when two pages need it.
- Props are typed with an interface in the page file or in `resources/js/types/`.

## Business values
- Components never compute balances, totals, cost, HPP, or stock. The server sends ready values (already formatted where useful, for example `"Rp 1.250.000"`).
- Client-side arithmetic is allowed only for display hints (for example a running line total in a form), and the server result is always authoritative.

## Text and locale
- All UI text in Indonesian. Dates shown as `dd/mm/yyyy` in Asia/Jakarta; amounts as `Rp 1.250.000`.
- Validation messages come from the server (FormRequest) and are shown with the shared input error component.

## Styling
- Tailwind utility classes only. Custom CSS only in `resources/css/app.css`.
- No inline `style` except for truly dynamic values.
- Mobile first; forms must be usable on a phone.

## Forms
- Use Inertia `useForm` or the `<Form>` component with Wayfinder form variants.
- Every form that creates a transaction sends an idempotency key generated once per form instance (`crypto.randomUUID()`), so a retry does not create a duplicate.
- Disable the submit button while processing.

## Offline behaviour (PWA)
- Offline retry: when a submit fails because the network is down, keep the form data, show "Koneksi terputus, coba kirim ulang", and let the user retry with the same idempotency key.
- Form draft: save unsent form input to `localStorage` per form and user; restore it on reopen; clear it after a successful submit.
- No background sync, no queued offline transactions, no service-worker replay. The server stays the only source of truth.

## Never
- Store secrets or tokens in frontend code or `localStorage`.
- Disable lint rules without a comment explaining why.
- Edit generated files in `resources/js/actions`, `routes`, or `wayfinder`.
