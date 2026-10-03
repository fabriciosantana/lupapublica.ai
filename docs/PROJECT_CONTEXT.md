# Project Context — CGU Portal da Transparência AI Assistant

## 1. Project purpose

This project implements a conversational AI solution for exploring public data from the **CGU Portal da Transparência**, using the requirements described in the CGU RFI as the main reference.

The immediate objective is to build, within a **5-day development sprint**, a technically solid, demonstrable, end-to-end vertical slice that covers the most relevant capabilities of the RFI.

The target is **not** to claim formal compliance with requirements that cannot be created retroactively, such as prior commercial deployments or previous customer references. The target is to build a real product that can be demonstrated, evaluated and evolved.

---

## 2. RFI context

The RFI contains important qualification conditions, including:

- the solution should already be developed and operational;
- a functional demonstration is required;
- mandatory requirements should be met;
- previous experience with at least two similar customers or projects is requested.

Because this project starts now, the sprint cannot manufacture previous commercial history.

Therefore, the development goal is:

> Build the strongest technically demonstrable solution possible, while maintaining a clear distinction between implemented capabilities and requirements that depend on prior organizational experience, production history, external infrastructure or future integrations.

The RFI must remain available in the repository under a path similar to:

```text
docs/rfi/
```

Whenever requirements are implemented, they should be traceable back to the corresponding RFI item whenever possible.

---

## 3. Sprint objective

At the end of the 5-day sprint, the system should support a full user journey such as:

1. The user asks a question in natural language in Portuguese.
2. The system identifies the user's intent.
3. The system determines whether the answer requires:
   - structured data access;
   - retrieval of textual documents;
   - or both.
4. For structured data:
   - a schema-aware SQL query is generated;
   - the query is validated;
   - only read-only access is allowed;
   - the query is executed against authorized data sources.
5. For textual content:
   - relevant documents are retrieved using RAG.
6. The system generates an answer grounded only in retrieved official evidence.
7. The answer presents its sources and relevant supporting evidence.
8. The interaction is logged for observability.
9. The user can provide feedback.
10. The system can expose operational metrics and evaluation evidence.

A representative use case is:

> "Quanto o parlamentar X destinou em emendas para saúde no Distrito Federal em 2025?"

The answer should be able to include, when supported by data:

- total amounts;
- relevant emendas;
- execution status;
- beneficiaries;
- geographical distribution;
- tables;
- charts;
- maps;
- explanation of budget terminology;
- links or references to official sources;
- confidence/evidence information.

---

## 4. Product principles

The following principles are architectural constraints.

### 4.1 Official data is the source of truth

For factual questions about Portal da Transparência data, the system must use official integrated sources as the basis for its answer.

The LLM's pre-trained knowledge must not be treated as authoritative for factual answers about:

- emendas parlamentares;
- public spending;
- beneficiaries;
- execution values;
- transfers;
- government entities;
- official documents;
- other Portal da Transparência records.

---

### 4.2 Grounding before fluency

A fluent answer without evidence is considered worse than an explicit statement that evidence is insufficient.

Core rule:

```text
structured_data + retrieved_documents -> grounded_answer
```

If evidence is insufficient:

```text
insufficient_evidence -> explicit limitation
```

The system must not invent values, entities, dates, documents or relationships.

---

### 4.3 LLMs must not have unrestricted database access

Generated SQL must never be directly executed without validation.

Text-to-SQL must not operate directly on the raw operational schema when a semantic model is available. The preferred flow is:

```text
Official Raw Data
    ↓
Normalized Data
    ↓
Semantic Transparency Model
    ↓
Verified Query Catalog + Text-to-SQL
    ↓
SQL validation
    ↓
Read-only database
    ↓
Structured result
    ↓
Answer Evidence Contract
    ↓
Grounding / evidence layer
    ↓
LLM explanation
    ↓
Answer + sources
```

The semantic layer should expose domain concepts rather than forcing the model to infer meaning from raw table and column names.

Minimum SQL protections:

- SELECT-only policy;
- allowed schemas;
- allowed tables;
- query timeout;
- row limits;
- protection against destructive commands;
- protection against multiple statements;
- prevention of privilege changes;
- validation using SQL parsing / AST when appropriate;
- database credentials with read-only permissions.

---

### 4.4 Traceability is mandatory

Whenever feasible, maintain traceability across:

```text
CGU RFI
  ↓
OpenSpec requirement
  ↓
OpenSpec change/task
  ↓
implementation
  ↓
automated test
  ↓
demonstration evidence
```

