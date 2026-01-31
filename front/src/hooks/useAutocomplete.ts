import { useEffect, useState } from "react";
import { getCaretCoordinates } from "../utils/caret";
import { AutocompleteConfig } from "../types/highlight";

export function useAutocomplete(
  suggestions: HTMLUListElement,
  config:AutocompleteConfig) {
  const [dictionary, setDictionary] = useState<string[]>([])
  const regex = new RegExp(`\\${config.trigger}[\\w]*$`)
  useEffect(() => {
    config.loadDictionary().then(setDictionary)
  }, [])
  const showSuggestions = (options: string[], range: Range) => {
    suggestions.innerHTML = "";
    options.forEach((opt) => {
      const li = document.createElement("li");
      li.classList.add("list-group-item", "list-group-item-action");
      li.textContent = opt;
      li.addEventListener("click", () => {
        insertSuggestion(opt, range);
        suggestions.classList.add("d-none");
      });
      suggestions.appendChild(li);
    });
    const rect = getCaretCoordinates(range);
    suggestions.style.left = rect.left + "px";
    suggestions.style.top = rect.bottom + "px";
    suggestions.classList.remove("d-none");
  }
  const insertSuggestion = (word: string, range: Range) => {
    const textNode = range.startContainer;
    const text = textNode.textContent ?? "";
    const before = text.slice(0, range.startOffset).replace(regex, word);
    const after = text.slice(range.startOffset);
    textNode.textContent = before + after;
    const sel = window.getSelection();
    const newRange = document.createRange();
    newRange.setStart(textNode, before.length);
    newRange.collapse(true);
    sel?.removeAllRanges();
    sel?.addRange(newRange);
  }
  const onKey = () => {
    const sel = window.getSelection();
    if (!sel || sel.rangeCount === 0) return;
    const range = sel.getRangeAt(0);
    const textBeforeCaret = range.startContainer.textContent?.slice(0, range.startOffset) ?? "";
    const match = textBeforeCaret.match(regex);
    if (match) {
      const current = match[0];
      const options = dictionary.filter((d) => d.toLowerCase().startsWith(current.toLowerCase())).slice(0, 5);;
      if (options.length > 0) {
        showSuggestions(options, range);
      } else {
        suggestions.classList.add("d-none");
      }
    } else {
        suggestions.classList.add("d-none");
    }
  }
  return { onKey };
}