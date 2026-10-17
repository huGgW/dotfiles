# English AI-Writing Patterns

Detailed catalog of English AI-writing traces with `Before` / `After` examples.
Read this file only when editing English prose (or non-Korean prose where the
same concepts apply). For Korean text, read `korean-patterns.md` instead and
use this file only as background.

Source: adapted from Wikipedia's "Signs of AI writing" (WikiProject AI Cleanup)
and Humanizer-zh. See `../THIRD_PARTY_NOTICES.md` for attribution.

## Contents

- Voice and personality
- Content patterns (1-6): inflated significance, notability, -ing clauses, promotional, vague attribution, challenges sections
- Language and grammar (7-12): AI vocabulary, is/has, negative parallelism, rule of three, synonym cycling, false range
- Style patterns (13-18): dashes, bold, inline-heading lists, title case, emoji, curly quotes
- Communication patterns (19-21): chatbot residue, cutoff disclaimers, sycophancy
- Filler and hedging (22-24): filler phrases, overqualification, generic conclusions
- Quick checklist, Quality rubric, Complete example

## How to use this catalog

1. Identify only the patterns relevant to the user's requested scope.
2. Treat matches as editing candidates, not proof the text was AI-generated.
3. Rewrite affected passages; do not invent facts, sources, dates, names, or metrics.
4. For vague attribution, never invent a source: remove the claim, flag it as
   missing, or ask the user when the claim matters.

## Voice and personality

Removing patterns is half the work. Sterile, voiceless prose still feels
machine-written. Good writing sounds like a real person made choices.

Lifeless signals: uniform sentence length/structure, neutral reporting with no
point of view, no uncertainty or tension where natural, avoided first person,
no humor/edge/preference, Wikipedia/press-release/corporate tone.

Add voice by: having a point of view, varying pace (short sentences, then a
longer one when needed), admitting complexity, using first person when honest
("I keep thinking about..."), allowing small imperfections, being specific
about feelings with concrete detail.

Before:

> The experiment produced interesting results. The agents generated three million lines of code. Some developers were impressed, while others were skeptical. The impact remains unclear.

After:

> I still do not know what to make of it. Three million lines of code, apparently generated while most of the humans were asleep. Half the developer community is losing its mind, and the other half is explaining why it does not count. The truth is probably somewhere in the boring middle, but I keep thinking about those agents running through the night.

## Content patterns

### 1. Inflated significance, legacy, and broader trends

Watch for: serves as, marks, stands as a testament, testament to, reminder of, crucial role, pivotal role, important milestone, underscores its significance, reflects broader, symbolizes its enduring, contributes to, lays the foundation, shapes, represents a shift, turning point, evolving landscape, focal point, indelible mark, deeply rooted.

Problem: LLMs inflate ordinary facts by claiming broader themes, historical shifts, or symbolic importance.

Before:

> The Statistical Institute of Catalonia was formally established in 1989, marking a pivotal moment in the evolution of regional statistics in Spain. This initiative formed part of a broader national movement toward administrative decentralization and stronger regional governance.

After:

> The Statistical Institute of Catalonia was established in 1989 to collect and publish regional statistics independently from Spain's national statistics office.

### 2. Overstated notability and media coverage

Watch for: covered by independent media, local/regional/national media, written by notable experts, active social media presence.

Problem: LLMs assert notability by listing outlets without explaining why coverage matters.

Before:

> Her views have been cited by The New York Times, the BBC, the Financial Times, and The Hindu. She maintains an active social media presence with more than 500,000 followers.

After:

> In a 2024 interview with The New York Times, she argued that AI regulation should focus on outcomes rather than methods.

### 3. Shallow analysis with -ing clauses

Watch for: highlighting, ensuring, reflecting, symbolizing, contributing to, fostering, encompassing, showcasing.

Problem: present-participle phrases appended for fake depth.

Before:

> The temple's blue, green, and gold palette resonates with the region's natural beauty, symbolizing Texas bluebonnets, the Gulf Coast, and the diverse Texas landscape, reflecting the community's deep connection to the land.

After:

> The temple uses blue, green, and gold. The architects said the colors refer to local bluebonnets and the Gulf Coast.

### 4. Promotional or advertising language

Watch for: boasts, vibrant, rich, profound, enhances its, showcases, embodies, committed to, natural beauty, nestled, located in the heart of, groundbreaking, renowned, breathtaking, must-visit, captivating.

Problem: brochure tone, especially for heritage, travel, products.

Before:

> Nestled within the breathtaking Gondar region of Ethiopia, Alamata Raya Kobo is a vibrant town boasting rich cultural heritage and captivating natural beauty.

After:

> Alamata Raya Kobo is a town in Ethiopia's Gondar region, known for its weekly market and 18th-century church.

