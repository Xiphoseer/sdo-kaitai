meta:
  id: signum_sdoc0001
  file-extension: SDO
  endian: be
seq:
  - id: header
    type: header
  - id: meta
    type: meta
  - id: chunks
    type: chunk
    repeat: eos
types:
  header:
    seq:
      - id: format
        contents: 'sdoc'
      - id: version
        contents: '0001'
  meta:
    seq:
      - id: len
        type: u4
      - id: data
        size: len
  cset:
    seq:
      - id: chsets
        type: strz
        encoding: ASCII
        size: 10
        repeat: expr
        repeat-expr: 8
  sysp:
    seq:
      - size: 80
      - id: space_width
        doc: Space between words in horizontal units
        type: u2
      - id: letter_spacing
        doc: Sperrung
        type: u2
      - id: line_distance
        doc: Hauptzeilenabstand
        type: u2
      - id: index_distance
        doc: Indexabstand
        type: u2
      - id: margins
        type: margins
      - id: page_length
        doc: Seitenlänge
        type: u2
      - id: page_numbering
        doc: 0x5800 == keine Seitennummerierung
        type: u2
      - id: format_options
        doc: 0b10011 == format. optionen
        type: u2
      - id: unknown
        doc: 0x302 == trennen
        type: u2
      - id: borders
        doc: 0 == Randausgleiche und Sperren
        type: u2
      - id: flags
        doc: 1 == nicht einrücken, Absatzabstand mitkorrigieren
        type: u4
  pbuf:
    seq:
      - id: page_count
        type: u4
      - id: entry_len
        type: u4
      - id: first_page_num
        type: u4
      - id: unde
        type: unde
        repeat: expr
        repeat-expr: 5
      - id: entries
        type: entry
        repeat: expr
        repeat-expr: page_count
    types:
      unde: { seq: [{ id: unde, contents: 'unde' }] }
      entry:
        seq:
          - id: index
            type: u2
          - id: phys_page_nr
            type: u2
          - id: log_page_nr
            type: u2
          - id: height # ???
            type: u2
          - id: margins
            type: margins
          - id: unknown
            size: 18
  tebu:
    doc: Text Buffer
    seq:
      - id: line_count
        type: u4
      - id: lines
        type: line
        repeat: eos
    types:
      line:
        seq:
          - id: vskip
            type: u2
          - id: length
            type: u2
          - id: data
            type: line_data
            size: length
            if: "length > 0 and length < 2048"
      line_data:
        seq:
          - id: tag
            type: line_tag
          - id: pnum
            if: tag.has_page_num
            type: u2
          - id: hskip
            if: tag.has_hskip
            type: u2
          - id: data
            type: character
            repeat: eos
      character:
        meta:
          bit-endian: be
        seq:
          - id: short
            type: b1
          - id: short_offset
            if: short
            type: b6
          - id: short_chset
            if: short
            type: b2
          - id: underlined
            if: not short
            type: b1
          - id: mark1
            if: not short
            type: b1
          - id: mark2
            if: not short
            type: b1
          - id: mark3
            if: not short
            type: b1
          - id: footnote
            if: not short
            type: b1
          - id: wide_chset
            if: not short
            type: b3
          - id: char
            type: b7
          - id: wide
            type: b1
            if: not short
          - id: bold
            type: b1
            if: not short
          - id: italic
            type: b1
            if: not short
          - id: tall
            type: b1
            if: not short
          - id: small
            type: b1
            if: not short
          - id: wide_offset
            type: b11
            if: not short
        instances:
          chset_index:
            value: 'short ? short_chset : wide_chset'
          offset:
            value: 'short ? short_offset : wide_offset'
          cset:
            if: short
            value: _root.chunks[0].data.as<cset>.chsets[chset_index]
      line_tag:
        meta:
          bit-endian: be
        seq:
          - id: page_command
            type: b1
          - id: page_start
            type: b1
          - id: page_end
            type: b1
          - id: non_text
            type: b1
          - id: paragraph
            type: b1
          - id: standard_line
            type: b1
          - id: unknown_0200
            type: b1
          - id: unknown_0100
            type: b1
          - id: has_page_num
            type: b1
          - id: unknown_0040
            type: b1
          - id: unknown_0020
            type: b1
          - id: unknown_0010
            type: b1
          - id: unknown_0008
            type: b1
          - id: unknown_0004
            type: b1
          - id: unknown_0002
            type: b1
          - id: has_hskip
            type: b1
  hcim:
    seq:
      - id: site_table_len
        type: u4
      - id: img_count
        type: u2
      - id: site_count
        type: u2
      - id: unknown
        size: 8
      - id: site_table
        type: site_table
        size: site_table_len
      - id: img_table
        type: img_table
    types:
      image:
        seq:
          - id: len
            type: u4
          - id: name
            type: strz
            size: 28
            encoding: ASCII
          - id: data
            size: len - 32
      site:
        seq:
          - id: page
            type: u2
          - id: pos_x
            type: u2
          - id: pos_y
            type: u2
          - id: site_w
            type: u2
          - id: site_h
            type: u2
          - id: unknown1
            type: u2
          - id: sel_x
            type: u2
          - id: sel_y
            type: u2
          - id: sel_w
            type: u2
          - id: sel_h
            type: u2
          - id: unknown2
            type: u2
          - id: unknown3
            type: u2
          - id: unknown4
            type: u2
          - id: img
            type: u2
          - id: unknown5
            type: u2
          - id: unknown6
            size: 2
      site_table:
        seq:
          - id: sites
            repeat: expr
            repeat-expr: _parent.site_count
            type: site
            size: 32
      img_table:
        seq:
          - id: images
            repeat: expr
            type: image
            repeat-expr: _parent.img_count
  chunk:
    seq:
      - id: tag
        type: str
        encoding: ASCII
        size: 4
      - id: size
        type: u4
      - id: data
        size: size
        type:
          switch-on: tag
          cases:
            '"cset"': cset
            '"sysp"': sysp
            '"pbuf"': pbuf
            '"tebu"': tebu
            '"hcim"': hcim
  margins:
    seq:
      - id: left
        type: u2
      - id: right
        type: u2
      - id: header
        type: u2
      - id: footer
        type: u2
