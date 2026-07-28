# Korean copyediting reference

Use this reference with `korean-patterns.md` whenever the input is Korean. It covers correctness and register rather than AI detection. Follow the user's requested scope: a spelling-only request permits spelling, spacing, and punctuation corrections, but not broad stylistic rewriting.

## Decision levels

- **Definite**: the standard form is clear and the correction does not depend on the intended meaning. Correct it directly.
- **Context-sensitive**: more than one form can be correct. Change it only when the surrounding sentence identifies the intended meaning.

If context is insufficient, preserve the original or flag the ambiguity when the user asked for diagnosis. Never guess a name, brand spelling, quotation, technical term, or writer intent.

## Meaning and scope safeguards

Before correcting, identify protected spans: direct quotations, code, commands, URLs, names, brands, product labels, and defined legal or technical terms. Preserve them unless the user explicitly asks to correct them and the correction is unambiguous.

After correcting, confirm that the revision preserves:

- facts, numbers, sources, and named actors;
- negation, possibility, obligation, permission, and uncertainty;
- tense, aspect, causality, conditions, and responsibility;
- the document's genre and dominant speech level.

## Frequent forms with a definite correction

| Check | Rule | Example |
| --- | --- | --- |
| `예요/이에요` | Use `예요` after a vowel and `이에요` after a consonant. `아니에요` is the exception. | `도구에요` -> `도구예요`; `책이예요` -> `책이에요` |
| `-율/-률`, `-열/-렬` | Use `율/열` after a vowel or final `ㄴ`; otherwise use `률/렬`. | `비률` -> `비율`; `확율` -> `확률` |
| Promise ending | Write `-ㄹ게`, not `-ㄹ께`. | `할께요` -> `할게요` |
| Intention ending | Write `-려고`, not `-ㄹ려고`. | `갈려고` -> `가려고` |
| `어떻게/어떡해` | `어떻게` modifies a predicate; `어떡해` contracts `어떻게 해`. | `이걸 어떡해 하지` -> `이걸 어떻게 하지` |
| Standard spellings | Correct established misspellings without changing vocabulary. | `몇일` -> `며칠`; `역활` -> `역할`; `오랫만` -> `오랜만`; `설레임` -> `설렘` |

Other common definite spellings include `희한`, `굳이`, `으레`, `금세`, `폭발`, `어이없다`, `잠갔다`, `담갔다`, and `웬만하다`. Do not apply a replacement inside a name or intentional brand spelling.

## Context-sensitive pairs

Use the sentence meaning, not surface resemblance.

| Pair | Distinction | Examples |
| --- | --- | --- |
| `되/돼` | `돼` contracts `되어`; otherwise use `되`. | `안 되` -> `안 돼`; `돼고` -> `되고` |
| `안/않` | `안` is an adverb; `않-` is part of a predicate. | `않 먹었다` -> `안 먹었다`; `가지 안았다` -> `가지 않았다` |
| `-데/-대` | `-데` recalls direct experience; `-대` reports what someone said. | `사람이 많데`; `결혼한대` |
| `-든/-던` | `-든` marks choice or indifference; `-던` recalls the past. | `가든 말든`; `놀던 곳` |
| `로서/로써` | `로서` marks status or capacity; `로써` marks means or instrument. | `학생으로서`; `대화로써` |
| `채/체/째` | State, pretense, and order or entirety have different forms. | `신발을 신은 채`; `못 본 체`; `껍질째` |
| `맞히다/맞추다` | Use `맞히다` for a correct answer or hit; `맞추다` for comparison or adjustment. | `정답을 맞히다`; `시간을 맞추다` |
| `너머/넘어` | `너머` is a place beyond; `넘어` is an action. | `산 너머`; `고개를 넘어` |
| `가르치다/가리키다` | Teaching differs from pointing. | `영어를 가르치다`; `방향을 가리키다` |
| `부치다/붙이다` | Use `붙이다` when attaching; use `부치다` for sending and other lexical meanings. | `우표를 붙이다`; `편지를 부치다` |
| `늘리다/늘이다` | Increase amount with `늘리다`; lengthen with `늘이다`. | `인원을 늘리다`; `고무줄을 늘이다` |
| `낫다/낳다/났다` | Recovery or superiority, giving birth or producing, and past `나다` differ. | `감기가 나았다`; `아이를 낳았다`; `문제가 났다` |
| `결제/결재` | Payment differs from approval. | `카드 결제`; `서류 결재` |
| `지양/지향` | Avoiding differs from pursuing. | `폭력을 지양하다`; `평화를 지향하다` |
| `왠지/웬` | Only contracted `왜인지` becomes `왠지`; other cases usually use `웬`. | `왠지`; `웬일`; `웬만하면` |
| `-이/-히` | Follow the established adverb form rather than sound alone. | `깨끗이`; `곰곰이`; `솔직히`; `꼼꼼히` |

