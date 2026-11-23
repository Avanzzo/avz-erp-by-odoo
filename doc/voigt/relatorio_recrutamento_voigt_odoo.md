# Relatório de aderência do Recrutamento do Odoo ao processo admissional da Voigt

**Análise funcional e plano de implantação**  
**Data:** 16 de novembro de 2026  
**Idioma:** português do Brasil  
**Escopo:** repositório `Kezpo-Solutions-Br/voigt-erp-by-odoo` e pasta Google Drive `ArtefatosVoigt/0-PROCESSO_ADMISSIONAL`.

## 1. Resumo executivo

O módulo oficial `hr_recruitment` oferece uma base consistente para publicar/organizar vagas, registrar candidatos, acompanhar uma esteira Kanban, atribuir recrutadores e entrevistadores, agendar reuniões, guardar anexos, registrar origem, acompanhar atividades, recusar candidatos com motivo e vincular o selecionado a um empregado. O código do repositório também inclui etapas configuráveis por vaga/empresa, modelos de e-mail por etapa e propriedades customizáveis para candidatos e vagas.

**A conclusão é que o módulo oficial, sozinho, não cobre integralmente o processo documentado da Voigt.** Ele é suficiente para o fluxo de atração e seleção mais comum. A Voigt possui requisitos de governança e passagem de fase que não são satisfeitos por uma movimentação manual no Kanban: solicitação formal RQ 077 e aprovações, conferência rastreável de requisitos da Matriz de Competências, entrevistas por papéis, avaliação escolar QAE 01/02 com pontuação e liberação condicional, controles de documentos RQ 052, aptidão ocupacional sem armazenar diagnóstico, socialização RQ 006 com responsáveis e evidência “PRÁTICO”, e avaliação durante o contrato de experiência.

**Recomendação:** usar o padrão para a esteira e os recursos nativos; configurar um addon isolado `voigt_hr_recruitment` para requisição, checklists, avaliações e bloqueios de transição; integrar a contratação concluída ao cadastro de empregado e ao treinamento introdutório. Manter anexos/documentos e informações de saúde sob grupos de acesso restritos. O relatório não afirma que o addon já existe ou está implantado.

## 2. Fontes e limites da análise

### Repositório

Foi consultado o repositório [voigt-erp-by-odoo](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/tree/main), em especial:

- [README.md](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/blob/main/README.md), que identifica a base como Odoo;
- [odoo/release.py](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/blob/main/odoo/release.py), que no `main` consultado declara série 20.0;
- [manifesto do módulo `hr_recruitment`](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/blob/main/addons/hr_recruitment/__manifest__.py);
- modelos [hr.applicant](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/blob/main/addons/hr_recruitment/models/hr_applicant.py), [hr.job](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/blob/main/addons/hr_recruitment/models/hr_job.py), [hr.recruitment.stage](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/blob/main/addons/hr_recruitment/models/hr_recruitment_stage.py), e dados padrão [hr_recruitment_data.xml](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/blob/main/addons/hr_recruitment/data/hr_recruitment_data.xml).

O branch `main` é mutável. A análise do código não comprova qual commit, versão, edição, módulos instalados ou configuração está rodando no ambiente produtivo da Voigt. Antes de iniciar, confirmar versão e edição do banco em uso, fixar um commit/versão suportada e desenvolver contra a mesma série.

### Google Drive

