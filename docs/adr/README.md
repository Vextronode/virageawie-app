# Architecture Decision Records

An Architecture Decision Record (ADR) is a short document that captures one significant technical decision: the situation that forced it, what was decided, and what follows from it. ADRs explain *why* the code looks the way it does, long after the discussion is forgotten.

## When to write one

Write an ADR when a decision is hard to reverse or affects several modules, for example:

- choosing or replacing a framework, library, or infrastructure component;
- how money, stock valuation, or rounding is calculated;
- data model or migration strategies;
- security, authentication, or deployment changes.

Small, local choices do not need an ADR.

## Format

- One file per decision in this folder: `NNNN-short-title.md`, where `NNNN` is the next free four-digit number (`0001-use-postgresql.md`).
- Copy [`0000-template.md`](0000-template.md) and fill in every section: **Status**, **Context**, **Decision**, **Consequences**.
- Status is one of `Proposed`, `Accepted`, `Deprecated`, or `Superseded by NNNN`.
- Keep it short; one page is usually enough.

## Rules

- An accepted ADR is not rewritten. If a decision changes, write a new ADR and mark the old one `Superseded by NNNN`.
- Add or update an ADR in the same pull request as the change it describes.
- ADRs may be written in Indonesian or English; keep one language per file.
