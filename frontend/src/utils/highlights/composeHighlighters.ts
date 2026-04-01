import { Highlighter, HighlightResult, Meta, MetaKey } from "../../../../frontend/src/types/highlight"

export const composeHighlighters =
  (...highlighters: Highlighter[]): Highlighter =>
  (text: string) =>
    highlighters.reduce<HighlightResult>(
      (acc, h) => {
        const res = h(acc.html)

        const mergedMeta: Meta = { ...acc.meta }

        for (const [key, value] of Object.entries(res.meta) as [MetaKey, string[]][]) {
          mergedMeta[key] = [
            ...(mergedMeta[key] ?? []),
            ...value
          ]
        }

        return {
          html: res.html,
          meta: mergedMeta
        }
      },
      { html: text, meta: {} }
    )