This traceability should later support a requirements/evidence matrix.

---

### 4.5 Semantic transparency model is a first-class product asset

The solution must maintain an explicit semantic layer for public-transparency concepts.

Examples:

```text
parlamentar
emenda
beneficiário
órgão
função
subfunção
município
UF
ano
valor autorizado
valor empenhado
valor liquidado
valor pago
```

The semantic model should define:

- canonical concept names;
- business meaning;
- aliases and citizen-language synonyms;
- relationships;
- measures;
- dimensions;
- aggregation rules;
- temporal semantics;
- data provenance;
- ambiguity warnings.

The goal is to prevent the LLM from having to infer public-budget semantics from raw database structures.

---

### 4.6 Verified queries are preferred evidence for recurring analytical questions

Maintain a versioned catalog of representative natural-language questions with validated SQL and expected result properties.

Examples:

```text
question
validated_sql
expected_columns
expected_filters
expected_aggregation
source_scope
review_status
```

Verified queries serve as:

- regression tests;
- few-shot semantic examples;
- quality anchors for Text-to-SQL;
- demo scenarios;
- reference answers for evaluation.

They must not bypass SQL validation.

---

### 4.7 Answers must follow an explicit evidence contract

The answer-generation layer must consume a structured evidence payload rather than arbitrary tool output.

A conceptual contract may include:

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

The generated response should expose, when applicable:

```text
answer
sources
evidence_summary
visualization_data
limitations
```

The frontend must never rely on prose parsing to reconstruct evidence.

---

### 4.8 AI evaluation is part of product quality

AI behavior must be evaluated continuously using a versioned golden dataset.

Evaluation is not a final sprint activity. Every material change to:

- prompts;
- semantic model;
- verified queries;
- retrieval;
- Text-to-SQL;
- guardrails;
- answer generation;

should be testable against representative cases.

---

### 4.9 OpenSpec is the source of truth for product requirements

Requirements must be represented in OpenSpec before or together with implementation.

Do not silently redefine a requirement directly in code.

If a conflict exists between:

- RFI;
- OpenSpec;
- architecture;
- implementation;

the conflict must be explicitly documented and resolved.

---

### 4.10 Avoid overengineering

The sprint exists to produce a complete vertical slice, not a speculative enterprise platform.

Prefer:

- small cohesive modules;
- explicit interfaces;
- adapters around external services;
- strong tests;
- observable behavior;
- simple deployment;
- incremental delivery.

Avoid unnecessary abstraction unless a requirement clearly justifies it.

---

## 5. Priority model

### P0 — Must work in the sprint

The following capabilities are critical:

- official data ingestion;
- natural language query;
- intent routing;
- semantic transparency model;
- verified query catalog;
- schema-aware Text-to-SQL;
- SQL validation and read-only execution;
- answer evidence contract;
- grounded answers;
- source/evidence presentation;
- refusal when evidence is insufficient;
- automated tests;
- deployable demo.

### P1 — Strongly desirable

- RAG for textual content;
- conversational context;
- user feedback;
- observability / LLMOps;
- charts;
- maps;
- accessibility;
- administrative metrics;
- evaluation dataset;
- guardrails against prompt injection and off-domain misuse.

### P2 — Architecture-ready, not necessarily fully implemented

- multiple interchangeable LLM providers;
- advanced analytics;
- advanced co-browsing;
- broad external portal integrations;
- local model serving;
- fine-tuning;
- production-grade high availability;
- enterprise SSO;
- large-scale multi-region deployment.

---

## 6. Functional capabilities

The OpenSpec structure should represent at least the following capabilities.

### 6.1 Data ingestion

Responsibilities:

- obtain official source data;
- normalize data;
- store relational data;
- preserve relevant source identifiers;
- preserve provenance;
- support reproducible ingestion;
- detect failures;
- expose ingestion metrics.

Possible initial sources include:

- Portal da Transparência APIs;
- official downloadable datasets;
- relevant official documents.

---

### 6.2 Conversational query

The system must accept natural-language questions in Portuguese.

Examples:

```text
Quais municípios receberam mais recursos de emendas?
```

```text
Quanto foi pago das emendas do parlamentar X?
```

```text
Qual a diferença entre empenhado, liquidado e pago?
```

```text
Quais foram os principais beneficiários das emendas de saúde em 2025?
```

The query layer should classify whether the request requires:

