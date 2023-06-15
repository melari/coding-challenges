PACKET_TYPES = {
  4 => :literal
}

input = File.read("input.txt").split('')[0..-2].map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join('').split('')

#input = "110100101111111000101000".split('')
#
#input = "00111000000000000110111101000101001010010001001000000000".split('')
#
#input = "11101110000000001101010000001100100000100011000001100000".split('')
#
#input = "8A004A801A8002F478".split('').map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join('').split('')
#input = "620080001611562C8802118E34".split('').map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join('').split('')
#input = "C0015000016115A2E0802F182340".split('').map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join('').split('')
#input = "A0016C880162017C3686B18A3D4780".split('').map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join('').split('')

puts "Input: #{input.join('')}"
puts ""

def parse_packet(input)
  raw_version = input.shift(3)
  raw_type_id = input.shift(3)
  version = raw_version.join('').to_i(2)
  type_id = raw_type_id.join('').to_i(2)
  type = PACKET_TYPES[type_id]

  contents = case type
  when :literal
    parse_literal(input)
  else
    parse_operator(input)
  end

  raw = raw_version + raw_type_id + contents[:raw]

  {
    kind: :packet,
    raw_version: raw_version,
    raw_type_id: raw_type_id,
    version: version,
    type_id: type_id,
    type: type,
    contents: contents,
    raw: raw
  }
end

def parse_literal(input)
  raw = []
  digits = []
  loop do
    digit = input.shift(5)
    raw += digit
    digits << digit[1..-1] # first bit is a serialization marker, not part of the literal digits
    break if digit.first == '0'
  end
  value = digits.flatten.join('').to_i(2)
  {
    kind: :literal,
    value: value,
    digits: digits,
    raw: raw
  }
end

def parse_operator(input)
  length_type_flag = input.shift(1)

  sub_packets = []

  if length_type_flag == ['0']
    raw_length = input.shift(15)
    length = raw_length.join('').to_i(2)
    raw_packets = input.shift(length)
    sub_packets << parse_packet(raw_packets) until raw_packets.empty?
  else
    raw_count = input.shift(11)
    count = raw_count.join('').to_i(2)
    count.times { sub_packets << parse_packet(input) }
  end

  #TODO this raw does include the raw_length/raw_count right now
  raw = length_type_flag + sub_packets.flat_map { |p| p[:raw] }

  {
    kind: :operator,
    sub_packets: sub_packets,
    raw: raw
  }
end

def evaluate(packet)
  total_version = packet[:version]
  case packet[:type]
  when :literal
    # noop
  else
    total_version += packet[:contents][:sub_packets].sum { |p| evaluate(p) }
  end
  total_version
end

ast = parse_packet(input)
pp evaluate(ast) 
