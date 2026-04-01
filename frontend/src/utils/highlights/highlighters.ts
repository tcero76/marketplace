import { Highlighter, HighlightResult } from "../../../../frontend/src/types/highlight";

export const hashtagHighlighter: Highlighter = (texto:string):HighlightResult => {
    const regex = /#[\p{L}\p{N}_]+/gu;
    const hashtags = texto.match(regex) ?? [];
    const html = texto.replace(regex, (palabra) => {
        const safe = palabra
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
        return `<span class="font-bold text-blue-500" contenteditable="true">${safe}</span>`;
    });
    return {html,
        meta: {
            hashtags
        } };
}

export const arrobaHighlighter: Highlighter = (texto:string):HighlightResult => {
    const regex = /@[\p{L}\p{N}_]+/gu;
    const mentions = texto.match(regex) ?? [];
    const html = texto.replace(regex, (palabra) => {
        const safe = palabra
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
        return `<span class="font-bold text-blue-500" contenteditable="true">${safe}</span>`;
    });
    return {html,
        meta: {
            mentions
        } };
}

export const httpsHighlighter: Highlighter = (texto:string):HighlightResult => {
    const regex = /https?:\/\/[^\s<>"']+/gu;
    const urls = texto.match(regex) ?? [];
    const html = texto.replace(regex, (palabra) => {
        const safe = palabra
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;");
        return `<span class="font-bold text-blue-500" contenteditable="true">${safe}</span>`;
    });
    return {html,
        meta: {
            urls
        } };
}