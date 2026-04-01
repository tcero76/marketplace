#!/usr/bin/env python3

import subprocess
import sys
from pathlib import Path

def png_to_svg(input_png: str, output_svg: str, threshold: str = "50%"):
    input_path = Path(input_png)
    output_path = Path(output_svg)
    pbm_path = output_path.with_suffix(".pbm")

    # 1️⃣ Convert PNG -> PBM usando ImageMagick
    convert_cmd = [
        "convert",
        str(input_path),
        "-background", "white",
        "-alpha", "remove",
        "-alpha", "off",
        "-threshold", threshold,
        str(pbm_path)
    ]
    subprocess.run(convert_cmd, check=True)
    print(f"PBM generado: {pbm_path}")

    # 2️⃣ Convert PBM -> SVG usando Potrace
    potrace_cmd = [
        "potrace",
        str(pbm_path),
        "-s",  # generar SVG
        "-o",
        str(output_path)
    ]
    subprocess.run(potrace_cmd, check=True)
    print(f"SVG generado: {output_path}")

    # Opcional: eliminar PBM temporal
    pbm_path.unlink(missing_ok=True)
    print("Archivo temporal PBM eliminado.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python png_to_svg.py input.png output.svg")
        sys.exit(1)
    png_to_svg(sys.argv[1], sys.argv[2])