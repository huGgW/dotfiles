# Workspace Lifecycle Component and Ownership Map

Treat this fixture as authoritative. Do not invent dependencies that contradict it.

## Target outcome

Workspace administrators can suspend and reinstate a workspace, schedule deletion with a 30-day cancellation window, and purge an expired workspace without breaking legacy consumers of the current `archived` boolean.

## Component map

| Component | Owner and reviewer | Required change | Co-change constraint | Estimated review signal |
| --- | --- | --- | --- | --- |
| `workspace-state` | Platform Foundation | Add the lifecycle enum beside `archived`, project enum states back to the legacy boolean, and later remove the bridge | Expansion must land first; bridge removal must land last | About 450 handwritten lines; compatibility and rollback are the only principal risks |
| `identity-admin-api` | Identity Security | Add administrator suspend and reinstate operations | Must change with `session-policy`; neither operation may be enabled without the other | About 250 handwritten lines |
| `session-policy` | Identity Security | Revoke active sessions, reject writes, preserve permitted reads, and require fresh sessions after reinstatement | Lockstep with `identity-admin-api`; the two components share one transition table, feature flag, and security test matrix | About 450 handwritten lines |
| `deletion-request-store` | Data Lifecycle | Store the deletion deadline, prior state, cancellation, and audit correlation | Must change with `deletion-scheduler`; scheduling cannot ship without its cancellation guard | About 300 handwritten lines |
| `deletion-scheduler` | Data Lifecycle | Schedule and cancel deletion and handle races at the 30-day boundary | Lockstep with `deletion-request-store`; both use one transaction and one rollout flag | About 350 handwritten lines |
| `purge-worker` | Compliance Storage | Dry-run, count, and irreversibly purge only expired, uncancelled workspaces while preserving required audit evidence | Requires the deletion deadline and cancellation behavior; has a separate destructive rollout and reviewer | About 400 handwritten lines |
| `public-lifecycle-contract` | Developer Platform | Add handwritten API and event contract definitions for the supported lifecycle operations | Release governance keeps this contract and its generated SDK in one issue | About 250 handwritten lines |
| `generated-admin-sdk` | Developer Platform | Regenerate the SDK from the approved contract | Review handwritten contract first, then the 18,000-line generated output in a second independently green PR | 18,000 generated lines |

## Legacy consumer migration groups

The compatibility bridge allows these ownership groups to migrate independently. Components within one row share an internal interface and cannot land green separately. Different rows do not block one another.

| Ownership group | Components that move together | Reviewer |
| --- | --- | --- |
| Identity consumers | `identity-auth`, `session-cache` | Identity Security |
| Billing consumers | `billing-entitlements`, `invoice-worker` | Billing Platform |
| Data consumers | `data-indexer`, `retention-reporter` | Data Platform |

Each ownership group is expected to produce roughly 300-500 handwritten changed lines. Line count is a review signal, not a quota.

## Dependency and landing facts

1. The compatibility expansion in `workspace-state` lands first.
2. The three legacy consumer groups can migrate in parallel after expansion.
3. Suspend/reinstate and schedule/cancel can also land after expansion; the compatibility projection means they do not wait for legacy consumer migrations.
4. Purge waits for schedule/cancel and must not share its destructive rollout with reversible deletion behavior.
5. The public contract and generated SDK wait for all three user-visible behavior groups. Its minimal direct blockers are suspend/reinstate and purge; schedule/cancel is already reached transitively because purge waits for it.
6. Removing `archived` waits for all three legacy consumer migrations and the public contract/SDK delivery. Do not repeat behavior issues as direct blockers because the public delivery already depends on them.
7. The audit-evidence API is stable and needs no standalone change. Each behavior verifies its own audit evidence through that API.
8. Behavior-specific tests land with their behavior. Migration parity tests land with their ownership migration. No standalone testing issue is needed.

## Review boundary facts

- Suspend and reinstate form one access-control invariant, one release flag, and one Identity Security review package. Splitting them would create an unsafe intermediate state.
- Scheduling and cancellation form one reversible-deletion invariant, one transaction, and one Data Lifecycle review package. Splitting them would ship scheduling without its rollback guard.
- Purge has a different reviewer, irreversible risk, and rollout. Combining it with scheduling/cancellation would create an oversized mixed-risk review.
- The three legacy migration groups have different owners and may land independently. Combining groups would require unrelated reviewers; splitting a group would break its lockstep internal contract.
- The handwritten public contract and generated SDK are one delivery outcome but two ordered PR reviews. Generated churn must not obscure handwritten semantics.