- structured query;
- semantic retrieval;
- explanatory content;
- visualization;
- clarification;
- refusal.

---

### 6.3 Semantic transparency model

The semantic layer translates raw government data structures into stable public-transparency concepts.

It should model, when available:

- entities;
- dimensions;
- measures;
- relationships;
- aliases;
- domain definitions;
- valid aggregations;
- temporal meaning;
- provenance.

The Text-to-SQL component should query against this semantic representation whenever practical instead of directly reasoning over raw ingestion tables.

---

### 6.4 Verified query catalog

Maintain a versioned set of validated question-to-query examples.

Each verified query should contain enough metadata to support both evaluation and semantic guidance, for example:

```text
id
natural_language_question
validated_sql
semantic_concepts
expected_result_shape
review_status
notes
```

Verified queries should be reviewed and treated as quality assets.

---

### 6.5 Text-to-SQL

The Text-to-SQL component should:

- understand only authorized schemas;
- use schema metadata;
- produce SQL appropriate for the target DB;
- never execute SQL directly;
- provide the generated SQL to the validation layer;
- support logging and replay for debugging/evaluation.

---

### 6.6 SQL validation

The validation layer must enforce security before execution.

At minimum:

```text
SELECT only
single statement
approved schemas
approved tables
row limits
timeouts
no DDL
no DML
no privilege commands
```

Whenever possible, validate SQL semantically using a parser/AST rather than regex only.

---

### 6.7 RAG

RAG should be used for information that is primarily textual or explanatory, such as:

- documentation;
- budget terminology;
- methodology;
- official explanatory texts;
- metadata;
- help content;
- public documents.

RAG is not a substitute for relational queries when precise structured values are available in a database.

---

### 6.8 Answer evidence contract and grounded generation

The generation layer receives an explicit evidence contract, not unrestricted data access.

Expected evidence payload may include:

```text
question
interpreted_intent
conversation_context
structured_results
retrieved_documents
source_metadata
filters_applied
query_scope
data_freshness
limitations
```

Expected output should be structured enough to support:

```text
answer
evidence_summary
sources
visualization_data
limitations
```

The system must preserve a machine-readable boundary between evidence and generated prose.

---

### 6.9 Source traceability

A user must be able to understand where the answer came from.

The UI should present relevant:

- source names;
- official record identifiers;
- links when available;
- filters used;
- query date;
- data scope;
- limitations.

---

### 6.10 Guardrails

The system should protect against:

- prompt injection;
- requests to ignore system instructions;
- attempts to obtain internal prompts;
- attempts to generate destructive SQL;
- attempts to access non-authorized data;
- out-of-domain requests;
- unsupported factual assertions;
- excessive query scope.

Guardrails should be testable.

---

### 6.11 Conversation context

Conversation history should support follow-up questions such as:

```text
E desses, quais receberam recursos para saúde?
```

The system must distinguish conversational context from authoritative factual evidence.

For the sprint, session-level context is sufficient unless OpenSpec says otherwise.

---

### 6.12 Feedback

The UI should allow explicit feedback, initially:

```text
👍 útil
👎 não útil
```

Feedback should be logged with relevant interaction identifiers so that responses can later be evaluated.

---

### 6.13 LLMOps and observability

Important telemetry includes:

- request ID;
- timestamp;
- user question;
- detected intent;
- generated SQL;
- validation result;
- database execution duration;
- retrieved documents;
- LLM provider/model;
- prompt version;
- response latency;
- token usage;
- estimated cost when applicable;
- errors;
- grounding result;
- feedback.

Sensitive/internal fields should not automatically be exposed in the UI.

---

### 6.14 Visualizations

When useful and supported by data, answers may include:

- tables;
- bar charts;
- line charts;
- rankings;
- maps;
- distribution summaries.

Visualizations must be driven by returned evidence, not fabricated by the LLM.

---

### 6.15 Accessibility

The frontend should be developed with accessibility as a product requirement, not as a final cosmetic task.

Consider:

- semantic HTML;
- keyboard navigation;
- focus management;
- ARIA only where needed;
- contrast;
- screen-reader behavior;
- responsive design;
- accessible charts/tables;
- Brazilian government accessibility recommendations when applicable.

---

## 7. Suggested architecture

The final stack can evolve, but the logical architecture should preserve separation of concerns.

