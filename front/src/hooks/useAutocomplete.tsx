import { useState } from "react";
import { getCaretCoordinates } from "../utils/caret";
import { AutocompleteConfig, Options } from "../types/highlight";
import { Popover,
  PopoverContent } from '@/components/ui/popover';
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandItem,
  CommandList } from '@/components/ui/command';
import {
  Item,
  ItemContent,
  ItemDescription } from '@/components/ui/item';

export function useAutocomplete(
  config:AutocompleteConfig) {
  const [listado, setListado] = useState<Options>()
  const [selectedIndex, setSelectedIndex] = useState<number>(0)
  const [show, setShow] = useState<boolean>(false)
  const regex = new RegExp(`\\${config.trigger}[\\w]*$`)
  if(config.categories.length === 0) {
    return {
      onKey: () => {},
      AutocompleteList: () => null
    }
  }
  const showSuggestions = (options: string[], range: Range) => {
    const rect = getCaretCoordinates(range);
    console.log("🚀 ~ showSuggestions ~ rect:", rect)
    setListado({
      options,
      left: rect.left + "px",
      top: rect.top + "px"})
    if(options.length > 0) {
      setShow(true)
    } else {
      setShow(false)
    }
  }
  const insertSuggestion = (word: string) => {
    const sel = window.getSelection();
    if (!sel || sel.rangeCount === 0) return;
    const range = sel.getRangeAt(0);
    const textNode = range.startContainer;
    const text = textNode.textContent ?? "";
    const before = text.slice(0, range.startOffset).replace(regex, word);
    const after = text.slice(range.startOffset);
    textNode.textContent = before + after;
    const newRange = document.createRange();
    newRange.setStart(textNode, before.length);
    newRange.collapse(true);
    sel?.removeAllRanges();
    sel?.addRange(newRange);
    const editor = textNode.parentElement;
    editor?.dispatchEvent(new Event('input', { bubbles: true }));
    setShow(false);
  }
  const onKey = (e: React.KeyboardEvent<HTMLDivElement>) => {
    const sel = window.getSelection();
    if (!sel || sel.rangeCount === 0) return;
    const range = sel.getRangeAt(0);
    const container = range.startContainer;
    if (container.nodeType !== Node.TEXT_NODE) return;
    const text = container.textContent ?? "";
    const textBeforeCaret = text.slice(0, range.startOffset);
    const match = textBeforeCaret.match(regex);
    if (match) {
      const current = match[0].toLowerCase();
      if(current.length === 1) {
        setShow(false)
        return
      }
      const options = config.categories
        .map(m =>m.replace(/\s+/g, "")) 
        .map(m => `${config.trigger}${m}`)
        .filter((d) => d.toLowerCase().startsWith(current))
        .slice(0, 5);
      showSuggestions(options, range);
    }
    const options = listado?.options ?? [];
    if (!(options.length > 0)) return;
      if (show) {
      switch (e.key) {
        case "ArrowDown":
          e.preventDefault();
          setSelectedIndex((prev) => (prev + 1) % options.length);
          break;
        case "ArrowUp":
          e.preventDefault();
          setSelectedIndex((prev) => (prev - 1 + options.length) % options.length);
          break;
        case "Escape":
          e.preventDefault();
          setSelectedIndex(0);
          setShow(false);
          break;
        case "Enter":
          e.preventDefault();
          const selected = options[selectedIndex];
          if (selected) {
            insertSuggestion(selected);
            setSelectedIndex(0);
          }
          break;
      }
    }
  }

const AutocompleteList = () => {
  if (!show || !listado) return null
  return (
    <Popover open={show}>
        <PopoverContent
          onOpenAutoFocus={(e) => e.preventDefault()}
          style={{ left: listado.left, top: listado.top }}
          className={`w-[--radix-popover-trigger-width] p-0 bg-white fixed`}
          align="start">
          <Command>
            <CommandList>
              <CommandEmpty>No se encontraron resultados.</CommandEmpty>
              <CommandGroup>
                {listado?.options.map((opt,idx) => {
                  const classItem = "w-full p-2 cursor-pointer " +
                   (idx === selectedIndex ? "bg-blue-100" : "")
                  return(
                    <CommandItem
                      key={idx}
                      onMouseDown={(e) => e.preventDefault()}
                      onSelect={() => insertSuggestion(opt)}
                      >
                      <Item className={classItem}>
                        <ItemContent className="gap-0">
                          <ItemDescription className="leading-none">
                            {opt}
                          </ItemDescription>
                        </ItemContent>
                      </Item>
                    </CommandItem>
                  )
                })}
              </CommandGroup>
            </CommandList>
          </Command>
        </PopoverContent>
    </Popover>
  )}
  return {
    onKey,
    AutocompleteList
  }
}