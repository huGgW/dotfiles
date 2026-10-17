# Phase 6: Report Generation

Objective: comprehensive markdown report in Korean.

## Report template

```markdown
# [주제] 연구 보고서

## 개요
- 연구 목적: [clarified_query]
- 연구 깊이: [depth_level]
- 주요 질문: [primary questions list]
- 신뢰도: [overall confidence score]

## 핵심 발견사항
1. [Key Finding 1]
2. [Key Finding 2]
3. [Key Finding 3]
...

## 상세 분석

### [Research Question 1]
[Synthesized answer with evidence]

**출처**:
- [Source 1 with credibility]
- [Source 2 with credibility]

### [Research Question 2]
...

## 인사이트 및 시사점
- [Insight 1]
- [Insight 2]
...

## 권장사항
- [Recommendation 1]
- [Recommendation 2]
...

## 한계 및 향후 연구 방향
- [Limitation 1]
- [Remaining gap 1]
...

## 참고문헌
1. [Citation 1]
2. [Citation 2]
...
```

## Quality checklist

- [ ] All research questions addressed
- [ ] Sources properly cited
- [ ] Contradictions documented and resolved
- [ ] Material synthesis gaps triggered replanning or were reported as limitations
- [ ] Every Phase 4 pass was followed by a Phase 5 gate with the exact required fields
- [ ] Every plan mutation occurred after `status: replan` and an explicit `Phase 5 -> Phase 2` transition
- [ ] The last gate before Phase 6 was `complete` or `budget_exhausted`
- [ ] Confidence levels assigned
- [ ] Actionable insights provided
- [ ] Written in Korean

## Quality metrics

| Metric     | Calculation                         | Target |
| ---------- | ----------------------------------- | ------ |
| Coverage   | Answered questions / Total questions | ≥ 0.9  |
| Depth      | Actual depth achieved / Requested depth | ≥ 0.8 |
| Confidence | Average source credibility weighted | ≥ 0.7  |
