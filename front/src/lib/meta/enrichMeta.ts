import { Meta, MetaRaw, Ts, Tses } from "@/types";
import { Servicios } from "@/types/servicios";

  const enrichMeta = (
    metaRaw: MetaRaw,
    tses: Tses[],
    servicios: Servicios[]
  ): Meta => {
    const normalize = (s?: string) => s ? s.slice(1).toLowerCase() : "";
    return {
      mentions: tses.filter(t =>
        metaRaw.mentions?.some(m => normalize(m) === t.nombre.replace(/\s+/g, "").toLowerCase())
      ),
      hashtags: servicios.filter(s =>
        metaRaw.hashtags?.some(h => normalize(h) === s.nombre.replace(/\s+/g, "").toLowerCase())
      ),
      urls: metaRaw.urls
    };
  }

  export default enrichMeta;