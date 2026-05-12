# Korean-specific humanizer patterns

Use this reference when the input text is Korean, when the user asks to remove "AI 티", or when the text sounds translated, bureaucratic, overly polished, or mechanically polite.

These rules are editing heuristics, not AI-detection proof. A single phrase such as "또한" or "것 같다" can be perfectly natural. Revise only when the pattern weakens clarity, rhythm, or genre fit.

## Evidence base

- National Institute of Korean Language, public language review: public-facing Korean should be easy and correct.
- National Institute of Korean Language, refined words: foreign words and jargon often need reader-friendly Korean alternatives.
- Korean orthography and standard language rules: spelling, spacing, standard language, loanword notation, and punctuation remain hard constraints.
- Ministry of Government Legislation, plain-language lawmaking resources: legal and administrative Korean benefits from simpler words, clearer subjects, and shorter sentences.
- KatFishNet, ACL 2025: Korean LLM-generated text differs from human writing in spacing patterns, POS diversity, and comma usage.
- XDAC, ACL 2025 / KAIST report: Korean AI-generated comments show more formal expressions and connectors, while human comments use more Korean-specific informal markers, line breaks, repeated characters, and varied punctuation.
- Practical Korean editing guides on translationese: common English-to-Korean artifacts include pronoun overuse, passive voice, overuse of "의", "~에 대해", "~을 통해", and unnecessary plural "들".

## Korean editing principles

1. Meaning first. Do not change claims, sources, dates, responsibility, legal effect, or the writer's stance.
2. Norms second. Check Korean spelling, spacing, particles, endings, loanword notation, and punctuation after rewriting.
3. Natural Korean structure third. Prefer Korean word order, particles, and verb-centered sentences over translated noun phrases.
4. Genre decides. A legal clause, product notice, blog post, academic abstract, and comment all need different levels of formality.
5. Do not fake humanity. Do not add slang, "ㅋㅋ", "ㅠㅠ", emoji, typos, or extra punctuation unless the user explicitly asks for that register.

## Translationese and English-style phrasing

Watch for these patterns:

- "~로부터" used mechanically for "from".
- "~에 의해" used mechanically for "by".
- "~에 대하여", "~에 대해", "~에 관하여" used mechanically for "about".
- "~에 있어" used mechanically for "in" or "when".
- "~을/를 통해" used as a vague all-purpose bridge.
- "~을/를 가지다", "가지고 있다" used mechanically for "have".
- "~하는 중이다" used mechanically for the English progressive.

Rewrite by choosing the natural Korean relation or verb.

Before:

> 이 문서는 서비스 이용에 대한 안내를 제공합니다.

After:

> 이 문서는 서비스 이용 방법을 안내합니다.

Before:

> 밤샘 공부를 통해 시험에 합격했다.

After:

> 밤새워 공부해 시험에 합격했다.

Before:

> 이 기능은 사용자에 의해 설정될 수 있습니다.

After:

> 사용자가 이 기능을 설정할 수 있습니다.

## Bureaucratic nominalization

Korean AI prose often sounds like a public notice because it turns verbs into noun phrases.

Watch for:

- "검토를 실시하다" -> "검토하다"
- "분석을 수행하다" -> "분석하다"
- "안내를 제공하다" -> "안내하다"
- "개선을 추진하다" -> "개선하다" or specify the action
- "확인을 진행하다" -> "확인하다"
- "논의를 가지다" -> "논의하다"

Before:

> 사용성 개선을 위한 검토를 실시했습니다.

After:

> 사용성을 개선하려고 검토했습니다.

If the sentence hides the actor, restore it when the context provides one.

Before:

> 관련 자료에 대한 분석이 수행되었습니다.

After:

> 연구팀이 관련 자료를 분석했습니다.

## Repetitive AI-style endings

Watch for repeated endings such as:

- "~할 수 있습니다"
- "~하는 것이 중요합니다"
- "~할 필요가 있습니다"
- "~라고 볼 수 있습니다"
- "~에 도움이 됩니다"
- "~을 기대할 수 있습니다"

These are not wrong, but repeated use makes Korean prose feel templated. Replace with a direct statement when possible.

Before:

> 이 기능을 사용하면 업무 효율성을 높일 수 있습니다.

After:

> 이 기능을 쓰면 업무가 빨라집니다.

Before:

> 사용자의 요구를 정확히 파악하는 것이 중요합니다.

After:

> 먼저 사용자가 무엇을 원하는지 정확히 파악해야 합니다.

## Connective overuse

Watch for paragraphs that mechanically stack:

- "또한"
- "더불어"
- "나아가"
- "한편"
- "결론적으로"
- "이를 통해"
- "이러한 점에서"
- "따라서"

Cut the connector when the relationship is obvious, or replace it with a concrete transition.

Before:

> 또한 이 기능은 설정 시간을 줄입니다. 더불어 반복 작업을 자동화합니다. 이를 통해 생산성을 높일 수 있습니다.

After:

> 이 기능은 설정 시간을 줄이고 반복 작업을 자동화합니다. 그래서 같은 일을 더 빨리 끝낼 수 있습니다.

## Overuse of "의" and unnecessary plural "들"

Reduce "의" when it creates stacked noun phrases or can be removed without changing meaning.

Before:

> 사용자의 경험의 개선을 위한 기능

After:

> 사용자 경험을 개선하는 기능

Avoid unnecessary "들" with already plural or collective expressions.

Before:

> 많은 사용자들이 여러 문제들을 보고했습니다.

After:

> 많은 사용자가 여러 문제를 보고했습니다.

## Passive voice and object subjects

Korean often sounds clearer with an active human, team, system, or institution as the subject.

Before:

> 요청은 서버에 의해 처리됩니다.

After:

> 서버가 요청을 처리합니다.

Before:

> 정책이 추진되었습니다.

After:

> 정부가 정책을 추진했습니다.

If the actor is unknown or intentionally hidden, keep the passive or flag the missing actor instead of inventing one.

## Honorifics and register

Check whether the text mixes registers without purpose:

- Formal polite: "합니다", "했습니다"
- Casual polite: "해요", "했어요"
- Plain explanatory: "한다", "했다"
- Intimate/casual: "해", "했어"

Choose one register unless the genre naturally mixes them.

Before:

> 이 기능은 매우 유용합니다. 한번 써보면 좋아요.

After:

> 이 기능은 유용합니다. 한번 써 보면 차이를 알 수 있습니다.

## Korean comments and casual community voice

For comments, chat, or community posts only, human Korean may include line breaks, repeated characters, emotive endings, Korean laughter markers, and culturally specific symbols. Use them only when requested.

Do not make formal prose casual just to hide AI traces. For a public notice, report, resume, proposal, or academic text, naturalness means clarity and rhythm, not slang.

## Quick Korean checklist

- Is the sentence built around nouns when a verb would be clearer?
- Can "~에 대해", "~을 통해", or "~에 있어" be replaced with a precise particle or verb?
- Are "~할 수 있습니다" and "~하는 것이 중요합니다" repeated across nearby sentences?
- Does the text use too many connectors at paragraph starts?
- Are there stacked "의" phrases or unnecessary plural "들"?
- Is the actor hidden behind passive voice?
- Do endings and honorifics stay consistent?
- Does the revision still fit the genre and reader?
