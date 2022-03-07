meta:
  id: signum_eset0001
  file-extension: E24
  endian: be
  doc: |
    E24 is the bitmap font format used to display characters on screen in the
    Signum! Text Editor.
seq:
  - id: header
    type: header
  - id: section1
    type: section1
  - id: section2
    type: section2
types:
  header:
    seq:
      - id: format
        contents: 'eset'
      - id: version
        contents: '0001'
  section1:
    seq:
      - id: len
        type: u4
      - id: data
        size: len
  section2:
    seq:
      - id: len
        type: u4
      - id: characters
        type: character
        repeat: expr
        repeat-expr: 127
      - id: data
        type: glyphdata
        size: len
  glyphdata:
    seq: []
  character:
    seq:
      - id: offset
        type: u4
    instances:
      dimensions:
        io: _parent.data._io
        pos: offset
        type: glyph
        size: 4
      pixels:
        io: _parent.data._io
        pos: offset + 4
        type: pixels
        size: dimensions.height * 2
  glyph:
    seq:
      - id: top
        type: u1
      - id: height
        type: u1
      - id: width
        type: u1
      - id: unknown
        type: u1
  pixels:
    seq:
      - type: u2
        repeat: expr
        repeat-expr: _parent.dimensions.height

