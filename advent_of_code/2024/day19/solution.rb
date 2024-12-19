@stripes, patterns = File.read('input.txt').split("\n\n")
@stripes = @stripes.split(', ')
patterns = patterns.split("\n")

@cache = {}
def cache(key, &block)
  return @cache[key] if @cache[key]
  result = yield
  @cache[key] = result
  result
end

def count_ways_possible(pattern)
  cache(pattern) do
    @stripes.sum do |stripe|
      next 0 unless pattern.start_with?(stripe)
      next 1 if pattern == stripe
      count_ways_possible(pattern[stripe.length..])
    end
  end
end

# part 1
puts patterns.count { |pattern| count_ways_possible(pattern) > 0 }

# part 2
puts patterns.sum { |pattern| count_ways_possible(pattern) }
