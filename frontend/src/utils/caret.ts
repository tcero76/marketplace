export function getCaretCoordinates(range: Range): DOMRect {
  let rect = range.getBoundingClientRect();
  if (rect.x === 0 && rect.y === 0) {
    const marker = document.createElement("span");
    marker.textContent = "\u200b";
    range.insertNode(marker);
    rect = marker.getBoundingClientRect();
    marker.remove();
  }
  return rect;
}

export const restoreCaretPosition = (element:HTMLDivElement, offset:number) => {
    const selection = window.getSelection();
    const range = document.createRange();
    let currentNode = null;
    let currentOffset = 0;
    const walker = document.createTreeWalker(element, NodeFilter.SHOW_TEXT, null);
    while (walker.nextNode()) {
      const node = walker.currentNode;
      const { length } = node.nodeValue ?? { length: 0};
      if (currentOffset + length >= offset) {
        currentNode = node;
        break;
      }
      currentOffset += length;
    }
    if (currentNode) {
      range.setStart(currentNode, offset - currentOffset);
      range.collapse(true);
      selection?.removeAllRanges();
      selection?.addRange(range);
    }
  };

  export const storeCaretPosition = (editor:HTMLDivElement):number => {
      const selection = window.getSelection();
      if (!selection) return 0;
      if (!selection.rangeCount) return 0;
      const range = selection.getRangeAt(0);
      const preCaretRange = range.cloneRange();
      preCaretRange.selectNodeContents(editor);
      preCaretRange.setEnd(range.endContainer, range.endOffset);
      return preCaretRange.toString().length;
  }