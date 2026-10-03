# Design

## Context

The repository contains project context, the CGU RFI and OpenSpec setup but no application code or existing capability specs. The first slice must be small enough for the five-day horizon while preserving the RFI's requirements for grounding, traceability, security, accessibility and auditability. See `proposal.md` for motivation and scope.

## Goals / Non-Goals

**Goals:**

- Deliver one end-to-end Portuguese structured-query journey.
- Keep authoritative evidence separate from generated prose.
- Make unsafe SQL impossible to execute through the application boundary.
- Establish testable seams for future ingestion, RAG and provider changes.
- Keep development reproducible with Docker Compose and deterministic fixtures.

**Non-Goals:**

- Full ingestion of every Portal da Transparência dataset.
- General-purpose RAG, maps, co-browsing, feedback learning or production HA.
- Multiple active LLM providers or local fine-tuning in the first slice.

## Decisions

### Repository shape

Use a small monorepo:

```text
apps/web/          Next.js + TypeScript + Bootstrap
apps/api/          Java 21 + Spring Boot 3.x + Maven
infra/             Docker Compose and local service configuration
data/              deterministic, provenance-tagged development fixtures
openspec/          requirements and change artifacts
```

The web client calls the API through a versioned REST boundary. The API owns orchestration, validation, persistence and evidence construction; the browser never receives database credentials or provider secrets.

### Backend boundaries

Keep these responsibilities separate:

```text
HTTP adapter
  -> conversation/query application service
  -> intent and semantic query planner
  -> LLM provider port
  -> SQL policy validator
  -> read-only query adapter
  -> evidence assembler
```

The provider port allows an OpenAI adapter initially and future Azure, Bedrock or local adapters without leaking provider types into domain behavior. A deterministic rule/fixture path remains available for tests and for unsupported or ambiguous requests.

### Data model and provenance

Use PostgreSQL 17 with Flyway migrations. Keep structured transparency data relational. Use `pgvector` only for future document retrieval; it is not required for the first structured path. Every fixture or imported record carries source identity, snapshot/freshness metadata and provenance fields so a result can be traced.

### Query safety

The planner produces a typed query plan before SQL. The validator parses the SQL and checks statement count, command type, relations, selected columns, parameters, row limit and timeout. The database role used by the API is read-only. Rejected SQL never reaches PostgreSQL.

### API and evidence contract

Expose a versioned endpoint such as `POST /api/v1/conversations/query`. Its response has separate fields for `answer`, `structuredResults`, `sources`, `evidenceSummary`, `filtersApplied`, `dataFreshness` and `limitations`. The frontend renders these fields directly.

### Testing and observability

Use JUnit 5 and Testcontainers for API/database integration, Vitest for web units, and Playwright for the main browser flow. Emit structured logs with request ID, prompt version, model metadata, validation outcome, latency and grounding status; redact secrets and unnecessary personal data. Add OpenTelemetry-compatible spans only around meaningful boundaries.

## Risks / Trade-offs

- **[Risk]** A fixture can be mistaken for live official data. → Label snapshots clearly, preserve source metadata and keep live ingestion outside this change.
- **[Risk]** LLM output may invent SQL or evidence. → Treat model output as untrusted, validate SQL, constrain the evidence assembler and test refusal paths.
- **[Risk]** Spring AI/LangChain4j integration expands scope. → Hide it behind one provider port and pin only the minimum dependency set during implementation.
- **[Risk]** Bootstrap components can harm accessibility if used without semantic markup. → Test keyboard and screen-reader-relevant states and keep semantic HTML authoritative.
- **[Risk]** Broad RFI requirements exceed the sprint. → Keep the first slice narrow and label deferred capabilities explicitly.

## Migration Plan

No production migration exists. For development, start PostgreSQL with Docker Compose, run Flyway migrations, load the provenance-tagged fixture, start the API and web client, then execute unit, integration and E2E tests. Rollback is removing the local containers and reverting the uncommitted change; no external system is modified.

## Open Questions

- Which official Portal da Transparência endpoint or snapshot will be authorized for the first real-data ingestion task?
- Which deployment target and AWS/Azure service will be used after the local vertical slice is proven?
