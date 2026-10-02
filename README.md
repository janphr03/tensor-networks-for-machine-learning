# Tensor Networks for Machine Learning

Minimal English Typst template for the student research paper, following the T2000 layout.
All content, personal details, chapters, and glossary entries are placeholders.

| File | Purpose |
| --- | --- |
| `main.typ` | Personal details, front matter, chapters, glossary, and appendices |
| `layout.typ` | Fonts, page layout, headings, and lists |
| `references.bib` | Your own sources in BibLaTeX format |
| `fonts/` | Three original Latin Modern fonts and their licence |
| `tensor-networks.code-workspace` | VS Code settings, preview, and PDF build task |

## Writing

1. Open `tensor-networks.code-workspace` as a **workspace** in VS Code.
2. Open `main.typ`. Fill in the details at the top and replace placeholders with your text.
3. Open the preview with **Ctrl+K**, then **V**. It refreshes when you save with **Ctrl+S**.

Tinymist Typst and the local compiler are already installed on this computer.
After a fresh clone, install Tinymist and provide a Typst compiler;
the VS Code build task expects `.tools/typst/typst.exe`.

## Conventions

- A4, Latin Modern Roman, 12 pt, justified text with English hyphenation.
- Each chapter starts on a new page: title on the left, large pale grey number on the right.
- Running header with chapter number and title; blue section numbers; page number at the bottom right.
- Cover and declaration have no page numbers; front matter uses Roman numerals; main text starts at page 1.
- Contents, figures, tables, and appendices are collected automatically.
- Appendices use A, B, … and A.1, A.2, …; page numbers continue.
- Keep abbreviations and glossary entries in alphabetical order in `main.typ`: `/ Term: Definition`.
- Cite sources numerically in IEEE style: `@source-key`.
  To specify a page: `#cite(<source-key>, supplement: [p. 12])`.
- Cross-reference labels: `= Introduction <introduction>` and `@introduction`.
- Label equations with `$ ... $ <equation>` and reference them with `@equation`.
- Use `figure(..., caption: [...])` for figures and tables. Set `kind: image` for a diagram
  drawn with Typst so that it appears in the List of Figures.
- Optional confidentiality notice and German abstract: enable their switches at the top of `main.typ`.
- Fill in the declaration of originality and AI use with the applicable personal details.

Empty figure and table lists display a placeholder until captioned figures or tables are added.
References display the sources cited in the text.

## Build a PDF

In VS Code: **Ctrl+Shift+B** → `thesis.pdf`.
In a PowerShell terminal in the project directory:

```powershell
.\.tools\typst\typst.exe compile --root . --font-path fonts main.typ thesis.pdf
```

If Typst is installed globally, replace the local executable path with `typst`.
Use `watch` instead of `compile` to rebuild the PDF automatically when saving.
No external Typst packages are required.

Generated PDFs, local tools, and temporary files are excluded by `.gitignore`.
PDF figures and literature PDFs at other paths remain available for version control.
The original T2000 is not included in the repository.
