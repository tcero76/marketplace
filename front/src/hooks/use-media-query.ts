import { useEffect, useState } from "react"

export function useMediaQuery(query: string) {
  const [value, setValue] = useState(false)
  useEffect(() => {
    const result = window.matchMedia(query)
    setValue(result.matches)
    const listener = (event: MediaQueryListEvent) => {
      setValue(event.matches)
    }
    result.addEventListener("change", listener)
    return () => result.removeEventListener("change", listener)
  }, [query])
  return value
}