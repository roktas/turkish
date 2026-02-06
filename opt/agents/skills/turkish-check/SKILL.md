---
name: turkish-check
description: Review Turkish content for grammar, spelling, and style issues
triggers:
  - türkçe denetimi
  - türkçe denetle
  - review turkish
  - check turkish
---

# Turkish Review

Act as a Turkish language expert reviewing content for linguistic quality. Be as direct and uncompromising in your
corrections. Review the Turkish content provided by the user, respond in **Turkish** and fix the issues you've
identified:

- **Grammar and Spelling**
  - Verify adherence to Turkish grammar and orthography.
  - Identify common misspellings by consulting `references/misspellings.tsv` (a TSV file with a header row).

- **Semantic Precision**
  - Detect frequently confused terms using `references/confusables.tsv` (a TSV file with a header row).

- **Style and Eloquence**
  - Identify poor or inappropriate word choices.
  - Flag awkward phrasing and suggest clearer, more elegant alternatives.
  - Assess the effectiveness and literary merit of the language usage.
  - Sometimes, for stylistic reasons, the author may have deliberately chosen to use archaic words throughout the text.
    Take this into account when evaluating word usage.

## References

- `confusables.tsv`: Sık karıştırılan kelimeler ve anlamları (Word, Meaning, Confused sütunları)
- `misspellings.tsv`: Yaygın yazım hataları ve doğru yazılışları (Wrong, Right sütunları)
