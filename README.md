This repo has some helper classes commonly used for coding challenges.

## Vect2
A simple (x,y) vector

### class methods

- `::zero`: the vector [0,0]
- `::up`: the vector [0,-1]
- `::down`: the vector [0, 1]
- `::right`: the vector [1, 0]
- `::left`: the vector [-1, 0]
- `::upright`: the vector [1, -1]
- `::upleft`: the vector [-1, -1]
- `::downright`: the vector [1, 1]
- `::downleft`: the vector [-1, 1]

### instance methods

- `#x`: the x component of the vector
- `#y`: the y component of the vector
- `#%(other)`: piece-wise modulus (ie x % other.x, y % other.y)
- `#rotate_clockwise`: the vector rotated 90 degrees clockwise
- `#rotate_counterclockwise`: the vector rotated 90 degress counter-clockwise
- `#neighbours(include_diagonal)`: list of vectors one unit away in each direction
- `#bounded_neighbours(...)`: list of neighbours (see above), which meet the condition of being inside the given dimensions. Valid args should match `in_bounds?`.
  - `#bounded_neighbours(bounds)`: list of non-diagonal neighbours where "bounds" matches arguments for `in_bounds?`.
  - `#bounded_neighbours(include_diagonal: t/f, bounds: bounds)`
- `#bounded_edges(...)`: list of neighbours, which do not meet the condition of being inside the given dimensions. (Opposite of `bounded_neighbours`)
- `#in_bounds?(...):`: checks if this vector is within the given bounds
    - `#in_bounds?(minx:, miny:, maxx:, maxy:)`: manually specify the bounds with numbers
    - `#in_bounds?(width, height)`: minx & miny assumed to be (0, 0)
    - `#in_bounds?(dimensions)`: where dimensions is a vect2 of width/height
- `#manhatten(other)`: manhatten distance from this vector to the other.

### other features

- Vectors can be summed with other vectors, and scaled with numbers.
- Vectors can be expanded in block params (eg `[Vect2[0,0]].each { |(x, y)| ... }`)

## Grid
A 2D array of values. Indexing by x/y is conviently *in order* (ie x before y), or by vector.

```
grid = Grid.new([[1, 2, 3], [4, 5, 6]])
puts grid[1, 1]          # 5
puts grid[Vect2[2, 2]]   # 6
grid[1, 2] = 42
grid[Vect2[0, 0]] = 10
```

### class methods

- `::from_file(filepath, row_divider: "\n", column_divider: "")`: reads in the file and splits sections into a grid
- `::from_str(string, row_divider: "\n", column_divider: "")`: parses a string and splits sections into a grid
- `::init_by_position(dim:) { |x,y| value }`: creates a new grid of the given dimensions, initializing the value at each cell using the block.

### instance methods

- `#w`: width of the grid
- `#h`: height of the grid
- `#dim`: width/height dimension of the grid as a Vect2
- `#map { |value, position| }`: transforms a grid into another grid after transforming each value once
- `#find_pos { |value| predicate }`: finds the first position that matches the predicate
- `#rows`: enumerator that yields each row in order
- `#columns`: enumerator that yields each column in order
- `#values`: enumerator that yields all values in the grid one by one, in reading order.
- `#values_with_positions`: enumerator that yields each value with its (x,y) position
- `#neighbours(pos, include_diagonal: false)`: gives the neighbours of the given position. Each element of the returned array is a tuple of the form `[pos, value]`
- `#dup`: dups the grid itself but not the elements in the cells.
- `#deep_dup`: dups the grid and calls `dup` on all elements.

```
Vect2.new(...).values_with_positions.each { |value, (x, y)| ... }
```

## PQ
A priority queue with O(logn) write and O(1) read.
The priority heuristic can be customized in a few ways:

```
PQ.increasing  # increasing order of the literal values
PQ.increasing { |value| value.score } # increasing order by some other score function
PQ.new(-> (a, b) { ... })   # fully customized heuristic
```

### class methods

- `::increasing(&block)`: create a new PQ with an increasing heuristic
- `::decreasing(&block)`: create a new PQ with a decreasing heuristic

### instance methods

- `#push(value)`: insert a value into the queue
- `#<<(value)`: alias for `push`
- `#pop`: remove and return the highest priority item
- `#peek`: look at the highest priority item without removing it from the queue
- `#length`: length of the queue
- `#empty?`: true if the queue has no entries
- `#any?`: true if the queue has at least one entry