### 5. Vague attribution and hedging

Watch for: industry reports show, observers note, experts believe, some critics argue, multiple sources/publications when only a few are cited.

Problem: claims assigned to vague authorities. Do not invent a source. Remove the
claim, mark attribution as missing, or ask the user if the claim is important.

Before:

> Because of its unusual features, the Haolai River has attracted interest from researchers and conservationists. Experts believe it plays a crucial role in the regional ecosystem.

After (source cited in draft):

> The Haolai River supports several endemic fish species, according to the source cited in the draft.

If no source is available:

> The Haolai River supports several fish species. The draft needs a specific source for claims about its ecological importance.

### 6. Formulaic "challenges and future prospects" sections

Watch for: despite its..., faces several challenges..., despite these challenges, challenges and legacy, future prospects.

Problem: generic challenges section with no concrete reporting.

Before:

> Despite its industrial growth, Korattur faces challenges typical of urban areas, including traffic congestion and water scarcity. Despite these challenges, its strategic location and ongoing initiatives mean Korattur continues to thrive as an integral part of Chennai's growth.

After:

> Traffic increased after three new IT parks opened in 2015. The municipal corporation began a stormwater drainage project in 2022 after repeated flooding.

## Language and grammar patterns

### 7. Overused AI vocabulary

Common AI words: furthermore, aligns with, crucial, delve, emphasize, enduring, enhance, foster, garner, highlight, interplay, intricate, pivotal, landscape, showcase, tapestry, testament, underscore, invaluable, vibrant.

Problem: these words cluster in post-2023 AI text.

Before:

> Furthermore, a notable feature of Somali cuisine is the incorporation of camel meat. An enduring testament to Italian colonial influence is the widespread adoption of pasta in the local culinary landscape, showcasing how these dishes became woven into traditional diets.

After:

> Somali cuisine also includes camel meat, which is considered a delicacy. Pasta dishes introduced during Italian colonial rule remain common, especially in the south.

### 8. Avoiding simple "is" and "has"

Watch for: serves as, represents, marks, functions as, boasts, features, offers.

Problem: inflated linking verbs instead of simple ones.

Before:

> Gallery 825 serves as LAAA's contemporary art exhibition space. The gallery features four separate rooms and boasts more than 3,000 square feet.

After:

> Gallery 825 is LAAA's contemporary art exhibition space. The gallery has four rooms and covers more than 3,000 square feet.

### 9. Negative parallelism

Problem: "not only... but also..." and "it is not just about... it is about..." are overused.

Before:

> This is not just about beats flowing under vocals; it is about aggression and atmosphere. This is not just a song, but a statement.

After:

> The heavy beat adds to the aggressive tone.

### 10. Overuse of the rule of three

Problem: ideas forced into groups of three to sound complete.

Before:

> The event includes keynote speeches, panel discussions, and networking opportunities. Attendees can expect innovation, inspiration, and industry insights.

After:

> The event includes talks and panel discussions, with time between sessions for informal networking.

### 11. Deliberate synonym cycling

Problem: rotating synonyms to avoid repetition, more awkward than repetition.

Before:

> The protagonist faces many challenges. The main character must overcome obstacles. The central figure ultimately triumphs. The hero returns home.

After:

> The protagonist faces several challenges but eventually wins and returns home.

### 12. False range

Problem: "from X to Y" where X and Y form no meaningful scale.

Before:

> Our journey through the cosmos takes us from the singularity of the Big Bang to the majestic cosmic web, from the birth and death of stars to the mysterious dance of dark matter.

After:

> The book covers the Big Bang, star formation, and current theories about dark matter.

## Style patterns

### 13. Dash overuse

Problem: em dashes and dash-heavy reveals imitating punchy sales copy.

Before:

> The term was promoted mainly by Dutch institutions - not by the people themselves. You would not write "Holland, Europe" as an address - but the mistaken label persists - even in official documents.

After:

> The term was promoted mainly by Dutch institutions, not by the people themselves. You would not write "Holland, Europe" as an address, but the mistaken label still appears in official documents.

### 14. Bold overuse

Problem: mechanical bolding for emphasis.

Before:

> It combines **OKRs**, **KPIs**, and visual strategy tools such as the **Business Model Canvas** and **Balanced Scorecard**.

After:

> It combines OKRs, KPIs, and visual strategy tools such as the Business Model Canvas and Balanced Scorecard.

### 15. Inline-heading vertical lists

Problem: list items starting with bold labels followed by colons.

Before:

> - **User experience:** The new interface significantly improves user experience.
> - **Performance:** Performance is enhanced through optimized algorithms.
> - **Security:** Security is strengthened through end-to-end encryption.

After:

