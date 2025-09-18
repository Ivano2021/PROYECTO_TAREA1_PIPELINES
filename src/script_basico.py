#!/usr/bin/env python3
import argparse
from pathlib import Path
import pandas as pd
import numpy as np

def main():
    parser = argparse.ArgumentParser(
        description="Lee un CSV (opcional) y calcula estadísticas. Si no hay CSV, genera datos sintéticos."
    )
    parser.add_argument(
        "-i", "--input",
        type=str,
        default="",
        help="Ruta a CSV de entrada con columnas [grupo, valor] (opcional)."
    )
    parser.add_argument(
        "-o", "--output",
        type=str,
        default="outputs/estadisticas.csv",
        help="Ruta del CSV de salida (por defecto: outputs/estadisticas.csv)."
    )
    args = parser.parse_args()

    # Cargar CSV si existe, si no generar dataset sintético
    if args.input and Path(args.input).is_file():
        df = pd.read_csv(args.input)
    else:
        rng = np.random.default_rng(42)
        df = pd.DataFrame({
            "grupo": np.repeat(list("ABC"), 10),
            "valor": rng.normal(loc=10, scale=2, size=30).round(3)
        })

    # Validar columnas mínimas
    if not {"grupo", "valor"}.issubset(df.columns):
        raise ValueError("El DataFrame debe tener columnas 'grupo' y 'valor'.")

    # Estadísticas globales
    stats_global = df["valor"].agg(["count", "mean", "std", "min", "max"]).to_frame(name="global")

    # Estadísticas por grupo
    stats_group = df.groupby("grupo")["valor"].agg(["count", "mean", "std", "min", "max"])

    # Guardar resultados
    out_path = Path(args.output)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    with out_path.open("w", encoding="utf-8") as f:
        f.write("# Estadísticas globales\n")
        stats_global.to_csv(f)
        f.write("\n# Estadísticas por grupo\n")
        stats_group.to_csv(f)

    # Mostrar en consola
    print("=== Estadísticas globales ===")
    print(stats_global)
    print("\n=== Estadísticas por grupo ===")
    print(stats_group)
    print(f"\n✅ Archivo generado: {out_path}")

if __name__ == "__main__":
    main()
