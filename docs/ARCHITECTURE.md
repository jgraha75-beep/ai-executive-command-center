# Architecture Overview

## Problem

Multi-goal personal work tends to fragment across notes, chats, trackers, and short-lived plans. The Executive Command Center provides a coordination layer without forcing every domain into one undifferentiated system.

## Design

```text
                    Executive Command Center
              priorities · conflicts · review gates
                              |
        ------------------------------------------------
        |              |              |                |
   Career CC      Education CC   Fitness CC       Content CC ...
   source truth   source truth   source truth     source truth
                              |
                 Codex execution + human follow-through
```

The executive layer answers “what should happen next?” Domain command centers answer “what is true and recommended here?” Codex handles bounded implementation and research workflows, while the user retains approval for consequential academic, financial, medical, career, scheduling, account, and public-facing actions.

## Core mechanisms

1. **Durable state** — recovery indexes, decision records, ledgers, and handoffs make the system restartable.
2. **Evidence boundaries** — confirmed facts, assumptions, recommendations, drafts, and completed actions are kept distinct.
3. **Bounded delegation** — every delegated task has an owner, expected output, acceptance criteria, return path, and review point.
4. **Capacity-aware prioritization** — plans account for recovery, time, money, attention, and competing commitments.
5. **Privacy separation** — portfolio documentation is separated from personal records and raw artifacts.

## Why this is technically interesting

The project treats personal operations as a reliability and orchestration problem: state must survive context loss, workers must return verifiable outputs, and automation must fail safely. The resulting patterns are applicable to agentic workflows, operations tooling, knowledge systems, and human-in-the-loop automation.

