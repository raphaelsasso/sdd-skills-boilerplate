# Template de Prompt de Feature

<task>[Nome da funcionalidade]</task>

<role>
    [Descreva o papel do agente e o contexto da tarefa.
    Ex: Você é um desenvolvedor full stack senior especializado em [tecnologia] e está fazendo a <task> usando [API/serviço]]
</role>

<requirements>
    ### Business

    [Requisitos de negócio — o que o usuário final precisa.
    Liste cada requisito como um bullet point claro e verificável.]

    - ...
    - ...

    ### Technical

    [Restrições técnicas — onde implementar, como os componentes se comunicam, quais APIs usar.]

    - ...
    - ...

    ### UI/UX

    [Requisitos de interface — responsividade, interações, feedback visual, estados de loading/error.]

    - ...
    - ...

</requirements>

<endpoints>
    ### APIs Externas

    [URLs e descrição de APIs de terceiros consumidas, se houver.]

    - ...

    ### Backend

    [Endpoints do backend com método, path, status codes e payload.]

    <!-- Exemplo:
    GET /api/recurso?param=valor

    Status Code:
    200: Sucesso
    400: Faltam dados
    404: Não encontrado

    Payload: { ... }
    -->

</endpoints>

<tests>
    ### Validação

    [Estratégia de validação — como verificar que a implementação funciona.
    Ex: curl para endpoints, testes de renderização, verificação de estados.]

    - ...
    - ...

</tests>

<critical>
    ### Skills obrigatórias

    [Skills que devem ser ativadas para esta funcionalidade.
    Liste cada skill com uma breve descrição do motivo.]

    - ...

    ### Fora do Escopo

    [O que NÃO deve ser implementado. Seja explícito para evitar scope creep.]

    - ...

</critical>
