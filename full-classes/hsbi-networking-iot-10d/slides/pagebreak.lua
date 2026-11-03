-- Pandoc Lua filter for slide decks.
--
--  * A Markdown thematic break (`---`) becomes a Typst page break, so each
--    `---`-separated slide gets its own page.
--  * Raw HTML is dropped, so `<!-- ... -->` notes in the deck do not reach
--    the PDF (they stay readable in the Markdown source).

function HorizontalRule()
  return pandoc.RawBlock("typst", "#pagebreak()")
end

function RawBlock(el)
  if el.format:match("html") then
    return {}
  end
end

function RawInline(el)
  if el.format:match("html") then
    return {}
  end
end
