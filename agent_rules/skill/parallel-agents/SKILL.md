---
name: parallel-agents
description: Guide for orchestrating subagents and skills to handle complex multi-step tasks effectively
---

# Multi-Agent Orchestration Guide

## Overview

Complex tasks benefit from orchestrating multiple subagents rather than handling everything in a single agent. This guide provides patterns for task decomposition, subagent coordination, and result synthesis.

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
5. Determine appropriate approach for each task (subagent type, required skills)

## Orchestration Patterns

### Pattern 1: Parallel Analysis

Use when analysis from multiple perspectives is needed simultaneously.

```
Subtasks (independent):
├── Structure/architecture analysis
├── Code quality review
├── Security assessment
└── Test coverage analysis

Execution: Launch all subtasks in parallel via multiple Task tool calls
Result: Synthesize findings after all tasks complete
```

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

### Pattern 3: Hybrid

Use for complex tasks with mixed parallel/sequential phases.

```
Phase 1: Parallel Exploration
├── Explore area A
├── Explore area B
└── Explore area C
        ↓
Phase 2: Sequential Implementation (based on Phase 1 findings)
├── Implement feature
└── Verify changes
```

## Context Management

### Parallel Execution
- Each Task runs independently
- Collect and synthesize results after completion
- No context sharing between parallel tasks

### Sequential Execution
- Use task_id to resume previous work
- Pass essential context explicitly in prompt
- Minimize context to necessary information only

## Skill Loading Strategy

### When to Load Skills
- Specialized expertise is required
- Standardized process guidance is needed
- Domain-specific best practices apply

### How to Load
Include skill loading instruction in the task prompt when domain expertise would benefit the task.

## Synthesis Protocol

After all tasks complete:

1. **Collect Results**: Gather key findings from each task
2. **Identify Patterns**: Remove duplicates, find common themes
3. **Prioritize**: Sort by importance/urgency
4. **Define Actions**: Specify concrete follow-up work
5. **Consolidate**: Produce unified report or output

## Best Practices

1. **Plan Before Execution**: Identify required tasks upfront
2. **Parallel First**: Run independent tasks concurrently
3. **Avoid Over-decomposition**: Too many small tasks creates overhead
4. **Always Synthesize**: Don't end with scattered individual results
5. **Minimize Context**: Pass only necessary information to each task
6. **Leverage Skills**: Load relevant skills for specialized work
