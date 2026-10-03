# ADR-003 — Execução SQL somente leitura

Status: Aceito para a arquitetura inicial; implementação pendente.
Data: 2026-10-03.

## Contexto

SQL gerado por LLM é entrada não confiável. SELECT isoladamente não garante
segurança: funções, CTEs com escrita e operações de bloqueio podem causar efeitos.

## Decisão

Antes de executar SQL gerado ou do catálogo, usar parsing/AST com política de
uma única instrução de leitura, schemas/relações permitidos, parâmetros vinculados,
limite de linhas e timeout. Rejeitar DDL, DML, comandos de privilégio, escrita
em CTE, SELECT INTO, bloqueios e chamadas de funções não autorizadas.
Usar usuário de consulta restrito a SELECT nos objetos autorizados e transações
read-only; revisar privilégios herdados/PUBLIC e acesso a funções.
Não confiar em regex ou no prompt como fronteira de segurança.

Separar credenciais de consulta, ingestão e migração Flyway. Credenciais não
podem ser entregues ao LLM ou ao navegador. Logs estruturados/OpenTelemetry
devem registrar validação e desempenho com dados sensíveis sanitizados.

## Consequências e alternativas

Defesa em camadas limita o impacto de geração incorreta ou prompt injection.
Exige testes positivos e adversariais com JUnit 5 e PostgreSQL/Testcontainers.
Só um validador, só um usuário read-only ou instruções de prompt são insuficientes.
Papéis, permissões e validador ainda não foram implementados.
