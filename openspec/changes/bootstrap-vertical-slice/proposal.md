# Proposal

## Why

The repository has OpenSpec and project guidance but no functional application yet. We need a small, demonstrable path from a Portuguese public-transparency question to a validated, traceable answer before expanding into the broader RFI scope.

This change establishes the first vertical slice using the agreed React/TypeScript, Bootstrap, Java/Spring Boot, PostgreSQL and AI-provider architecture. It prioritizes verifiable evidence over breadth and provides the foundation for the five-day sprint.

## What Changes

- Create the initial web application shell with React/TypeScript and Bootstrap.
- Create a Spring Boot REST API with a typed query/answer contract.
- Add PostgreSQL 17 development infrastructure, Flyway migrations and a minimal transparency data model.
- Support one canonical Portuguese question about parliamentary amendments using structured data.
- Add intent routing for the supported structured-query path and an explicit unsupported/refusal path.
- Generate schema-aware SQL through a provider boundary, validate it as read-only single-statement SQL, then execute it with limits and timeout protection.
- Return an Answer Evidence Contract containing the question, interpreted intent, filters, query scope, data freshness, structured results, sources and limitations.
- Add automated backend, frontend and end-to-end tests plus structured request/validation logs.
- Preserve traceability to the applicable CGU RFI requirements, especially 1.1, 2.5, 3.2, 3.3, 3.4, 3.5, 4.1, 4.2 and 4.7.

Out of scope for this change: full Portal da Transparência ingestion breadth, generalized RAG over all documents, maps, co-browsing, feedback calibration, production high availability, multi-provider execution, fine-tuning, enterprise authentication and final cloud deployment.

## Capabilities

### New Capabilities

- `grounded-transparency-query`: Accept a supported Portuguese question, route it to a governed structured query, validate and execute read-only SQL, and return a grounded answer with traceable evidence and explicit limitations.

### Modified Capabilities

- None. The repository has no existing OpenSpec capabilities.

## Impact

- Adds a Next.js/React frontend, a Java 21/Spring Boot 3.x Maven backend and PostgreSQL/pgvector Docker development services.
- Adds Flyway migrations, a semantic query boundary, SQL validation, an initial LLM provider adapter boundary and an evidence response model.
- Adds test and observability infrastructure using JUnit 5, Testcontainers, Vitest, Playwright, OpenTelemetry-compatible structured logs and deterministic fixtures.
- Depends on an official CGU/Portal da Transparência data source for later ingestion and on the configured OpenAI adapter for LLM-backed interpretation; deterministic fixtures remain the test oracle.
