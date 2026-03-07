---
name: parallel-agents
description: Guide for orchestrating agents (subagents and agent teams) to handle complex multi-step tasks effectively
---

# Multi-Agent Orchestration Guide

## Overview

Complex tasks benefit from orchestrating multiple agents rather than handling everything in a single agent. This guide provides patterns for task decomposition, agent coordination, and result synthesis. Choose the appropriate execution mode (Agent Teams or Subagents) based on task characteristics and platform capabilities.

## When to Use Orchestration

### Appropriate for Orchestration
- Tasks requiring multiple expertise domains
- Work decomposable into independent subtasks
- Large-scale codebase analysis
- Parallelizable operations

### Single Agent Suffices
- Single file modifications
- Simple bug fixes
- Clear, singular objectives

## Execution Modes

### Agent Teams (Preferred when available)

Multiple independent agent instances collaborate via shared task list and direct messaging (mailbox). Each teammate has its own context window and can communicate with other teammates directly — not just through the lead.

**Strengths:**
- Cross-validation and adversarial review between teammates
- Architecture debate from multiple perspectives
- Higher quality output through collaborative refinement
- Parallel implementation with real-time coordination

**When to use Teams:**

| Scenario | Example |
|---|---|
| Multi-perspective analysis | Security + performance + quality review of a PR |
| Architecture decisions | Design debate with different trade-off perspectives |
| Hypothesis testing | Multiple investigators disproving each other's theories |
| Large parallel implementation | Each teammate owns separate modules/files |
| Adversarial review | Devil's advocate challenging proposed solutions |

### Subagents (Fallback / Single-focus tasks)

Launch via Task/Agent tool calls. Each subagent runs independently and returns results to the orchestrator. Available on all platforms.

**When to use Subagents:**
- Single-focus tasks where only results matter (file search, code lookup)
- Quick exploration or information gathering
- Environments where Agent Teams are not available (e.g., OpenCode)
- Simple sequential pipelines with no need for inter-agent discussion

### Mode Selection Rule

> **Prefer Agent Teams** for any task involving 2+ independent perspectives, cross-validation, or collaborative decision-making. Use Subagents only for single-focus tasks or when Teams are unavailable.

## Task Decomposition Strategy

### Decomposition Principles

1. **Independence**: Each subtask should not depend on results from other subtasks (when parallel)
2. **Clarity**: Each task must have clear objectives and expected deliverables
3. **Right-sizing**: Neither too granular nor too broad

### Decomposition Process

1. Define the final goal
2. Identify required expertise domains
3. Break down into subtasks
4. Map dependencies (sequential vs parallel)
5. Determine execution mode and agent roles

## Orchestration Patterns

### Pattern 1: Parallel Analysis

Use when analysis from multiple perspectives is needed simultaneously.

```
Subtasks (independent):
├── Structure/architecture analysis
├── Code quality review
├── Security assessment
└── Test coverage analysis

Execution: Launch all subtasks in parallel
Result: Synthesize findings after all tasks complete
```

> **Teams strongly recommended** — each teammate takes a distinct analytical perspective and cross-validates findings with others before synthesis. Fallback: parallel subagents.

### Pattern 2: Sequential Pipeline

Use when each stage depends on previous results.

```
Task 1: Exploration/Analysis → Pass findings
    ↓
Task 2: Planning → Pass plan
    ↓
Task 3: Implementation → Pass result
    ↓
Task 4: Verification

Key: Use task_id to maintain context between stages
```

> Subagents work well here. Consider Teams for the design/planning stage when architectural debate would improve the plan.

### Pattern 3: Hybrid

Use for complex tasks with mixed parallel/sequential phases.

```
Phase 1: Parallel Exploration
├── Explore area A
├── Explore area B
└── Explore area C
        ↓
Phase 2: Parallel Implementation (based on Phase 1 findings)
├── Implement component X
├── Implement component Y
└── Cross-review and verify
```

> Use subagents for the exploration phase. For implementation/review, **use Teams for parallel implementation with mutual cross-review**.

## Context Management

### Parallel Execution (Subagents)
- Each Task runs independently
- Collect and synthesize results after completion
- No context sharing between parallel tasks

### Sequential Execution
- Use task_id to resume previous work
- Pass essential context explicitly in prompt
- Minimize context to necessary information only

### Team Communication (Agent Teams)
- Teammates share context via mailbox messages directly
- Use shared task list to coordinate work allocation and track progress
- Team Lead synthesizes final output; teammates cross-validate each other's work
- Assign each teammate a clear role/perspective in the task description

## Skill Loading Strategy

### When to Load Skills
- Specialized expertise is required
- Standardized process guidance is needed
- Domain-specific best practices apply

### How to Load
Include skill loading instruction in the task prompt when domain expertise would benefit the task.

## Synthesis Protocol

After all tasks complete:

1. **Collect Results**: Gather key findings from each task/teammate
2. **Identify Patterns**: Remove duplicates, find common themes
3. **Prioritize**: Sort by importance/urgency
4. **Define Actions**: Specify concrete follow-up work
5. **Consolidate**: Produce unified report or output

## Best Practices

1. **Plan Before Execution**: Identify required tasks and execution mode upfront
2. **Teams First**: When Agent Teams are available, prefer teams for multi-perspective tasks. Fall back to subagents for single-focus tasks or unsupported environments
3. **Assign Clear Roles**: Give each teammate a distinct perspective or domain (e.g., security, performance, UX)
4. **Minimize File Conflicts**: When using Teams for parallel implementation, ensure each teammate owns separate files
5. **Avoid Over-decomposition**: Too many small tasks creates overhead
6. **Always Synthesize**: Don't end with scattered individual results
7. **Minimize Context**: Pass only necessary information to each task
8. **Leverage Skills**: Load relevant skills for specialized work
