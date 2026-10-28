## Summary

<!-- What does this PR change, and why? Keep it to a few sentences. -->

## Related FR or issue

<!-- For example: FR-07, closes #42 -->

## Type of change

- [ ] feat: new feature
- [ ] fix: bug fix
- [ ] refactor: no behaviour change
- [ ] test: tests only
- [ ] docs: documentation only
- [ ] chore / build / ci: tooling, dependencies, or pipeline
- [ ] perf: performance improvement
- [ ] Breaking change (`!` in the PR title)

## Sensitive zones touched

- [ ] Inventory or cash logic (`src/app/Domain/Inventory/`, `src/app/Domain/Cash/`)
- [ ] Database migrations (`src/database/migrations/`)
- [ ] Authorization and authentication (`src/app/Policies/`, `src/app/Http/Middleware/`, `src/config/auth.php`)
- [ ] Infrastructure and pipelines (`infra/`, `.github/workflows/`)
- [ ] Golden dataset (`src/tests/Fixtures/golden/`)
- [ ] None of the above

## New dependencies

<!-- List every new Composer or npm package with the reason, or write "None". -->

## Test changes explained

<!-- Which tests were added or changed, and which acceptance criteria they cover.
     If an existing expectation changed, explain why the old one was wrong. -->

## Checklist

- [ ] PR title follows Conventional Commits (`type(scope): description`)
- [ ] `composer test`, `composer lint`, `composer analyse` pass locally
- [ ] `npm run lint`, `npm run format:check`, `npm run types`, `npm run build` pass locally
- [ ] I have read and understand every line in this PR
