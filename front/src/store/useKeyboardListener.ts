import { useEffect } from "react";

type ActionMap = {
  [action: string]: () => void
};
type KeyMap = { [combo: string]: string };

const defaultKeyMap: KeyMap = {
  ArrowUp: "Incrementa",
  ArrowDown: "Decrece",
  r: "Reset",
};

function normalizeKeyEvent(e: KeyboardEvent): string {
  const keys: string[] = [];
  if (e.ctrlKey) keys.push("Control");
  if (e.shiftKey) keys.push("Shift");
  if (e.altKey) keys.push("Alt");
  keys.push(e.key);
  return keys.join("+");
}

export function useGlobalKeyboard(actions: ActionMap, keyMap: KeyMap = defaultKeyMap) {
  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      const combo = normalizeKeyEvent(event);
      const actionName = keyMap[combo];
      if (!actionName) return;
      const actionFn = actions[actionName];
      if (actionFn) {
        event.preventDefault();
        actionFn();
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => {
      window.removeEventListener("keydown", handleKeyDown);
    };
  }, [actions, keyMap]);
}
