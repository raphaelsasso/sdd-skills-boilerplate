# Feature Prompt Template

<task>[Feature name]</task>

<role>
    [Describe the agent's role and the task context.
    E.g.: You are a senior full stack developer specialized in [technology] and you are working on the <task> using [API/service]]
</role>

<requirements>
    ### Business

    [Business requirements -- what the end user needs.
    List each requirement as a clear, verifiable bullet point.]

    - ...
    - ...

    ### Technical

    [Technical constraints -- where to implement, how components communicate, which APIs to use.]

    - ...
    - ...

    ### UI/UX

    [Interface requirements -- responsiveness, interactions, visual feedback, loading/error states.]

    - ...
    - ...

</requirements>

<endpoints>
    ### External APIs

    [URLs and descriptions of third-party APIs consumed, if any.]

    - ...

    ### Backend

    [Backend endpoints with method, path, status codes, and payload.]

    <!-- Example:
    GET /api/resource?param=value

    Status Code:
    200: Success
    400: Missing data
    404: Not found

    Payload: { ... }
    -->

</endpoints>

<tests>
    ### Validation

    [Validation strategy -- how to verify the implementation works.
    E.g.: curl for endpoints, render testing, state verification.]

    - ...
    - ...

</tests>

<critical>
    ### Required Skills

    [Skills that must be activated for this feature.
    List each skill with a brief reason.]

    - ...

    ### Out of Scope

    [What should NOT be implemented. Be explicit to avoid scope creep.]

    - ...

</critical>
