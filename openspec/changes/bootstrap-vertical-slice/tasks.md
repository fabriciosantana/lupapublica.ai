# Tasks

## 1. Repository and development foundation

- [ ] 1.1 Create the `apps/web`, `apps/api`, `infra` and `data` structure and document local prerequisites in `README.md`; verify the expected directories and startup instructions exist.
- [ ] 1.2 Scaffold the Next.js/TypeScript web app and Spring Boot 3.x/Maven API with pinned initial dependency versions; verify both projects compile independently.
- [ ] 1.3 Add Docker Compose for PostgreSQL 17 with a development-only read/write separation plan; verify the database starts and accepts the configured health check.

## 2. Relational model and provenance

- [ ] 2.1 Add Flyway migrations for the minimal amendment, parliamentarian, beneficiary, location, year, amount and provenance model; verify migrations apply to a clean PostgreSQL instance.
- [ ] 2.2 Add a deterministic, provenance-tagged development fixture derived from an approved official snapshot and document its freshness and limitations; verify fixture loading is repeatable.
- [ ] 2.3 Add Testcontainers integration coverage for the schema, fixture and source metadata; verify source identifiers and freshness survive a query.

## 3. Backend contracts and query orchestration

- [ ] 3.1 Define versioned request/response DTOs for `POST /api/v1/conversations/query`, including answer, structured results, sources, evidence summary, filters, freshness and limitations; verify JSON contract tests.
- [ ] 3.2 Implement Portuguese intent classification with supported, explanatory, follow-up, clarification and refusal outcomes; verify unit tests for supported, ambiguous, out-of-scope and injection-oriented inputs.
- [ ] 3.3 Implement the semantic query-plan boundary and deterministic provider port, keeping provider-specific types outside domain code; verify tests produce the expected canonical concepts and filters.
- [ ] 3.4 Implement the evidence assembler so generated prose cannot replace structured evidence; verify contract tests preserve sources, scope, freshness and limitations.

## 4. SQL safety and read-only execution

- [ ] 4.1 Implement SQL parsing and policy validation for one bounded `SELECT` over approved relations; verify tests reject DDL, DML, privilege commands, multiple statements, unauthorized relations and missing limits.
- [ ] 4.2 Configure the API database role with read-only privileges and enforce query timeout and row limits; verify an integration test proves writes fail and safe reads succeed.
- [ ] 4.3 Connect the validated query plan to PostgreSQL and map empty, ambiguous and successful results into evidence outcomes; verify integration tests cover all three paths.

## 5. AI adapter, grounding and auditability

- [ ] 5.1 Add the initial OpenAI adapter behind the provider interface with environment-based configuration and secret redaction; verify adapter tests run against a deterministic stub without requiring live credentials.
- [ ] 5.2 Add guardrails for prompt injection, internal-prompt requests, unsupported scope and insufficient evidence; verify refusal tests show no unauthorized SQL or fabricated evidence is returned.
- [ ] 5.3 Add structured request logs and OpenTelemetry-compatible boundary metadata for request ID, model, prompt version, validation, latency and grounding status; verify sensitive values are absent from captured logs.

## 6. Web experience

- [ ] 6.1 Build the Bootstrap-based responsive conversation screen with accessible input, loading, error, clarification, refusal and result states; verify Vitest/React Testing Library coverage for each state.
- [ ] 6.2 Render structured results, sources, evidence summary, freshness and limitations from response fields rather than parsing prose; verify component tests cover empty and populated evidence.
- [ ] 6.3 Add keyboard navigation, semantic status announcements and responsive layout checks; verify an accessibility-focused test covers the main interaction.

## 7. Vertical integration and evidence

- [ ] 7.1 Add a Playwright E2E test for the canonical Portuguese question from the web client through the API and database fixture; verify the answer includes structured evidence and source metadata.
- [ ] 7.2 Add a reproducible local runbook covering Compose, migrations, fixture loading, API, web app and test commands; verify a clean checkout can follow it without undocumented steps.
- [ ] 7.3 Run the complete backend, frontend and E2E suites and produce an RFI-to-spec-to-test evidence table for the affected requirements; verify all acceptance scenarios are mapped or explicitly marked as gaps.
