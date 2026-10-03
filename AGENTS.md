# AGENTS.md

## Mission

Build a reliable, grounded and demonstrable conversational AI solution for exploring official CGU Portal da Transparência data.

Before making architectural or functional changes, read:

```text
docs/PROJECT_CONTEXT.md
```

and all relevant OpenSpec files.

OpenSpec is the source of truth for product requirements.

The semantic model, verified-query catalog, evidence contract and AI evaluation suite are first-class product assets and must evolve together with the implementation.

---

## Mandatory workflow

For each feature or change:

1. identify the relevant OpenSpec capability/change;
2. read its requirements and acceptance criteria;
3. inspect the existing implementation;
4. implement the smallest complete increment;
5. add or update automated tests;
6. run the relevant test suite;
7. verify acceptance criteria;
8. update task/change status;
9. report what was completed;
10. report remaining gaps and risks.

Do not silently change product behavior.

If a conflict exists between the RFI, OpenSpec, architecture or code, document the conflict before changing requirements.

---

## Specification-first development

Do not use OpenSpec as post-hoc documentation.

Preferred sequence:

```text
requirement
  ↓
spec/change
  ↓
implementation
  ↓
test
  ↓
verification
  ↓
evidence
```

Whenever possible, preserve traceability:

```text
RFI -> OpenSpec -> task -> code -> test -> evidence
```

---

## Grounding rules

For factual answers concerning Portal da Transparência data:

- official integrated data is authoritative;
- model pre-training is not authoritative;
- unsupported factual claims are forbidden;
- lack of evidence must result in an explicit limitation.

Core principle:

```text
structured_data + retrieved_documents -> grounded_answer
```

Never fabricate:

- monetary values;
- emendas;
- beneficiaries;
- dates;
- public entities;
- execution status;
- documents;
- source references.

---

## Semantic model rules

Do not make Text-to-SQL depend directly on raw ingestion schemas when a governed semantic representation is available.

The Semantic Transparency Model should define:

- canonical domain concepts;
- aliases and citizen-language synonyms;
- measures;
- dimensions;
- relationships;
- aggregation rules;
- temporal semantics;
- provenance;
- ambiguity warnings.

Treat semantic definitions as versioned product behavior.

Changes to semantic meaning require tests.

---

## Verified query rules

Maintain a versioned catalog of validated natural-language questions and SQL.

Use verified queries as:

- regression tests;
- quality anchors;
- semantic examples;
- demo scenarios.

A verified query does not bypass SQL validation.

When a recurring or high-value analytical question is proven correct, prefer adding it to the catalog rather than relying only on prompt behavior.

---

## Answer evidence contract

Generated prose must consume a structured evidence payload.

Do not pass arbitrary tool output directly into user-facing generation without normalization.

The contract should capture, as applicable:

```text
question
interpreted_intent
structured_results
retrieved_documents
source_metadata
filters_applied
query_scope
data_freshness
limitations
```

The response layer should preserve separately:

```text
answer
sources
evidence_summary
visualization_data
limitations
```

Do not reconstruct evidence by parsing generated prose.

---

## Database access rules

Never allow LLM-generated SQL to execute directly.

All generated SQL must pass a validation layer.

Minimum rules:

```text
SELECT only
single statement
approved schemas
approved tables
row limit
query timeout
no DDL
no DML
no privilege commands
```

Use SQL parsing / AST validation when feasible.

Database credentials used for AI-generated queries must be read-only.

The LLM must never receive privileged database credentials.

---

## Architecture rules

Prefer clear boundaries between:

```text
frontend
API/BFF
AI orchestration
intent routing
semantic model
verified query catalog
Text-to-SQL
SQL validation
RAG
answer evidence contract
grounding
LLM provider
data access
observability
AI evaluation
```

Use relational queries for structured facts.

Use vector retrieval for semantic textual retrieval.

Do not embed all data merely because embeddings are available.

---

## LLM provider rules

Use an abstraction for model providers when appropriate.

Do not implement multiple providers unless there is a real sprint need.

One production-quality provider is better than several incomplete adapters.

Provider-specific logic must not leak unnecessarily into domain logic.

---

## Security

Treat all LLM output as untrusted.

Treat user input as untrusted.

Protect against:

- prompt injection;
- system prompt extraction;
- destructive SQL;
- unauthorized data access;
- multiple SQL statements;
- excessive query scope;
- secret leakage;
- sensitive logging.

Keep secrets outside version control.

Follow least privilege.

---

## Testing

No critical capability should rely only on manual testing.