> The update improves the interface, speeds up loading through optimized algorithms, and adds end-to-end encryption.

### 16. Title case in headings

Problem: capitalizing every major word where sentence case is more natural.

Before:

> ## Strategic Negotiations and Global Partnerships

After:

> ## Strategic negotiations and global partnerships

### 17. Emoji decoration

Problem: emoji on headings or bullets.

Before:

> Rocket launch phase: The product ships in Q3.
> Lightbulb key insight: Users prefer simplicity.
> Check next step: Schedule a follow-up meeting.

After:

> The product ships in Q3. User research shows a preference for simplicity. Next step: schedule a follow-up meeting.

### 18. Curly quotes

Problem: curly quotes where straight quotes are expected.

Before:

> He said U+201Cthe project is going well,U+201D but others disagreed.

After:

> He said "the project is going well," but others disagreed.

## Communication patterns

### 19. Chatbot collaboration residue

Watch for: hope this helps, certainly, absolutely, you are absolutely right, you might want to, let me know, here is a...

Problem: assistant-facing phrases left in copied content.

Before:

> Here is an overview of the French Revolution. Hope this helps! Let me know if you want me to expand any section.

After:

> The French Revolution began in 1789, when fiscal crisis and food shortages contributed to widespread unrest.

### 20. Knowledge cutoff disclaimers

Watch for: as of [date], based on my last training update, while specific details are limited/scarce, based on available information.

Before:

> While specific details about the company's founding are not widely recorded in readily available sources, it appears to have been established sometime in the 1990s.

After:

> The company's founding date needs a source. If registration records are available, cite the exact year.

### 21. Sycophantic tone

Problem: exaggerated agreement or praise.

Before:

> Great question! You are absolutely right that this is a complex topic. Your point about economic factors is excellent.

After:

> The economic factors you mentioned are relevant here.

## Filler and hedging

### 22. Filler phrases

- "in order to achieve this goal" -> "to do this"
- "due to the fact that it rained" -> "because it rained"
- "at this point in time" -> "now"
- "in the event that you need help" -> "if you need help"
- "the system has the ability to process" -> "the system can process"
- "it is worth noting that the data shows" -> "the data shows"

### 23. Overqualification

Problem: stacked qualifiers until the claim is mushy.

Before:

> It could potentially be considered that the policy may possibly have some impact on outcomes.

After:

> The policy may affect outcomes.

### 24. Generic positive conclusions

Problem: vague optimism at the end.

Before:

> The company's future looks bright. Exciting times lie ahead as it continues its journey toward excellence. This represents an important step in the right direction.

After:

> The company plans to open two more locations next year.

## Quick checklist

- Three consecutive sentences with the same length or structure. Break one.
- Paragraphs ending with the same tidy one-line conclusion. Vary the endings.
- A dash before the reveal. Remove it unless genuinely useful.
- Explained metaphors or similes. Trust the reader.
- Connective crutches such as furthermore, moreover, and however. Consider cutting them.
- Three-item lists. Try two items or four if that better matches the content.
- Vague authority. Use a real source, remove the claim, or flag the missing source.

## Quality scoring rubric

Self-check only. Show the score only when the user asks for evaluation or when it would materially help.

| Dimension | What to evaluate | Score |
| --- | --- | --- |
| Directness | Facts stated directly? 10 = straightforward; 1 = full of setup. | /10 |
| Rhythm | Sentence length varied? 10 = varied; 1 = mechanical. | /10 |
| Trust | Reader intelligence respected? 10 = concise; 1 = overexplained. | /10 |
| Authenticity | Sounds like a real person? 10 = natural; 1 = mechanical. | /10 |
| Economy | Anything left to cut? 10 = no redundancy; 1 = bloated. | /10 |
| Total |  | /50 |

Standards: 45-50 excellent; 35-44 good, some improvements remain; below 35 revise again.

## Complete example

Before:

> The new software update serves as a testament to the company's commitment to innovation. Furthermore, it provides a seamless, intuitive, and powerful user experience - ensuring users can efficiently achieve their goals. This is not merely an update, but a revolution in how we think about productivity. Industry experts believe it will have a lasting impact across the sector, underscoring the company's pivotal role in the evolving technology landscape.

After:

> The software update is described as improving the user experience, but the draft does not identify specific changes. It also cites unnamed industry experts who expect a lasting impact.

Changes made:

- Removed "serves as a testament" (inflated significance).
- Removed "furthermore" (AI connective).
- Replaced "seamless, intuitive, and powerful" with a note that the draft lacks specifics.
- Removed the dash and "ensuring" clause.
- Removed the "not merely... but..." structure.
- Made vague "industry experts" attribution explicit instead of inventing a source.
- Removed "pivotal role" and "evolving technology landscape" without inventing outcomes.