A pasta analisada é [0-PROCESSO_ADMISSIONAL](https://drive.google.com/drive/folders/1KGn9FOOWFUX3dC_PkdashI38_bm5-3Hy), dentro de [ArtefatosVoigt](https://drive.google.com/drive/folders/1xG_JtIWF0sVT45TMwliULYxTrGiJBh_a). Foram considerados principalmente:

- **PO 017 – Admissão, Demissão e Treinamento, Rev. B, 28/10/2020**: processo formal, papéis, sequência de recrutamento/seleção, socialização, experiência e registros;
- **RQ 077 – Solicitação de Admissão, Rev. A**: dados da necessidade, tipo de vaga, justificativa, horário/faixa salarial e aprovações;
- **RQ 052 – Documentos para Admissão, Rev. B**: checklist de documentos e providências administrativas;
- **RQ 079/QAE 01 e RQ 081/QAE 02**: questionários de adequação/confirmação de escolaridade, critérios de pontuação e opção “Liberado Condicional”;
- **RQ 006 – Treinamento Introdutório**: etapas administrativas, segurança, qualidade, treinamento operacional, avaliação de habilidades/atitudes e parecer;
- **roteiro de entrevista para auxiliar de produção** e descrições de vaga de produção, incluindo a versão atualizada em 08/01/2026;
- demais pastas de fornecedores e divulgação, usadas como evidência de canais externos e formas variadas de recrutamento.

Parte dos documentos de SGQ é de 2020; há arquivos antigos, revisões e versões de vagas diferentes. Tratar os formulários como evidência do processo documentado, não como confirmação de que todos os detalhes ainda estão vigentes. A área de RH, Segurança do Trabalho, Qualidade e Departamento Pessoal deve validar as versões atuais antes da configuração definitiva.

A documentação de entrevista antiga pergunta idade, estado civil, filhos, moradia e problemas de saúde. Esses itens não devem ser transpostos automaticamente para formulários digitais. A Voigt deve revisar finalidade e base legal, minimizar dados pessoais e tratar dados de saúde como dados sensíveis, com acesso restrito. Aptidão ocupacional deve ser tratada pelo profissional competente; o recrutador deve registrar somente a conclusão/aptidão necessária ao fluxo, nunca diagnóstico ou prontuário.

## 3. Processo admissional Voigt extraído das fontes

A PO 017 descreve o fluxo abaixo. Os registros/formulários associados aparecem entre parênteses.

1. **Abertura da necessidade e aprovação:** área solicitante formaliza cargo, tipo de vaga, motivo, jornada e referência salarial; responsável da área e diretoria aprovam (RQ 077).
2. **Atração e captação:** currículos, indicação interna, SINE, consultorias, anúncios em murais, mídias sociais e banco de currículos mantido por RH/PA 01.
3. **Triagem e aderência:** RH compara currículo e evidências com requisitos da vaga e Matriz de Competências (TAB 01). Quando a escolaridade não puder ser comprovada, usar o processo de adequação QAE apropriado (RQ 079 ou RQ 081).
4. **Entrevista preliminar:** RH e/ou Direção avaliam requisitos definidos na matriz; candidatos aderentes seguem ao gestor requisitante.
5. **Entrevista técnica:** gestor/liderança avalia conhecimentos e experiência; o resultado é devolvido ao RH.
6. **Avaliações e entrevistas internas:** encaminhamento ao médico do trabalho; conferência e controle documental (RQ 052); entrevistas com Diretor Industrial e Gerência Administrativa; avaliação/atividade com Psicóloga Organizacional, quando aplicável.
7. **Exames e decisão:** médico do trabalho indica exames conforme PCMSO e legislação. Se exame ou documentação essencial for NOK, interromper a admissão e selecionar outra candidatura. Aprovados recebem proposta/contrato de experiência, normalmente 45 + 45 dias.
8. **Socialização antes do posto:** RQ 006 registra treinamentos administrativos, RH, Qualidade e Segurança; depois treinamento operacional “on the job”, líder ou “Anjo da Guarda”, fichas técnicas/especificações e análise de habilidades/atitudes.
9. **Liberação para atividade:** trabalhador não atua em turno/atividade sem supervisão direta enquanto o item “PRÁTICO” do RQ 006 não estiver concluído.
10. **Acompanhamento e efetivação:** avaliação após uma semana completa e nova avaliação em 30 ou 45 dias quando necessária; ao fim da experiência, gestor/liderança e RH registram avaliação final e efetivação, restrição, adequação ou encerramento. Evidências são arquivadas no prontuário funcional.

A pasta também mostra processos por fontes próprias e terceiros (RH Nossa, RH Center, Imediatta, Empregga, TelRh, Grupo Guia RH e outros) e controles de vagas. O Odoo deve guardar a origem e o responsável, sem pressupor que todos os fornecedores forneçam dados no mesmo formato.

## 4. Aderência funcional

| Necessidade da Voigt | Recurso padrão do Odoo observado | Aderência | Tratamento recomendado |
|---|---|---:|---|
| Cadastrar vaga, departamento, empresa, recrutador, gestor, número de vagas e requisitos | `hr.job`, campos de departamento, recrutador, empresa, requisitos, vagas esperadas e contagens | Alta | Configurar posições e departamentos; usar descrições padronizadas e responsável requisitante. |
| Captar candidatos por formulário, e-mail, inclusão manual, indicação ou canais | `hr.applicant`, alias de e-mail, formulários/web quando habilitados, fontes e UTMs; candidaturas manuais | Alta, com configuração | Cadastrar canais e aliases; integração com terceiros depende do serviço/API e não foi comprovada. |
| Esteira de seleção com etapas, e-mail automático, prazos e motivo de recusa | `hr.recruitment.stage`, template de e-mail, atividades, estado Kanban, motivos de recusa e tempo por etapa | Alta para acompanhamento; média para controle | Configurar etapas por perfil de vaga e e-mails. Criar atividades com responsáveis/prazos. O padrão não impõe todas as regras impeditivas da Voigt. |
| Triagem por Matriz de Competências TAB 01 | Requisitos e propriedades configuráveis na vaga/candidatura | Parcial | Propriedades bastam para anotações simples. Addon para itens versionados, evidências, avaliação, decisão condicional e trilha de auditoria. |
| Entrevistas RH, liderança, Direção, gerência e psicóloga | Entrevistadores, reuniões de calendário, atividades e anexos | Parcial | Agendar reuniões nativamente; addon para formulários de avaliação distintos, parecer, conclusão e gate por etapa. |
| QAE 01/02 com notas, corte 60/100 e aprovação condicional | Campos genéricos, notas e anexos; não foi identificada regra nativa de pontuação para esses RQs | Baixa | Addon com modelos de questionário e rubrica versionados, cálculo auditável, resultado Apto/Inapto/Condicional e aprovação com justificativa. Não perpetuar as perguntas discriminatórias/irrelevantes sem revisão. |
| RQ 052 com checklist por tipo de vaga, evidência e pendência | Anexos e propriedades/campos genéricos | Parcial | Addon com lista de requisitos parametrizada por perfil, estado de entrega/verificação, vencimento, responsável, motivo de dispensa e acesso restrito. |
| Encaminhamento a médico/exames PCMSO | Reuniões, atividades e anexos | Parcial | Registrar encaminhamento, data e resultado mínimo de aptidão, sob grupo restrito. Não armazenar dados clínicos; confirmar requisitos com médico do trabalho/DPO/jurídico. |
| Requisição RQ 077, justificativa, tipo e cadeia de aprovações | Vaga pode guardar detalhes; não foi encontrada entidade de requisição formal e aprovações requisitadas pela Voigt | Baixa | Addon cria `voigt.recruitment.request`, aprovações e número de controle. A vaga pode ser criada após aprovação ou relacionada à requisição. |
| Contrato de experiência e conversão para empregado | Estágio de contratação e vínculo candidato/empregado; integração com RH | Parcial/Alta | Usar o estágio contratado e a criação/vínculo de empregado. Configurar prazos 45+45 e alertas; complemento para agenda e avaliação final caso o módulo HR instalado não cubra. |
| RQ 006, treinamento administrativo e operacional, anjo da guarda e “PRÁTICO” | Anexos, reuniões, atividades; outros módulos de RH podem oferecer capacitação, mas não comprovam o controle específico da Voigt | Baixa/parcial | Addon com checklist de integração e liberação; vincular registros do app de Treinamentos caso esteja instalado. Impedir liberação da atividade sem etapa prática aprovada. |
| Avaliações de 1 semana, 30/45 dias e fim de experiência | Atividades e alertas | Parcial | Planejar atividades via addon, com datas calculadas da admissão, formulário e decisão registrada. |
| Acesso restrito e segregação de dados | Grupos de recrutamento/entrevistador e ACL padrão | Parcial | Rever ACL e regras por empresa; criar grupos para RH, gestor, Segurança/medicina e DP; limitar documentos por categoria e etapa. Testar acessos negativos. |
| Métricas por vaga, etapa, fonte, prazo, conversão e contratação | Contagens, duração de etapa, relatórios nativos e fontes | Alta para métricas básicas | Configurar indicadores e validar definição de cada KPI; addon apenas para indicadores de requisição, conformidade e bloqueios. |

**Decisão de cobertura:** a base cobre a gestão visual e operacional do recrutamento, porém não implementa por padrão os documentos formais e as travas de conformidade da PO 017. Configuração apenas é apropriada se a Voigt aceitar controles manuais sem bloqueio; para reproduzir o fluxo formal, construir o addon é recomendado.

## 5. Configuração do Odoo padrão

Executar primeiro em uma base de teste na mesma versão/edição de produção.

1. Instalar **Recrutamento** (`hr_recruitment`) e dependências gerenciadas pelo manifesto. Confirmar **Funcionários** (`hr`) e **Calendário**; instalar Website/Survey/Recruitment Survey ou outros somente se o licenciamento e o processo exigirem.
2. Configurar empresa, departamentos, responsáveis e grupos: Gestor de Recrutamento, Recrutador/RH e Entrevistador. Não conceder acesso amplo ao cadastro de empregados ou documentos sensíveis por conveniência.
3. Criar estágios iniciais: `Nova candidatura`, `Triagem RH`, `Entrevista RH/Direção`, `Entrevista técnica`, `Avaliações internas`, `Aptidão ocupacional`, `Documentos admissionais`, `Proposta e contrato`, `Contratado`, `Recusado/Encerrado`. Configurar sequências, visibilidade por vaga, dias de alerta/“rot”, templates e motivos de recusa. Algumas fases devem ser controladas pelo addon antes de marcar “pronto”.
4. Criar posições por área/cargo; preencher responsável, número de vagas, requisitos realmente necessários, descrição atual, departamento e jornada. Cadastrar fontes: indicação, SINE, mural, redes sociais, consultoria/fornecedor (com suborigem quando útil), candidatura direta.
5. Preparar modelos de mensagem para recebimento, convite, instruções de entrevista, pendência documental, proposta e encerramento. Não enviar comunicação automática até validar linguagem, destinatários e regras de consentimento/retensão.
6. Definir atividades padrão: triagem, entrevista com RH, entrevista técnica, entrevistas de aprovação, retorno de avaliação e checagem de pendências. Usar atividades para prazo e lembretes, sem confundir lembrete com bloqueio de negócio.
7. Testar inclusão manual, e-mail alias e formulário público, se usados. Validar o que fica público e não solicitar documentos admissionais sensíveis no formulário aberto.
8. Acompanhar indicadores nativos e documentar o procedimento de operação. Não migrar as planilhas com dados pessoais para uma base de teste real; use candidatos fictícios/anônimos.

## 6. Especificação do addon `voigt_hr_recruitment`

### 6.1 Escopo e arquitetura

Criar módulo independente em repositório de addons customizados, com dependências explícitas em `hr_recruitment` e `hr`. Se outro módulo Voigt já possuir arquitetura de RH, alinhar antes de abrir um addon redundante. Não alterar arquivos nativos do Odoo; usar herança (`_inherit`), views herdadas, ACL, regras de registro, dados XML e migrações. Manter regras de negócio no servidor para que importação/API/UI não possam ignorar as validações.

Estrutura inicial sugerida:

```text
voigt_hr_recruitment/
  __init__.py
  __manifest__.py
  models/
    recruitment_request.py
    hr_applicant.py
    applicant_assessment.py
    applicant_document.py
    onboarding.py
  security/
    groups.xml
    ir.model.access.csv
    record_rules.xml
  data/
    sequences.xml
    activity_plans.xml
    mail_templates.xml
  views/
    recruitment_request_views.xml
    hr_job_views.xml
    hr_applicant_views.xml
    assessment_views.xml
    onboarding_views.xml
  tests/
    test_request.py
    test_stage_gates.py
    test_assessment.py
    test_documents.py
    test_onboarding.py
```

### 6.2 Entidades e campos

**`voigt.recruitment.request` (RQ 077 digital):** número sequencial, empresa, área/departamento, cargo, tipo (efetivo/temporário/estágio), motivo (aumento/substituição/outro), justificativa, vaga substituída quando aplicável, jornada, faixa salarial/referência, quantidade, requisitante, diretor aprovador, datas, estado (`draft`, `to_approve`, `approved`, `rejected`, `cancelled`, `in_recruitment`, `filled`). Relacionar com uma ou mais vagas/candidaturas sem criar vaga pública antes da aprovação. Aprovação deve registrar usuário, horário, comentário e transição.

**Extensão de `hr.job`/`hr.applicant`:** relação com requisição, identificador do processo, tipo de contratação, versão da matriz usada, marcações objetivas de avaliação e resultado das entrevistas. Evitar guardar um segundo cadastro de candidato; `hr.applicant` permanece o registro mestre enquanto a candidatura está ativa. Verificar duplicidade usando o comportamento nativo e regras de consolidação.

**`voigt.applicant.assessment`:** candidato, etapa/tipo de avaliação (RH, técnica, diretoria, QAE 01/02, psicológica — somente status/parecer permitido), avaliador, modelo/revisão, itens de critério, notas, total calculado, resultado, justificativa, data e estado. Para QAE, manter a pontuação explicável conforme RQ vigente: QAE 01/02 registra pesos e corte definido no formulário; resultado condicional exige justificativa e aprovação autorizada. Não fixar o corte em código se o documento controlado puder mudar; versionar rubrica.

**`voigt.applicant.document`:** candidato, tipo de documento, aplicabilidade, estado (`not_requested`, `requested`, `received`, `verified`, `waived`, `rejected`, `expired`), data, responsável pela verificação, anexo, validade, observação mínima e motivo de dispensa. A configuração de checklist varia por perfil (administrativo/produção) e exigência legal atual. Evitar dados de dependentes antes de necessidade legal e fase apropriada. Não copiar automaticamente todos os itens antigos do RQ 052.

**`voigt.onboarding`:** candidato/empregado, data de admissão, função/setor, checklist administrativo, RH, Qualidade, Segurança e on-the-job; instrutor/responsável por cada tópico; líder e “Anjo da Guarda”; itens de habilidade/atitude com escala definida; treinamento técnico; estado prático; parecer; avaliações planejadas após 1 semana, 30/45 dias e conclusão do período de experiência. Ao concluir a contratação, criar/vincular empregado usando os métodos de negócio do módulo instalado, sem duplicar `hr.employee`.

### 6.3 Regras de transição e consistência

- Requisição só pode ir a `approved` depois das aprovações obrigatórias e campos requeridos; alteração material após aprovação retorna para nova aprovação.
- Candidatura não pode avançar para entrevista técnica sem triagem concluída; entrevistas internas dependem do parecer anterior previsto pela PO 017.
- Fase de exames/documentos exige encaminhamento e checklist aplicável. A decisão de aptidão é registrada por pessoa/grupo autorizado e apenas com resultado mínimo necessário. `NOK` encerra/recusa o candidato com motivo e trilha; não expõe informação clínica a entrevistadores.
- Fase de contrato exige aprovações necessárias, aptidão aprovada, documentos obrigatórios completos/verificados e atendimento da matriz ou aprovação condicional autorizada com justificativa.
- “Liberado Condicional” exige motivo, assinatura eletrônica identificável no registro (usuário e data) e grupo de aprovadores autorizado. Nunca permitir que um comentário genérico substitua aprovação.
- O estágio de contratação cria atividades de integração e prazos de experiência. Não marcar “contratado/efetivado” antes da confirmação da gestão e do RH.
- O empregado não pode receber liberação `sem supervisão` para atividade enquanto o item `PRÁTICO` não estiver aprovado. Registrar quem liberou, quando e evidência.
- Restringir `unlink` ou alteração retroativa de evidências aprovadas; correções devem gerar histórico/chatter e manter trilha.
- Usar constraints Python para invariantes no modelo, validações em métodos de ação para operações de negócio e ACL/record rules para autorização. `onchange` serve apenas à interface e não substitui validação de servidor.

### 6.4 Segurança e proteção de dados

- Definir grupos mínimos: `Voigt RH Recrutamento`, `Voigt Gestor Requisitante`, `Voigt Entrevistador`, `Voigt DP/Admissão`, `Voigt Saúde Ocupacional` (se aplicável) e `Voigt Administrador funcional`.
- Entrevistador acessa somente candidaturas da vaga e pareceres necessários; não vê documentos admissionais, salário restrito, dados de dependentes ou notas clínicas.
- Dados de saúde e exames devem ficar fora do registro comum de recrutamento, ou em integração/sistema restrito. Armazenar no candidato apenas a informação de aptidão/encaminhamento estritamente necessária.
- Configurar política de retenção, descarte/anonimização de candidaturas não contratadas, registro de origem e transparência ao candidato. O prazo/base legal devem ser validados por jurídico/DPO; não presumir consentimento amplo.
- Rever formulário antigo de entrevista: idade, família, moradia e saúde são desnecessários ou potencialmente discriminatórios para muitas vagas. Usar perguntas consistentes e ligadas às atividades essenciais, com análise de Segurança do Trabalho e RH. Critérios como capacidade física, barba ou uso de óculos devem ser validados para necessidade ocupacional, acessibilidade, alternativas razoáveis e legislação aplicável; não configurar como filtro automático de candidatura.
- Habilitar auditoria de mudanças/acessos conforme política do ambiente. Proteger backups e anexos, usar TLS, política de acesso por empresa e gestão de usuários de terceiros.

### 6.5 Integrações e relatórios

- E-mail/website/aliases: manter uso dos recursos Odoo; limitar captura a dados necessários.
- Fornecedores de recrutamento: começar por registro de origem e importação controlada. Integração API só depois de validar contrato, finalidade, campos, duplicidade, segurança e exclusão/retificação de dados.
- Indicadores: requisições abertas e aprovadas, tempo da aprovação até preenchimento, candidatos por origem/etapa, conversão e desistência, pendências por tipo, tempo aguardando retorno, candidaturas condicionais, vagas canceladas e cumprimento de avaliações de experiência. Definir numerador/denominador e regras de anonimização para relatórios de pessoas.

## 7. Plano de construção e implantação

1. **Descoberta e decisão:** confirmar versão/edição Odoo efetiva, módulos instalados, processo atual com RH/DP/gestores/Segurança/Qualidade, TAB 01 vigente, formulários atuais, dados a reter, papéis, limites de acesso e integração com fornecedores.
2. **Especificação aprovada:** transformar a PO 017 e formulários vigentes em fluxograma, dicionário de dados, matriz de permissão, tabela de campos obrigatórios por fase, eventos de auditoria e critérios de aceite. Resolver divergências entre revisões.
3. **Configuração padrão:** preparar fases, cargos, fontes, atividades e modelos de e-mail em base de desenvolvimento; validar com RH e liderança.
4. **Implementação incremental:** construir primeiro RQ 077 + aprovação; depois entrevistas/QAE e checklist; por fim onboarding/PRÁTICO/prazos. Entregar cada bloco com teste automatizado e demonstração.
5. **Qualidade do código:** seguir guia de estilo do Odoo e Python, manter módulos pequenos, nomes explícitos, traduções com `_()`, ORM e `Command` em vez de SQL cru, campos `tracking=True` onde apropriado, `@api.constrains` para invariantes, `check_company`/domínio quando multempresa, evitar `sudo()` sem motivo, evitar lógica em views/onchange, validar ACL/record rules e não duplicar lógica entre controllers e models.
6. **Revisão de segurança e privacidade:** testar matriz de acesso positiva/negativa, formulários públicos, anexos e exportações; revisar retenção e descarte. Revisar perguntas de entrevista e filtros de vaga com áreas responsáveis.
7. **Migração piloto:** importar apenas vagas/candidaturas em andamento necessárias, com mapeamento e deduplicação. Manter documentos históricos em repositório controlado se não houver base legal/necessidade de migração; executar reconciliação por contagem e amostra.
8. **UAT:** RH, gestores, DP e Segurança percorrem cenários completos com dados fictícios. Obter aceite formal e atualizar procedimento operacional/SOP e treinamento dos usuários.
9. **Produção:** backup validado, janela de implantação, addon empacotado com versão/tag, migração repetível, plano de reversão, monitoramento de logs e canal de suporte. Não instalar diretamente em produção sem ensaio de restauração e compatibilidade da versão.
10. **Operação:** revisar indicadores, regras de acesso, documentos, matriz e rubricas periodicamente; atualizar testes quando a PO/RQ mudar.

## 8. Plataforma de desenvolvimento e testes

### Ambientes

- **Desenvolvimento local:** checkout fixado na série/commit igual ao ambiente alvo; PostgreSQL compatível; addons customizados em diretório separado; configuração local sem credenciais de produção. Usar `.env`/secret manager fora do Git.
- **CI:** serviço efêmero de PostgreSQL e instalação limpa do addon em cada PR; testes automatizados; lint/format/type checks apropriados ao projeto; relatório de cobertura orientado a regras críticas. Nunca executar teste com base produtiva.
- **Staging/UAT:** cópia anonimizada ou base sintética, acessos por grupo, envio de e-mail em sink/test server, sem publicação de vagas e sem conectores externos habilitados. Snapshot antes da rodada.
- **Produção:** instalar somente artefato aprovado e testado da mesma versão; backup e plano de rollback prontos.

Exemplo de comando para uma instalação de teste (ajustar caminho, executável e versão no projeto; usar banco descartável):

```bash
./odoo-bin \
  --addons-path=addons,custom-addons \
  -d voigt_recruitment_test \
  --init=voigt_hr_recruitment \
  --test-enable \
  --test-tags /voigt_hr_recruitment \
  --stop-after-init
```

Na CI, executar também uma atualização do módulo (`--update=voigt_hr_recruitment`) contra banco de teste já inicializado para cobrir migrações. Confirmar opções compatíveis com a série efetivamente usada. Não aplicar esse comando a banco com dados reais.

### Casos de teste funcionais e automatizados

| ID | Cenário | Resultado esperado |
|---|---|---|
| REQ-01 | Criar RQ 077 incompleta e tentar submeter | Bloqueio com lista de campos pendentes. |
| REQ-02 | Aprovação sem aprovador obrigatório | Transição recusada; trilha sem falsa aprovação. |
| REQ-03 | Aprovar requisição e depois alterar salário/tipo | Reaprovação exigida; histórico preservado. |
| APP-01 | Candidatura via formulário, e-mail e inclusão manual | Cada uma associa-se à vaga/origem correta e entra na etapa configurada. |
| APP-02 | Mesmo candidato entra duas vezes para a mesma vaga | Alerta/controle de duplicidade sem apagar histórico legítimo. |
| APP-03 | Mover para entrevista técnica sem triagem | Bloqueio de servidor, inclusive via import/API. |
| AS-01 | Pontuação QAE abaixo do corte | Resultado calculado corretamente como inapto segundo a versão de rubrica ativa. |
| AS-02 | Nota abaixo do corte com aprovação condicional por perfil autorizado | Exige motivo, aprovador e data; não aceita aprovação por usuário sem papel. |
| AS-03 | Trocar a rubrica após avaliação | Avaliação antiga mantém sua versão e pontuação originais. |
| DOC-01 | Avançar com documento obrigatório ausente/não verificado | Bloqueio e pendências visíveis apenas aos grupos autorizados. |
| DOC-02 | Dispensar documento | Exige justificativa e responsável; auditoria registra a decisão. |
| DOC-03 | Usuário entrevistador tenta abrir documento restrito | Acesso negado; sem URL/arquivo exposto por chatter ou exportação. |
| MED-01 | Médico registra aptidão | Guarda apenas estado e metadados mínimos; entrevistador não vê dado ocupacional restrito. |
| MED-02 | Candidato inapto segundo decisão autorizada | Candidatura encerrada conforme política; sem diagnóstico no motivo visível. |
| ONB-01 | Contratar candidato | Cria vínculo de empregado sem duplicidade e agenda integração/experiência. |
| ONB-02 | Tentar liberar trabalho sem treinamento prático aprovado | Bloqueio; com evidência e aprovador autorizado, permite liberação. |
| ONB-03 | Avaliação semanal e 30/45 dias | Atividades nas datas configuradas, reagendamento justificado e status rastreável. |
| SEC-01 | Recrutador de outra empresa consulta vaga/candidato | Dados isolados por empresa e regras; acesso negado conforme matriz. |
| SEC-02 | Gestor vê candidaturas de sua vaga sem dados restritos de DP | Acesso mínimo necessário. |
| MAIL-01 | Entrar em estágio que possui template de e-mail | E-mail de teste correto, sem envio externo em desenvolvimento/UAT. |
| MIG-01 | Atualizar versão do addon em base de teste | Migração idempotente, sem perda de anexos, histórico ou estado. |
| REG-01 | Recusar/desistência/cancelar vaga | Motivo, responsável, data, comunicação e métricas consistentes. |

Adicionar testes `TransactionCase`/`SavepointCase` para regras de modelo e permissões; usar `Form` para comportamento de formulários quando útil; usar `HttpCase`/tour para fluxo web crítico. Testar também importação, chamadas ORM e operações em lote. Cobrir erro, concorrência de aprovação e tentativa de bypass, não apenas o caminho feliz.

## 9. Critérios de aceite

O addon pode ser considerado pronto para piloto quando:

- RH/DP aprovaram o processo e a versão vigente de cada formulário/rubrica;
- todas as aprovações de RQ 077 e travas críticas têm testes automatizados aprovados;
- os gates de documentação, aptidão mínima e treinamento prático não podem ser contornados pela interface, importação ou API;
- a matriz de acesso foi aprovada e os testes negativos confirmam o bloqueio de anexos e dados restritos;
- o fluxo completo de contratação e integração foi concluído por usuários de RH, liderança, DP e Segurança em staging;
- existe plano de retenção/descarte, comunicação ao candidato, migração, backup e reversão;
- a versão implantada corresponde a um artefato/commit identificado e compatível com o Odoo instalado.

## 10. Referências

- [Odoo 20.0 — Recrutamento](https://www.odoo.com/documentation/20.0/pt_BR/applications/hr/recruitment.html)
- [Odoo 20.0 — Fluxo de recrutamento](https://www.odoo.com/documentation/20.0/pt_BR/applications/hr/recruitment/recruitment_flow.html)
- [Odoo 20.0 — adicionar candidatos](https://www.odoo.com/documentation/20.0/pt_BR/applications/hr/recruitment/add_applicants.html)
- [Código fonte do addon oficial `hr_recruitment`](https://github.com/Kezpo-Solutions-Br/voigt-erp-by-odoo/tree/main/addons/hr_recruitment)
- [PO 017 — pasta de documentos de SGQ consultada](https://drive.google.com/drive/folders/1Tz--_SDfQ5rKMbzZ0Wn-KDSEQGCcZLhA)
- [Pasta do Processo Admissional Voigt](https://drive.google.com/drive/folders/1KGn9FOOWFUX3dC_PkdashI38_bm5-3Hy)

> Este documento é uma análise técnica e funcional para orientar configuração e desenvolvimento. Não substitui a validação do RH, Departamento Pessoal, Segurança e Saúde do Trabalho, Qualidade, jurídico ou encarregado de proteção de dados.
