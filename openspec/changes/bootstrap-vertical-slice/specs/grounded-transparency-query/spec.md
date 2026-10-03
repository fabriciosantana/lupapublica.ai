# Spec Delta

## Purpose

This capability provides a governed conversational path from a Portuguese public-transparency question to a traceable answer backed by authorized structured evidence. It establishes the core behavior on which later RAG, ingestion, visualizations and broader Portal integrations can build.

## ADDED Requirements

### Requirement: Supported questions are classified before data access

The system MUST accept a Portuguese natural-language question and classify whether it is a supported structured-transparency query, an explanatory request, a follow-up, or unsupported. It MUST select an explicit refusal or clarification path when the request cannot be answered by the available capability.

#### Scenario: Supported structured question
- **WHEN** a user asks how much a named parliamentarian allocated in amendments for health in a specified Brazilian location and year
- **THEN** the system classifies the request as a structured-transparency query and continues to governed query planning

#### Scenario: Unsupported request
- **WHEN** a user asks for a fact outside the available transparency data or asks the system to ignore its scope
- **THEN** the system does not access unauthorized data and returns a clear limitation or refusal

### Requirement: Queries use governed transparency semantics

The system MUST translate a supported question into a query plan using canonical transparency concepts, authorized fields, filters, measures and temporal meaning. The plan MUST preserve the interpreted intent and applied filters for audit and response evidence.

#### Scenario: Canonical concepts are resolved
- **WHEN** the question uses citizen language or an approved alias for an amendment, beneficiary, year, state or execution value
- **THEN** the system maps it to the corresponding governed concept or asks for clarification when the mapping is ambiguous

### Requirement: Generated SQL is validated before execution

The system MUST validate every generated query before execution. Validation MUST allow only one read-only `SELECT` statement against approved schemas and tables, with bounded rows and execution time, and MUST reject DDL, DML, privilege operations and multiple statements.

#### Scenario: Safe query executes
- **WHEN** the generated query is a single approved `SELECT` with valid filters and limits
- **THEN** the system executes it using read-only database credentials and returns the structured result

#### Scenario: Unsafe query is rejected
- **WHEN** the generated query contains an update, destructive command, unauthorized relation, multiple statement or missing safety bound
- **THEN** the system rejects it before database execution and records the validation reason

### Requirement: Answers carry structured evidence

The system MUST return an evidence payload containing the original question, interpreted intent, structured results, source metadata, filters applied, query scope, data freshness and limitations. Generated prose MUST NOT be the sole representation of evidence.

#### Scenario: Traceable answer
- **WHEN** a governed query returns sufficient results
- **THEN** the response includes the answer data, source identifier or link when available, filters, query scope, freshness and evidence summary

### Requirement: Insufficient evidence is explicit

The system MUST refuse to invent values, entities, dates, relationships or documents when the authorized evidence is missing, ambiguous or insufficient.

#### Scenario: No matching records
- **WHEN** a safe query returns no matching record
- **THEN** the response states that no supported evidence was found and does not fabricate a value or explanation

#### Scenario: Ambiguous question
- **WHEN** a question has multiple plausible entities, periods or measures
- **THEN** the system asks a clarifying question or states the unresolved ambiguity before presenting a factual answer

### Requirement: Follow-up questions preserve session context

The system MUST support follow-up questions within the active session while keeping conversational context separate from authoritative evidence. A follow-up MUST reuse only prior filters and concepts that are unambiguous and still compatible with the current request.

#### Scenario: Follow-up narrows the previous query
- **WHEN** the user asks which of the previously returned municipalities received health resources
- **THEN** the system carries forward the unambiguous session context and produces a new governed query

#### Scenario: Context is insufficient
- **WHEN** a follow-up refers to an entity or filter not uniquely identified by the session
- **THEN** the system asks for clarification instead of guessing

### Requirement: Security and AI interactions are auditable

The system MUST record an anonymized request identifier, prompt, classification, query plan, validation result, source references, model/provider metadata, response status and relevant errors. Logs MUST NOT expose database credentials or unnecessary personal data.

#### Scenario: Successful interaction is logged
- **WHEN** a supported question produces an answer
- **THEN** an audit record links the request to its classification, validated query, evidence sources and response outcome

#### Scenario: Injection attempt is blocked
- **WHEN** a user attempts prompt injection, requests internal prompts or attempts to bypass SQL restrictions
- **THEN** the request is blocked or safely refused and the security-relevant outcome is logged without revealing protected instructions

### Requirement: The web experience exposes evidence accessibly

The web client MUST present the conversational answer, structured results, sources, limitations and refusal states responsively. The experience MUST support keyboard navigation, semantic structure and screen-reader-readable status and error feedback.

#### Scenario: Answer is rendered
- **WHEN** the API returns a successful evidence payload
- **THEN** the client renders the answer, tabular result or supported visualization data, sources and limitations without parsing generated prose

#### Scenario: Error or refusal is rendered
- **WHEN** the API returns clarification, refusal or validation failure
- **THEN** the client renders an understandable message and an accessible status for assistive technology
