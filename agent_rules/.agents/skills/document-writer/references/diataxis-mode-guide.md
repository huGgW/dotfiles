# Diataxis Mode Guide

Use this guide when drafting or revising non-trivial documentation sections. Classify the reader need first, then apply the mode rules.

## Compass

| Question | If yes | If no |
| --- | --- | --- |
| Is the reader trying to act? | Tutorial or how-to | Reference or explanation |
| Is the reader acquiring new capability? | Tutorial or explanation | How-to or reference |

The resulting modes are:

| Mode | Need | Reader question | Form |
| --- | --- | --- | --- |
| Tutorial | Action + acquisition | "Can you teach me to...?" | Lesson |
| How-to guide | Action + application | "How do I...?" | Practical directions |
| Reference | Cognition + application | "What is...?" | Technical description |
| Explanation | Cognition + acquisition | "Why...?" | Discursive understanding |

## Tutorial

A tutorial is a guided learning experience. The reader is not merely trying to finish a task; they are acquiring capability by doing something meaningful and safe.

Use tutorial mode when:

- The reader is new to the product, concept, workflow, or technique.
- Success matters more than coverage.
- A single reliable path is better than real-world variability.
- The output artifact is a vehicle for learning, not the main point.

Write tutorials like this:

- Start by showing where the reader is going: "In this tutorial, we will create..."
- Prefer "we" language to create a guided lesson feel.
- Deliver visible results early and often.
- Show expected output when possible.
- Point out what the reader should notice after important steps.
- Keep the path concrete, particular, and reliable.
- Minimize explanation; link to explanation when the reader needs background.
- Ignore options and alternatives unless they are required for the learning path.
- Test the tutorial by following it from the reader's starting state when feasible.

Avoid in tutorials:

- Exhaustive configuration options.
- Branching paths for many real-world cases.
- Long conceptual digressions.
- Troubleshooting matrices that interrupt the learning flow.
- Promising "you will learn" when the doc can only promise the activity.

Useful tutorial language:

- "In this tutorial, we will..."
- "First, create..."
- "Now run..."
- "The output should look like..."
- "Notice that..."
- "Let's check that..."

## How-To Guide

A how-to guide helps a competent reader achieve a real-world goal. The reader knows what they want and has enough background to work with concise directions.

Use how-to mode when:

- The reader asks "How do I...?"
- The task belongs to real work, not a learning exercise.
- The path may include choices, dependencies, checks, or fallback steps.
- Practical usability matters more than teaching or full coverage.

Write how-to guides like this:

- Title the guide around the user's goal: "How to rotate API keys", not "API keys".
- State prerequisites and assumptions briefly.
- Provide executable steps in the order the reader can use them.
- Include branches only where they reflect real decision points.
- Add validation steps so the reader can confirm success.
- Include rollback, cleanup, or escalation when operational risk exists.
- Link to reference for complete options and explanation for background.

Avoid in how-to guides:

- Teaching basic concepts the target reader should already know.
- Exhaustively describing every option.
- Organizing around product menus, classes, or features instead of user goals.
- Long rationale that delays the next action.

Useful how-to language:

- "This guide shows you how to..."
- "Before you start..."
- "To achieve..., do..."
- "If you use..., choose..."
- "Verify the change by..."
- "For all available options, see..."

## Reference

Reference is authoritative technical description. The reader consults it during work to answer exact questions about behavior, parameters, fields, commands, constraints, or errors.

Use reference mode when:

- The reader needs precise facts while working.
- The structure should follow the machinery, API, schema, command, configuration, or domain model.
- Completeness and consistency matter more than narrative flow.
- Examples illustrate usage but do not become a tutorial or task guide.

Write reference like this:

- Describe and only describe.
- Use stable, repeatable patterns for similar items.
- Mirror the structure of the product or system.
- Include names, types, defaults, constraints, required/optional status, errors, side effects, and limitations where relevant.
- Use concise examples to illustrate behavior.
- Use precise normative language: "must", "must not", "required", "optional", "default", "deprecated".

Avoid in reference:

- Why-oriented essays.
- Step-by-step task procedures.
- Opinions or design rationale unless they define behavior.
- Inconsistent ordering or terminology across similar entries.

Useful reference patterns:

- API endpoint: method, path, auth, parameters, request body, responses, errors, rate limits.
- Configuration field: name, type, default, required status, accepted values, effect, examples.
- Command: syntax, arguments, flags, output, exit codes, examples.
- Event/message: schema, producer, consumer, ordering, delivery guarantees, failure behavior.

## Explanation

Explanation builds understanding. The reader is away from the immediate task and wants context, reasons, background, trade-offs, or a mental model.

Use explanation mode when:

- The reader asks why something exists, why it behaves that way, or how ideas connect.
- The topic involves design decisions, architecture, constraints, trade-offs, history, or implications.
- A bounded discussion will help future decisions or reduce confusion.

Write explanation like this:

- Start from the reader's real or imagined "why" question.
- Connect concepts, causes, constraints, and consequences.
- Explain trade-offs and alternatives.
- State perspective where useful; explanation can include justified opinion.
- Use diagrams when they clarify relationships or flow.
- Link to how-to guides for procedures and reference for exact facts.

Avoid in explanation:

- Step-by-step instructions.
- Exhaustive API or configuration tables.
- Unbounded background that does not answer the reader's question.
- Hiding uncertainty when the system has open questions or trade-offs.

Useful explanation language:

- "The reason for this design is..."
- "This trade-off matters because..."
- "Compared with..., this approach..."
- "A useful mental model is..."
- "This constraint implies..."

## Mode Contamination Checks

- If a tutorial has many branches, options, or troubleshooting cases, move those parts to how-to or reference.
- If a how-to explains concepts for several paragraphs before action starts, move that explanation out or reduce it to a prerequisite link.
- If reference reads like an essay, split out explanation and keep the factual description.
- If explanation contains numbered operational steps, move them to a how-to guide.
- If a section answers multiple reader questions, split it by question rather than polishing the mixture.
