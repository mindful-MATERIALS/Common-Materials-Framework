# Common Materials Framework

The Common Materials Framework (CMF) is a shared language for product sustainability, designed to be adopted across the building industry. It is certification-agnostic: it sets out a hierarchical data structure within which any certification or standard can show how it aligns to impact.

A CMF document describes one product's sustainability attributes across five impact areas: Human Health, Climate Health, Circular Economy, Social Health & Equity, and Ecosystem Health. Every value records the data source it came from.

## Contents

| Path | What it is |
|---|---|
| [`schema/v1/CMF_STRUCTURE.md`](schema/v1/CMF_STRUCTURE.md) | Structure reference: document envelope, sources, every field, and the allowed values |
| [`schema/v1/CMF_STRUCTURE.pdf`](schema/v1/CMF_STRUCTURE.pdf) | The same reference as a printable PDF |
| [`schema/v1/cmf-structure.schema.json`](schema/v1/cmf-structure.schema.json) | Machine-readable definition (JSON Schema, draft 2020-12) for validating CMF documents |
| [`tools/build_pdf.sh`](tools/build_pdf.sh) | Builds the PDF from the Markdown reference (needs pandoc and Chrome): `tools/build_pdf.sh schema/v1/CMF_STRUCTURE.md` |

## Versioning

Each CMF document carries a top-level `schemaVersion`. The files for each structure version live under `schema/v<N>/`. A new version is published whenever a field is added, removed, renamed or retyped, or the way a value is serialized changes.
