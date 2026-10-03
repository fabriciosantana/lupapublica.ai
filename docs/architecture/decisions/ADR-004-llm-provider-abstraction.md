# ADR-004 — Abstração de provedor LLM

Status: Aceito para a arquitetura inicial; implementação pendente.
Data: 2026-10-03.

## Contexto

O domínio, a validação SQL e o contrato de evidência devem permanecer
independentes do SDK e dos formatos específicos de um fornecedor.

## Decisão

Definir uma fronteira pequena para geração e, quando necessário, embeddings,
com entradas/saídas tipadas e erros normalizados. Implementar inicialmente
um único adaptador OpenAI. Selecionar e fixar modelos na mudança de implementação,
após validar disponibilidade, custo, compatibilidade e políticas de dados.
A troca do modelo de embeddings exige controle de versão e reindexação.

Configurar segredos fora do Git, timeouts, orçamento de retries e telemetria
sanitizada. Enviar somente dados necessários; não transmitir credenciais,
dados privilegiados ou evidência fora do escopo autorizado.
Avaliar mudanças de modelo/prompt com o dataset versionado.

## Consequências e alternativas

Contém dependências do fornecedor sem exigir vários adaptadores na sprint.
Mocks apoiam testes determinísticos; avaliações reais devem distinguir
resultados simulados de resultados de provedor. Integração direta no domínio
e múltiplos providers antecipados são adiados. Nenhum adaptador existe ainda.
