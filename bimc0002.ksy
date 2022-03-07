meta:
  id: bimc0002
  file-extension: IMC
  endian: be
seq:
  - id: format
    contents: 'bimc'
  - id: version
    contents: '0002'
  - id: header
    type: header
    size: 32
  - id: data
    type: data
    size: header.compressed_size - 32
types:
  data:
    seq:
      - id: bit_stream
        size: _root.header.bit_stream_byte_count
      - id: byte_stream
        size: _root.header.byte_stream_byte_count
  header:
    seq:
      - id: compressed_size
        type: u4
      - id: uncompressed_width
        type: u2
      - id: uncompressed_height
        type: u2
      - id: num_chunks_horizontal
        type: u2
      - id: num_chunks_vertical
        type: u2
      - id: bit_stream_byte_count
        type: u4
      - id: byte_stream_byte_count
        type: u4
      - id: final_xor
        type: u2