Use:

- unit tests;
- integration tests;
- end-to-end tests;
- AI evaluation tests where appropriate.

Critical areas requiring automated tests include:

- semantic model behavior;
- verified queries;
- Text-to-SQL;
- SQL validation;
- evidence contract;
- grounding;
- source traceability;
- guardrails;
- unsupported-question behavior.

---

## AI evaluation

Maintain a versioned golden evaluation dataset and treat evaluation as part of the development loop, not as post-hoc QA.

Include:

- precise structured questions;
- aggregations;
- ambiguous questions;
- follow-up questions;
- explanatory questions;
- insufficient-evidence cases;
- prompt injection;
- SQL bypass attempts.

Evaluate, where appropriate:

- correctness;
- grounding;
- source correctness;
- SQL correctness;
- refusal correctness;
- completeness;
- latency.

---

## Observability

Instrument important AI interactions.

Useful fields include:

```text
request_id
timestamp
intent
generated_sql
sql_validation_result
query_duration
retrieved_sources
model
prompt_version
latency
token_usage
error
feedback
```

Do not expose internal telemetry to end users unless explicitly designed for that purpose.

Do not log secrets.

---

## Frontend

The UI must prioritize:

- clarity;
- evidence;
- accessibility;
- responsive behavior;
- understandable error states.

Answers should make sources easy to inspect.

Prefer semantic HTML.

Accessibility is a requirement, not a final polish task.

---

## Implementation style

Prefer:

- simple code;
- explicit types;
- cohesive modules;
- dependency injection where useful;
- deterministic behavior where possible;
- small functions;
- meaningful names;
- minimal dependencies;
- reproducible local setup.

Avoid:

- speculative abstractions;
- framework proliferation;
- hidden global state;
- magic configuration;
- untested AI behavior.

---

## Scope control

Sprint priority order:

### P0

```text
data ingestion
semantic transparency model
verified query catalog
natural-language query
intent routing
Text-to-SQL
SQL validation
read-only execution
answer evidence contract
grounded answers
sources
tests
deployable demo
```

### P1

```text
RAG
conversation context
feedback
LLMOps
guardrails
charts/maps
accessibility
evaluation
```

### P2

```text
multiple model providers
advanced analytics
advanced co-browsing
fine-tuning
broad external integrations
production-grade HA
```

Do not sacrifice P0 quality to implement P2.

---

## Five-day sprint behavior

### Day 1

Prioritize:

- OpenSpec;
- architecture;
- Semantic Transparency Model;
- initial Verified Query Catalog;
- real official data ingestion.

### Day 2

Prioritize:

- intent;
- Text-to-SQL over the semantic layer;
- SQL validation;
- Answer Evidence Contract;
- grounding;
- initial golden evaluation dataset.

### Day 3

Prioritize:

- frontend;
- user journey;
- evidence rendering;
- visualizations.

### Day 4

Prioritize:

- security;
- observability;
- testing;
- evaluation.

### Day 5

Do not start major features.

Prioritize:

- bug fixing;
- evidence;
- documentation;
- demo;
- requirement traceability;
- deployment verification.

---

## Definition of Done

A feature is done only when:

- requirement exists;
- implementation exists;
- tests exist;
- tests pass;
- acceptance criteria pass;
- evidence can be shown;
- documentation is updated when necessary.

Code alone does not mean done.

---

## Commit discipline

Prefer small, coherent commits.

Commit messages should make the implemented capability understandable.

Avoid mixing unrelated changes.

When implementing an OpenSpec change, reference the capability/change in commit messages when practical.

---

## Documentation

Update documentation when architecture, behavior, setup or operational requirements change.

Record meaningful architectural decisions as ADRs under:

```text
docs/architecture/decisions/
```

Do not generate large documentation files that merely repeat source code.

---

## Initial session behavior

At the beginning of a fresh Codex session:

1. read this file;
2. read `docs/PROJECT_CONTEXT.md`;
3. inspect relevant OpenSpec files;
4. inspect git status;
5. inspect the current task/change;
6. state the next implementation target before editing code.

For a new repository, before coding, provide:

1. product understanding;
2. identified capabilities;
3. architecture understanding;
4. gaps/inconsistencies;
5. technical risks;
6. proposed OpenSpec organization;
7. five-day implementation plan;
8. first OpenSpec change to execute.

---

## Final decision rule

When forced to choose:

```text
working > speculative
tested > assumed
semantic > schema-guessing
verified > improvised
grounded > fluent
traceable > opaque
simple > overengineered
```
