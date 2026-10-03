# ADR-001 — PostgreSQL para dados estruturados

Status: Aceito para a arquitetura inicial; implementação pendente.
Data: 2026-10-03.

## Contexto

Valores, agregações e filtros do Portal da Transparência exigem semântica
relacional e proveniência. A sprint favorece uma infraestrutura simples.

## Decisão

Usar PostgreSQL 17 como banco inicial, com dados oficiais normalizados e uma
camada semântica governada. Versionar migrações com Flyway. Usar pgvector para
embeddings de textos oficiais quando o recorte de RAG for implementado.
Não converter dados tabulares indiscriminadamente em embeddings.
Validar a extensão e fixar sua versão/imagem antes de provisionar o ambiente.
Usar Testcontainers para integração com o mesmo major do PostgreSQL e a extensão.

## Consequências e alternativas

Mantém consultas precisas e busca textual em uma infraestrutura inicial.
Exige governança de migrações, índices e revisão de desempenho.
Banco vetorial separado e outro banco relacional ficam adiados até necessidade
demonstrada. Nenhum schema, migração ou ambiente foi criado neste ADR.
