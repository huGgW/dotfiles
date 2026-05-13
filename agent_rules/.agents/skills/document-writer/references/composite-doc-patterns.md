# Composite Document Patterns

Use these patterns after applying the Diataxis compass. Document-type names are convenient shortcuts, not primary modes. Keep each major section locally aligned with a reader need.

## README

A README is usually a landing page. It should help the reader decide what the project is, whether it matters to them, and where to go next.

Common section mapping:

| Section | Typical mode | Purpose |
| --- | --- | --- |
| What this is | Explanation | Establish purpose and context. |
| Quick start | Tutorial | Give a safe first success, ideally within a few minutes. |
| Common usage | How-to | Help competent users perform common tasks. |
| Configuration | Reference | Describe options, defaults, and constraints. |
| Development setup | How-to or tutorial | Use how-to for existing contributors, tutorial for first-time onboarding. |
| Contributing | How-to | Explain how to make and submit changes. |
| Links | Landing/reference | Point to authoritative docs instead of duplicating them. |

README guardrails:

- Keep the top useful: what it is, why it exists, and the fastest credible path to value.
- Do not turn the README into the entire documentation site.
- Link to complete API, architecture, or operations docs when details would distract most readers.

## API Documentation

API documentation is primarily reference. It can include examples, but examples should illustrate behavior rather than become a tutorial.

Core reference fields:

- Endpoint, method, path, and stability status.
- Authentication and authorization requirements.
- Request parameters, headers, body schema, and validation rules.
- Response schemas, status codes, and error bodies.
- Pagination, filtering, sorting, rate limits, idempotency, and retries when relevant.
- SDK or CLI examples when they reflect supported usage.

Complementary sections:

- Use how-to guides for task goals such as "How to import users" or "How to rotate API keys".
- Use explanation for auth model, consistency model, webhook delivery semantics, or design rationale.
- Use tutorials for first successful API call or first integration.

## Runbook

A runbook is an operational how-to guide. It should help a competent operator respond consistently under pressure.

Recommended structure:

1. When to use this runbook.
2. Preconditions, required access, and safety checks.
3. Diagnosis or confirmation steps.
4. Procedure.
5. Verification.
6. Rollback or mitigation.
7. Escalation criteria and owner.
8. References to dashboards, alerts, logs, and related docs.

Runbook guardrails:

- Keep background short; link to explanation for system context.
- Make commands copyable and scoped to the right environment.
- Include destructive-operation warnings only when they are specific and actionable.
- Avoid inventing ownership, credentials, or escalation paths without source material.

## Architecture Document

An architecture document is usually explanation supported by selected reference facts. Its job is to help readers understand the system, decisions, constraints, and trade-offs.

Useful sections:

- Context and goals.
- Non-goals and constraints.
- System overview and boundaries.
- Major components and responsibilities.
- Data flow, control flow, or lifecycle diagrams.
- Key decisions and trade-offs.
- Integration points and dependencies.
- Operational implications, risks, and open questions.

Architecture guardrails:

- Do not force every architecture document into the same template.
- Prefer diagrams only when they clarify relationships or flows.
- Keep decision catalogs concise; move long rationale into explanation subsections.
- Link to reference docs for complete schemas, APIs, flags, and runtime configuration.

## Onboarding Guide

An onboarding guide combines tutorials, explanation, and links to reference. It should provide a sequence of early successes and a map of the system.

Useful sections:

- What the reader will be able to do after onboarding.
- Environment setup as tutorial or how-to, depending on reader skill.
- First meaningful task with expected output.
- Key systems and how they connect.
- Common workflows.
- Where authoritative references live.
- Who or what process to ask when blocked, if that information is known.

Onboarding guardrails:

- Do not overload day-one docs with every internal detail.
- Prefer progressive disclosure: first success, then deeper map, then task guides.
- Keep setup steps tested against a clean environment when feasible.

## Design Document

A design document is commonly a composite of explanation, decision reference, and implementation planning. Classify each section by what the reader needs.

Useful section mapping:

| Section | Typical mode | Purpose |
| --- | --- | --- |
| Problem/context | Explanation | Explain why the work exists. |
| Goals/non-goals | Reference | Bound the decision space. |
| Constraints | Reference or explanation | State hard facts and explain implications. |
| Options considered | Explanation | Compare alternatives and trade-offs. |
| Proposed design | Explanation | Explain how the design fits the problem. |
| API/schema/config changes | Reference | Describe exact technical surfaces. |
| Rollout/migration plan | How-to | Describe execution sequence. |
| Open questions | Reference | Track unresolved decisions. |

Design doc guardrails:

- Do not impose a rigid template when the problem is small.
- Make decisions traceable, but avoid turning the whole document into a decision table.
- Separate "why this design" from "how to roll it out".

## Problem Analysis Or Incident Writeup

Problem-analysis docs usually explain what happened and why, then provide how-to follow-ups for mitigation.

Useful section mapping:

| Section | Typical mode | Purpose |
| --- | --- | --- |
| Summary | Explanation | Give context and impact. |
| Timeline | Reference | Record facts in order. |
| Root cause | Explanation | Connect causes and contributing factors. |
| Detection and response | Explanation or reference | Explain behavior or record facts. |
| Mitigations | How-to | Define concrete actions. |
| Follow-ups | Reference | Track owners, status, and deadlines when known. |

Problem-analysis guardrails:

- Distinguish facts from interpretation.
- Avoid assigning ownership, blame, or deadlines without evidence.
- Link to runbooks for future operational procedures.

## Documentation Sets And Hierarchies

For larger documentation sets, avoid mechanically creating four top-level boxes. Choose hierarchy based on how readers experience the product.

Possible hierarchy drivers:

- User role or audience.
- Product area or domain.
- Platform or deployment environment.
- Lifecycle stage, such as install, operate, extend, troubleshoot.
- Stability level, such as getting started, production, advanced operations.

Landing pages should be real guides to the documentation, not only long lists. Break up long lists into meaningful groups when navigation becomes hard.
