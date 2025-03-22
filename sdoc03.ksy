meta:
  id: signum3
  file-extension: SDK
  endian: be
seq:
- id: magic
  type: magic
- id: u0
  type: u4
- id: u1
  type: u2
- id: u2
  size: 128
- id: file_pointers
  type: chunk_file_pointers
instances:
  foused:
    type: chunk_fonts_used
    pos: file_pointers.content.ofs_foused01
  params:
    type: chunk_params
    pos: file_pointers.content.ofs_params01
  kapit:
    type: chunk_chapter
    pos: file_pointers.content.ofs_kapit01
  cdilist:
    type: chunk_cdilist
    pos: file_pointers.content.ofs_cdilist0
  foxlist:
    type: chunk
    pos: file_pointers.content.ofs_foxlist
  chunk10:
    type: chunk
    pos: file_pointers.content.u10
types:
  magic:
    seq:
      - contents: [0, 0]
        size: 2
      - id: sdoc
        contents: "sdoc  03"
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
      - id: u1
        type: u2
      - id: content
        size: len
  chunk_stream:
    seq:
      - size: 2
        contents: [0,0]
      - id: tag
        contents: "stream01"
      - id: len
        type: u4
      - id: u1
        type: u2
      - id: content
        size: len
  chunk_chapter:
    seq:
      - contents: "\0\0"
      - id: tag
        contents: "kapit 01"
      - id: len
        type: u4
      - id: u1
        type: u2
      - id: content
        size: len
      - id: stream
        type: chunk_stream
  chunk_file_pointers:
    seq:
      - size: 2
        contents: [0,0]
      - id: tag
        contents: "flptrs01"
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
          - id: ofs_foxlist
            type: u4
          - id: u5
            type: u4
          - id: u6
            type: u4
          - id: u7
            type: u4
          - id: u8
            type: u4
          - id: ofs_kapit01
            type: u4
          - id: u10
            type: u4
  chunk_fonts_used:
    seq:
      - size: 2
        contents: [0, 0]
      - id: tag
        contents: "foused01"
      - id: len
        type: u4
      - id: u1
        type: u2
      - id: content
        size: len
        type: font
    types:
      fonts:
        seq:
          - id: font
            type: font
            repeat: eos
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
        contents: "params01"
      - id: len
        type: u4
      - id: u1
        type: u2
      - id: content
        size: len
  chunk_cdilist:
    seq:
      - size: 2
        contents: [0, 0]
      - id: tag
        contents: "cdilist0"
      - id: len
        type: u4
      - id: u1
        type: u2
      - id: content
        size: len