```text
                           ┌────────────────────┐
                           │      Web App       │
                           └─────────┬──────────┘
                                     │
                                  API/BFF
                                     │
                           ┌─────────▼──────────┐
                           │ AI Orchestrator    │
                           └─────────┬──────────┘
                                     │
                           ┌─────────▼──────────┐
                           │   Intent Router    │
                           └─────────┬──────────┘
                                     │
                  ┌──────────────────┼──────────────────┐
                  │                                     │
                  ▼                                     ▼
            RAG / Search                       Structured Analytics
                  │                                     │
                  │                           Semantic Transparency Model
                  │                                     │
                  │                         ┌───────────┴───────────┐
                  │                         │                       │
                  │                 Verified Queries          Text-to-SQL
                  │                         │                       │
                  │                         └───────────┬───────────┘
                  │                                     ▼
                  │                               SQL Validator
                  │                                     │
                  │                                     ▼
                  │                              Read-only Database
                  │                                     │
                  └──────────────────┬──────────────────┘
                                     ▼
                           Answer Evidence Contract
                                     │
                                     ▼
                           Grounding / Validation
                                     │
                                     ▼
                                LLM Gateway
                                     │
                                     ▼
                              Answer + Sources
                                     │
                                     ▼
                         Observability / AI Evaluation
```

A provider abstraction is encouraged, but only one provider needs to be fully operational during the initial sprint if time is constrained.

Example conceptual interface:

```text
LlmProvider
    generate(...)
```

Possible adapters may later include:

```text
AzureOpenAIProvider
AwsBedrockProvider
OpenAIProvider
LocalModelProvider
```

Do not implement providers merely for appearance.

---

## 8. Technology guidance

Technology choices should optimize speed, reliability and team familiarity.

Reasonable options include:

### Frontend

- React;
- Next.js;
- TypeScript.

### Backend

- Java + Spring Boot;
- or another stack explicitly justified in OpenSpec.

### Data

- PostgreSQL;
- pgvector when vector search is required.

### AI

Use an LLM provider through an abstraction layer.

### Observability

Use structured logs and metrics.

If Grafana/OpenTelemetry or another telemetry stack is used, instrumentation should remain simple enough to fit the sprint.

---

## 9. Data model philosophy

Structured government data should remain relational whenever appropriate.

Do not convert all source data into embeddings.

Use:

```text
raw/normalized data   -> authoritative storage
semantic model        -> business meaning and governed analytical concepts
verified query catalog-> validated analytical examples
relational database   -> precise values / aggregation / filtering
vector search         -> semantic retrieval of text
evidence contract     -> structured grounding boundary
LLM                   -> intent + synthesis + explanation
```

Each tool should solve the problem it is best suited for.

---

## 10. Security principles

Security requirements include:

- least privilege;
- read-only query execution;
- isolated credentials;
- no database credentials exposed to frontend or LLM;
- secrets outside source control;
- input validation;
- output encoding;
- dependency scanning when feasible;
- rate limiting;
- auditability;
- sanitized logs where necessary.

The application must never trust LLM-generated code or queries by default.

---

## 11. AI evaluation

AI behavior requires explicit evaluation.

A versioned golden dataset should be created with representative questions covering:

- exact structured queries;
- aggregations;
- ambiguous questions;
- follow-up questions;
- explanatory questions;
- unsupported questions;
- prompt injection;
- attempts to bypass SQL restrictions;
- insufficient evidence.

Useful evaluation dimensions:

- factual correctness;
- grounding;
- source correctness;
- SQL correctness;
- refusal correctness;
- completeness;
- latency.

The sprint should prefer a small reliable evaluation set over a large superficial one.

The evaluation suite should also include verified queries as regression anchors.

When possible, track results over time so changes in prompts, semantic definitions or model providers can be compared before merging.

---

## 12. Testing strategy

Each capability should have appropriate tests.

### Unit tests

Examples:

- intent routing;
- SQL policy validation;
- answer formatting;
- source formatting;
- guardrail rules.

### Integration tests

Examples:

- DB query execution;
- ingestion;
- retrieval;
- LLM provider adapter;
- end-to-end grounded response.

### AI evaluation tests

Examples:

- expected SQL properties;
- evidence coverage;
- refusal;
- injection resistance.

### Frontend tests

Examples:

- chat flow;
- rendering sources;
- rendering structured results;
- feedback;
- accessibility.

---

## 13. Five-day execution plan

### Day 1 — Specification, architecture and data

Goals:

- initialize repository;
- configure OpenSpec;
- preserve RFI in repository;
- extract requirements;
- define capabilities;
- define architecture;
- establish development conventions;
- define the first Semantic Transparency Model;
- create the initial Verified Query Catalog;
- implement initial ingestion;
- make real official data queryable.

