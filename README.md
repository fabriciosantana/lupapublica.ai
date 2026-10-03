# LUPA — Linguagem Unificada para Pesquisa e Análise

Assistente conversacional para explorar dados oficiais do Portal da Transparência
com respostas verificáveis, fontes e limitações explícitas.

## Estado atual

Repositório em preparação: contexto, decisões de arquitetura, diretórios de ativos
e CI de integridade. Não há aplicação, ingestão, consultas verificadas, avaliação
de IA ou demonstração funcional implementadas. A estrutura não comprova atendimento
ao RFI nem experiência comercial anterior.

## Stack inicial definida

| Área | Decisão |
|---|---|
| Backend / API | Java 21, Spring Boot 3.x, REST, Maven |
| Frontend | Next.js, TypeScript |
| Dados | PostgreSQL 17; pgvector para recuperação textual quando necessária |
| Migrações | Flyway |
| Testes backend | JUnit 5, Testcontainers |
| Testes frontend | Vitest, Playwright |
| Ambiente local | Docker Compose |
| Observabilidade | OpenTelemetry e logs estruturados |
| LLM | OpenAI inicialmente, por uma abstração de provedor |

As versões exatas de bibliotecas, Node.js e imagens serão fixadas e verificadas na
primeira mudança de implementação; não há manifests ou lockfiles fictícios.

## Organização

- `docs/PROJECT_CONTEXT.md`: contexto completo, prioridades e plano de cinco dias.
- `docs/rfi/`: cópia de referência do RFI; original em `docs/` preservado.
- `docs/architecture/decisions/`: ADRs aceitos para a arquitetura inicial.
- `docs/evidence/`: futura rastreabilidade RFI → OpenSpec → teste → evidência.
- `openspec/config.yaml`: contexto, regras de artefatos e operações.
- `openspec/specs/` e `openspec/changes/`: sem requisitos ou changes inventados.
- `data/semantic/`: futuro Semantic Transparency Model.
- `data/verified-queries/`: futuro catálogo de perguntas e SQL validados.
- `data/evaluation/`: futuro conjunto de avaliação com referências verificáveis.
- `backend/`, `frontend/`, `infrastructure/`: diretórios reservados.
- `.github/workflows/ci.yml`: verificação da preparação do repositório.

## Fluxo de trabalho

Leia `AGENTS.md`, o contexto e o RFI antes de propor a primeira mudança OpenSpec.
Siga explore → propose → apply → verificar → archive, conforme as skills instaladas.
Priorize uma pergunta real, dados oficiais, camada semântica, consulta validada,
execução somente leitura e resposta com evidência. Não crie todas as capabilities
antecipadamente.

## Configuração futura

Copie `.env.example` para `.env` somente quando a implementação consumir essas
variáveis. O arquivo é um contrato inicial proposto, não configuração executável.
Use credenciais distintas para migração, ingestão e consultas de IA; nunca exponha
segredos ao frontend ou ao modelo.

Ainda não existem comandos de build, inicialização ou Docker Compose. Eles serão
documentados quando existirem aplicação e ambiente executáveis.

## CI e validação local

A CI verifica YAML, arquivos/diretórios esperados, integridade da cópia do RFI,
links Markdown locais e erros de whitespace. Não executa testes de aplicação.
O verificador pode ser executado com PowerShell 7:

```powershell
pwsh -NoProfile -File infrastructure/check-repository.ps1
git diff --check
```

A validação YAML na CI usa PyYAML 6.0.2. Quando houver aplicação, a mesma mudança
deve adicionar build/testes reais de Java e frontend e fixar suas dependências.

## Licença

Nenhuma licença de distribuição foi definida. A titularidade e os termos de uso
devem ser decididos explicitamente antes de distribuir o produto.
