meta:
  id: signum3
  file-extension: SDK
  endian: be
seq:
- contents: [0, 0]
  size: 2
- id: tag
  type: str
  encoding: ascii
  size: 8
  valid: '"sdoc  03"'
- contents: [0, 0]
  size: 2
- id: len
  type: u2
- type: u2
- id: header
  size: len
  type: header
- id: file_pointers
  type: chunk_file_pointers
instances:
  fonts_used:
    type: chunk_fonts_used
    pos: file_pointers.content.ofs_foused01
  params:
    type: chunk_params
    pos: file_pointers.content.ofs_params01
  cdi_list:
    type: chunk_cdilist
    if: file_pointers.content.ofs_cdilist0 > 0
    pos: file_pointers.content.ofs_cdilist0
  foxlist:
    type: chunk
    if: file_pointers.content.ofs_trailer > 0
    pos: file_pointers.content.ofs_trailer
  chapters:
    #type: chapter
    type: chapter_ref(_index)
    repeat: expr
    repeat-expr: file_pointers.content.ofs_chapters.size
types:
  header:
    seq: []
  chapter_ref:
    params:
      - id: i
        type: u4
    instances:
      pos:
        value: _parent.file_pointers.content.ofs_chapters[i]
      body:
        pos: _parent.file_pointers.content.ofs_chapters[i]
        io: _parent._io
        type: chapter
  chapter:
    seq:
      - id: kapit
        type: chunk_chapter
      - id: body
        type: chunk_stream
      - id: header_footer
        type: chunk_stream
      - id: index
        type: chunk_stream
        if: kapit.content.v9 >= 0
      - id: footnotes
        type: chunk_stream
        if: kapit.content.v10 >= 0
  chunk:
    seq:
      - size: 2
        contents: [0,0]
      - id: tag
        size: 8
        type: str
        encoding: ascii
      - id: len
        type: u4
      - type: u2
      - id: content
        size: len
  chunk_stream:
    seq:
      - size: 2
        contents: [0,0]
      - id: tag
        type: str
        encoding: ascii
        size: 8
        valid: '"stream01"'
      - id: len
        type: u4
      - type: u2
      - id: content
        size: len
        type: content
    types:
      content:
        seq:
          - id: index
            type: u2
          - id: uv1
            type: u2
          - id: count
            type: u2
          - id: u2
            type: u2
          - id: v1
            type: u2
          - id: v2
            type: u2
          - id: len1
            type: u2
          - id: v4
            type: u2
          - id: len3
            type: u4
          - id: ofs2
            type: u4
          - id: len2
            type: u4
          - id: iter
            size: 8
            repeat: expr
            repeat-expr: count
          - id: buf0
            size: len1
          - id: buf1
            size: len2
          - id: buf2
            size: len3
          - id: after
            type: u2
          - id: after2
            size: 2
      text:
        seq: []
          #- id: u1
          #  type: u4
          #- id: u2
          #  type: u4
          #- id: u2
          #  size: u1
  chunk_chapter:
    seq:
      - contents: "\0\0"
      - id: tag
        size: 8
        valid: '"kapit 01"'
        type: str
        encoding: ASCII
      - contents: "\0\0"
      - id: len
        type: u2
      - type: u2
      - id: content
        size: len
        type: content
    types:
      content:
        seq:
          - id: v1
            type: u2
          - id: len1
            type: u4
          - id: v3
            type: u2
          - id: v4
            type: u2
          - id: v5
            type: s2
          - id: v6
            type: s2
          - id: v7
            type: s2
          - id: v8
            type: s2
          - id: v9
            type: s2
          - id: v10
            type: s2
          - id: buf1
            size: 66
          - id: buf
            size: len1
  chunk_file_pointers:
    seq:
      - size: 2
        contents: [0,0]
      - id: tag
        valid: '"flptrs01"'
        size: 8
        type: str
        encoding: ASCII
      - id: len
        type: u4
      - id: u1
        type: u2
      - id: content
        size: len
        type: file_pointers
    types:
      file_pointers:
        seq:
          - id: ofs_foused01
            type: u4
          - id: ofs_params01
            type: u4
          - id: ofs_cdilist0
            type: u4
          - id: ofs_trailer
            type: u4
          - id: u5
            type: u4
          - id: u6
            type: u4
          - id: u7
            type: u4
          - id: u8
            type: u4
          - id: ofs_chapters
            type: u4
            repeat: eos
  chunk_fonts_used:
    seq:
      - size: 2
        contents: [0, 0]
      - id: tag
        type: str
        encoding: ASCII
        size: 8
        valid: '"foused01"'
      - id: len
        type: u4
      - type: u2
      - id: fonts
        size: 10
        type: font
        repeat: expr
        repeat-expr: len / 10
    types:
      font:
        seq:
          - id: index
            type: u1
          - id: name
            type: strz
            size: 9
            encoding: ASCII
  chunk_params:
    seq:
      - size: 2
        contents: [0, 0]
      - id: tag
        type: str
        encoding: ASCII
        size: 8
        valid: '"params01"'
      - id: len
        type: u4
      - type: u2
      - id: content
        size: len
  chunk_cdilist:
    seq:
      - size: 2
        contents: [0, 0]
      - id: tag
        type: str
        encoding: ASCII
        size: 8
        valid: '"cdilist0"'
      - id: len
        type: u4
      - type: u2
      - id: content
        size: len
