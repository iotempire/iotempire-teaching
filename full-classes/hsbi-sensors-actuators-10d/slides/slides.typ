// Pandoc → Typst template for slide decks.
//
//   pandoc deck.md --pdf-engine=typst --template=slides.typ \
//          --lua-filter=pagebreak.lua -o deck.pdf
//
// Slides are separated by `---` in the Markdown; pagebreak.lua turns each
// thematic break into a Typst #pagebreak(). This template sets a 16:9
// presentation page and slide-sized type.

#set page(paper: "presentation-16-9", margin: 1.2cm, numbering: none)
#set text(size: 17pt, font: "DejaVu Sans")
#set par(justify: false)
#set list(indent: 1.1em)

#show heading.where(level: 1): set text(size: 30pt, weight: "bold")
#show heading.where(level: 2): set text(size: 25pt, weight: "bold")
#show heading.where(level: 3): set text(size: 21pt)

$body$
