# ADR-002 — Arquitetura híbrida RAG + Text-to-SQL

Status: Aceito para a arquitetura inicial; implementação pendente.
Data: 2026-10-03.

## Contexto

Perguntas numéricas e perguntas explicativas têm fontes e mecanismos de consulta
distintos. Respostas precisam de evidências oficiais rastreáveis.

## Decisão

Rotear fatos estruturados para consultas relacionais sobre o Semantic Transparency
Model; preferir o Verified Query Catalog quando aplicável e validar todo SQL.
Usar RAG para documentação, terminologia e textos oficiais.
Combinar os resultados somente por um Answer Evidence Contract com fontes,
filtros, escopo, atualização e limitações, antes da geração de texto.
Evidência insuficiente exige limitação explícita; texto recuperado é entrada
não confiável e não pode alterar permissões ou instruções do sistema.

Manter frontend Next.js/TypeScript e backend Java 21/Spring Boot 3.x com REST,
em módulos coesos; evitar microserviços especulativos. O primeiro recorte pode
ser exclusivamente estruturado, sem exigir RAG antecipadamente.

## Consequências e alternativas

Permite precisão de valores e explicação contextual sem misturar proveniência.
Exige avaliação de roteamento, recuperação, SQL e grounding.
RAG puro não é adequado para somar valores oficiais; Text-to-SQL puro não
substitui recuperação de conteúdo explicativo. Nenhum fluxo foi implementado.