Exit criterion:

> Real official data can be queried reliably in the development environment.

---

### Day 2 — AI engine

Goals:

- intent classification;
- Text-to-SQL against the semantic layer;
- SQL validation;
- read-only execution;
- initial RAG;
- Answer Evidence Contract;
- grounding;
- source metadata;
- structured response contract;
- initial golden evaluation dataset.

Exit criterion:

> A real user question can produce a grounded answer using official data.

---

### Day 3 — Product experience

Goals:

- frontend;
- conversational flow;
- source rendering;
- charts;
- maps where supported;
- session context;
- feedback;
- responsive layout;
- accessibility baseline.

Exit criterion:

> A user can complete the main scenario through the UI.

---

### Day 4 — Security, observability and quality

Goals:

- prompt-injection defenses;
- security hardening;
- LLMOps logging;
- metrics;
- feedback telemetry;
- automated evaluation;
- integration tests;
- E2E tests;
- accessibility tests;
- deployment hardening.

Exit criterion:

> The product is measurable, testable and defensible in a technical demonstration.

---

### Day 5 — Evidence and demo readiness

Do not prioritize new major features.

Focus on:

- bug fixing;
- usability;
- performance;
- documentation;
- architecture diagrams;
- requirement traceability;
- test evidence;
- screenshots;
- demonstration script;
- deployment verification;
- RFI evidence matrix.

Exit criterion:

> The system can be demonstrated end-to-end with evidence for implemented requirements.

---

## 14. Evidence matrix

Maintain or generate a matrix similar to:

| RFI | OpenSpec | Implementation | Test | Evidence |
|---|---|---|---|---|
| CGU-X.Y | capability/spec | module/file | test id | demo/screenshot/log |

Do not mark a requirement as implemented unless verifiable evidence exists.

Possible states:

```text
implemented
partially implemented
architecture-ready
not implemented
external dependency
not applicable
not achievable within sprint
```

---

## 15. Definition of Done

A feature is not done merely because code exists.

A capability is done when:

1. the behavior is specified;
2. implementation exists;
3. tests exist;
4. tests pass;
5. observability exists when relevant;
6. acceptance criteria pass;
7. evidence can be demonstrated;
8. documentation is updated when required.

---

## 16. Known constraints

The following constraints must remain visible throughout the project.

### Historical qualification

The sprint cannot create prior customer deployments.

### Production maturity

A five-day sprint cannot credibly prove:

- long-term availability;
- production-scale HA;
- months of operational history;
- enterprise load history.

Do not misrepresent these items.

### External integrations

Some integrations may depend on:

- credentials;
- API limits;
- data availability;
- documentation;
- network access.

When blocked, preserve the architectural interface and clearly document the dependency.

---

## 17. Working style

The project should use incremental, specification-driven development.

Preferred cycle:

```text
explore
  ↓
specify
  ↓
implement
  ↓
test
  ↓
verify
  ↓
document evidence
```

Codex should not treat OpenSpec as documentation written after implementation.

---

## 18. Decision log

Important architecture decisions should be recorded under a structure such as:

```text
docs/architecture/decisions/
```

Examples:

```text
ADR-001-use-postgresql-for-structured-data.md
ADR-002-use-hybrid-rag-and-text-to-sql.md
ADR-003-read-only-sql-execution.md
ADR-004-llm-provider-abstraction.md
```

ADRs should be concise.

---

## 19. Scope discipline

When deciding between:

- adding another feature;
- making the main user journey reliable;

choose reliability.

When deciding between:

- speculative abstraction;
- tested working code;

choose tested working code.

When deciding between:

- impressive AI output;
- verifiable AI output;

choose verifiable AI output.

---

## 20. Initial OpenSpec capabilities

Recommended initial capability names:

```text
data-ingestion
semantic-model
verified-query-catalog
conversational-query
intent-routing
text-to-sql
sql-validation
rag
answer-evidence-contract
grounded-answer
source-traceability
guardrails
conversation-context
feedback
llm-observability
visualization
accessibility
deployment
ai-evaluation
```

These names can be refined during initial OpenSpec setup, but avoid creating excessively granular capabilities.

---

## 21. Initial milestone

The first meaningful milestone is:

> Ask one realistic question about Portal da Transparência data and obtain a correct, grounded, traceable answer through the application.

Everything else should support this milestone.
