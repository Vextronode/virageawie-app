# 0001. Start from the Laravel React starter kit

- Status: Accepted
- Date: 2026-10-28
- Deciders: project team

## Context

The application needs Laravel 13 with Inertia, React, TypeScript, Tailwind CSS, and session cookie authentication. Writing authentication, settings pages, and the frontend build from scratch would take time and add risk without business value.

The official `laravel/react-starter-kit` package has two kinds of releases on Packagist:

- tagged releases `v1.0.0` and `v1.0.1`, which still target Laravel 12, PHPUnit, and ESLint/Prettier;
- the `dev-main` branch, which is what `laravel new --react` installs, targeting Laravel 13 with Laravel Fortify, Inertia 3, Wayfinder, and Vite+.

## Decision

We use `laravel/react-starter-kit` from `dev-main`, installed with:

```bash
composer create-project laravel/react-starter-kit:dev-main src
```

| Item | Value |
| --- | --- |
| Source | <https://github.com/laravel/react-starter-kit>, branch `main` |
| Commit | `dbd4817d2d2936be14bc1ca7c94692fcef20b6b1` (committed 2026-10-23 17:47 UTC) |
| Laravel | `laravel/framework` v13.38.0 |
| Authentication | Laravel Fortify (session cookies), not WorkOS |

During `create-project`, the kit runs `php artisan install:features` (laravel/chisel). It kept all optional features, removed its `@chisel-*` marker comments, and deleted its own installer files (`app/Console/Commands/InstallFeaturesCommand.php`, `chisel.php`, `chisel-paths.php`) and the kit `README.md`.

We then changed the kit as follows:

1. **Pest instead of PHPUnit.** Removed `phpunit/phpunit` as a direct dependency and added `pestphp/pest` ^4.0 and `pestphp/pest-plugin-laravel` ^4.0. Added `tests/Pest.php` and architecture tests in `tests/Arch/`. The kit's class-based tests still run under Pest.
2. **Tests on PostgreSQL.** `phpunit.xml` uses `pgsql` with the database `virageawie_test` instead of in-memory SQLite, so tests run on the same database engine as production. Removed `database/database.sqlite`.
3. **Removed `laravel/pao`.** The dev package (test output formatting) and its dependency were not needed for this project.
4. **Removed `src/.github/`.** The kit's own workflow and Dependabot file do not run from a subfolder; CI lives in the root `.github/`.
5. **Vite+ for lint and format.** The kit uses Vite+ (Oxlint and Oxfmt) instead of ESLint and Prettier. We kept it and added the scripts `lint` (`vp lint`), `format:check` (`vp fmt --check`), and `types` (`tsc --noEmit`). `vite-plus` and the `vite` alias are pinned to `1.4.0`, and the 0.x build tools are pinned exactly: `@laravel/vite-plugin-wayfinder` 0.1.11, `@rolldown/plugin-babel` 0.2.4, `@laravel/multiplex` 0.4.5.
6. **Configuration.** PHP pinned to 8.4 (`require.php` and `config.platform.php`), Node.js 24 (`.nvmrc`, `engines.node`), PHPStan level 6, locale `id`, faker locale `id_ID`, timezone `Asia/Jakarta`, PostgreSQL in `.env.example`, and editor tool entries removed from `.gitignore` and `vite.config.ts`.
7. **Public registration disabled.** The Fortify `registration` feature, the register page, and the links to it were removed. The registration tests now assert that registration is unavailable. Accounts will be created through an invite flow in a later feature.

## Consequences

- Authentication, password reset, email verification, two-factor authentication, passkeys, and settings pages work from the start and come with tests.
- `dev-main` has no version tags. Updates from the kit are not automatic: compare the commit above with the kit's current `main` and port the changes by hand.
- The kit code uses Laravel 13, Inertia 3, and Vite+, which are newer than many tutorials; contributors should check the official documentation for these versions.
- Vite+ is young. Its version is pinned exactly and must be upgraded deliberately.
