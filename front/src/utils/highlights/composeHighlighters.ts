import { Highlighter, HighlightResult, MetaRaw } from "@/types";

function getTextValue(value: unknown): string {
  if (typeof value === "string") return value;

  if (typeof value === "object" && value !== null) {
    if ("nombre" in value && typeof value.nombre === "string") {
      return value.nombre;
    }
  }

  return "";
}

const cleanTexto = (texto: string, metaRaw: MetaRaw) => {
    let result = texto;
    Object.values(metaRaw).forEach(arr => {
        arr?.forEach(value => {
        const text = getTextValue(value);
        if (!text) return;
        result = result.replace(text, '');
        });
    });
    const resp = result.trim().replace(/\s+/g, ' ');
    return resp
};

export const composeHighlighters =
  (...highlighters: Highlighter[]): Highlighter =>
  (text: string) => {
    const highlight = highlighters.reduce<HighlightResult>(
      (acc, h) => {
        const res = h(acc.html)
        const mergedMeta: MetaRaw = { ...acc.metaRaw }
        for (const key of Object.keys(res.metaRaw) as (keyof MetaRaw)[]) {
        const value = res.metaRaw[key]
        if (!value) continue
        mergedMeta[key] = [
          ...(mergedMeta[key] ?? []),
          ...value
        ] as any
      }
        return {
          html: res.html,
          metaRaw: mergedMeta,
          cleanText: ''
        }
      },
      { html: text, metaRaw: {} as MetaRaw, cleanText: '' }
    )
    return { ...highlight, cleanText: cleanTexto(text, highlight.metaRaw) }
  }