## Spacing

### Particles and dependent nouns

Attach particles to the preceding word. Separate dependent nouns such as `것`, `수`, `데`, and temporal `지` from the preceding modifier.

- `학교 에서` -> `학교에서`
- `할수 있다` -> `할 수 있다`
- `먹을것` -> `먹을 것`
- `만난지 3년` -> `만난 지 3년`

Some forms depend on grammatical function. For example, particle `뿐` attaches (`너뿐이다`), while dependent noun `뿐` is spaced after a modifier (`기다릴 뿐이다`).

### Units, names, and titles

Write ordinary unit nouns after numbers with a space. Keep a Korean family name and given name together, and separate a following title or honorific.

- `한개`, `두살` -> `한 개`, `두 살`
- `홍 길동`, `홍길동씨` -> `홍길동`, `홍길동 씨`

Preserve conventional notation in technical expressions, source code, tables, or domain-specific style guides when spacing carries established meaning.

### `안 되다/안되다`

Use `안 되다` for negation, prohibition, or impossibility. Use lexical `안되다` for a situation going badly or for pity when that meaning is clear.

- `거짓말하면 안된다` -> `거짓말하면 안 된다`
- `장사가 잘 안된다` remains joined when it means that business is going poorly.

## Punctuation and notation

- Keep punctuation consistent within the document.
- Put a quoted sentence's terminal punctuation inside the quotation when it belongs to the quoted material.
- Do not add a comma after a connective automatically; use one only when structure or readability needs it.
- Use one ellipsis style consistently, such as `...` or `……`.
- Preserve Markdown, code fences, inline code, URLs, and command syntax exactly unless the task targets them.

For 사이시옷, 두음법칙, and loanword spelling, correct only established standard forms. These areas contain lexical exceptions, so do not infer a form from one mechanical rule.

- Common 사이시옷 examples: `나뭇가지`, `찻집`, `횟수`; but `개수`, `수놈`, `해님`.
- Common 두음법칙 examples: `여자`, `역사`, `유행`, `연세`, `내일`; preserve names and fixed compounds.
- Common loanword examples: `콘텐츠`, `메시지`, `캡처`, `디지털`, `파이팅`; preserve intentional product and brand spellings.

## Honorifics and speech level

First identify the document's dominant speech level. Keep it unless the user requests another tone.

| Speech level | Typical endings | Common contexts |
| --- | --- | --- |
| Formal polite | `-습니다/-ㅂ니다` | Notices, customer service, public documents |
| Casual polite | `-아요/-어요/-예요` | Conversation, friendly articles, blogs |
| Plain explanatory | `-ㄴ다/-는다/-다` | Reports, articles, academic explanation |
| Intimate | `-아/-어`, plain commands | Close conversation and intentionally casual writing |

### Direct and indirect honorifics

Do not honor objects, prices, colors, or statuses with `-시-`.

- `커피 나오셨습니다` -> `커피 나왔습니다`
- `그 색상은 품절이십니다` -> `그 색상은 품절입니다`
- `만 원이십니다` -> `만 원입니다`

Keep indirect honorifics when a body part, possession, thought, speech, or family member is closely connected to the honored person.

- `선생님은 따님이 있으시다`
- `할아버지는 귀가 밝으시다`

Do not remove `-시-` from these examples merely because the grammatical subject is not the person directly.

### Object honorific vocabulary

Use the relationship expressed by the sentence:

- `주다` -> `드리다`
- `데리다` -> `모시다`
- `묻다` -> `여쭙다`
- `보다` -> `뵙다`
- `에게` -> `께`

Apply these only when the object is genuinely honored. Do not replace every occurrence mechanically.

### Excessive or ambiguous honorifics

Clarify who performs the action instead of using `-실게요` as a generic service ending.

- `결제 도와드리실게요` -> `결제를 도와드리겠습니다`
- `확인 한번 해보실게요` -> `확인해 주세요` when the customer should check

## Genre-sensitive copyediting

- Use familiar public-language alternatives in notices when exact legal or technical wording is not required: `금번` -> `이번`, `익일` -> `내일`, `상기` -> `위`.
- Preserve defined terms in laws, contracts, policies, specifications, and APIs.
- Prefer concise noun labels for actual headings, table headers, buttons, cards, and navigation. Do not convert ordinary prose sentences to noun endings merely to make them shorter.
- Do not make reports, resumes, proposals, or academic text casual to make them seem more human.

## Final pass

1. Reconfirm the user's requested scope.
2. Protect quotations, code, URLs, names, brands, and defined terminology.
3. Correct definite spelling and spacing errors.
4. Resolve context-sensitive forms only from clear sentence meaning.
5. Check punctuation, dominant speech level, and honorific relationships.
6. Compare the revision with the draft for facts, semantic force, time, causality, and responsibility.
7. Preserve already-correct wording when a change would be merely preferential or risk changing the writer's voice.
