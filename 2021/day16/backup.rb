PACKET_TYPES = {
  0 => :sum,
  1 => :product,
  2 => :minimum,
  3 => :maximum,
  4 => :literal,
  5 => :greater_than,
  6 => :less_than,
  7 => :equal,
}

input = File.read("input.txt").split('')[0..-2].map { |c| c.to_i(16).to_s(2).rjust(4, '0') }.join('').split('')

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
  sub_packet_values = packet[:contents][:sub_packets].map { |p| evaluate(p) } unless packet[:type] == :literal

  case packet[:type]
  when :sum
    sub_packet_values.sum
  when :product
    sub_packet_values.reduce(nil) { |r, value| r.nil? ? value : r * value }
  when :minimum
    sub_packet_values.min
  when :maximum
    sub_packet_values.max
  when :literal
    packet[:contents][:value]
  when :greater_than
    sub_packet_values.first > sub_packet_values.last ? 1 : 0
  when :less_than
    sub_packet_values.first < sub_packet_values.last ? 1 : 0
  when :equal
    sub_packet_values.first == sub_packet_values.last ? 1 : 0
  end
end

ast = parse_packet(input)
pp ast
pp evaluate(ast) 
