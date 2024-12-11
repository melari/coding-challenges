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
- `#rotate_clockwise`: the vector rotated 90 degrees clockwise
- `#rotate_counterclockwise`: the vector rotated 90 degress counter-clockwise
- `#neighbours(include_diagonal)`: list of vectors one unit away in each direction
- `#bounded_neighbours(...)`: list of neighbours (see above), which meet the condition of being inside the given dimensions.
    - `#bounded_neighbours(minx, miny, maxx, maxy)`: manually specify the bounds with numbers
    - `#bounded_neighbours(width, height)`: minx & miny assumed to be (0, 0)
    - `#bounded_neighbours(dimensions)`: where dimensions is a vect2 of width/height
- `#in_bounds?(minx:, miny:, maxx:, maxy:):`: checks if this vector is within the given bounds

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

### instance methods

- `#w`: width of the grid
- `#h`: height of the grid
- `#dim`: width/height dimension of the grid as a Vect2
- `#map { |value, position| }`: transforms a grid into another grid after transforming each value once
- `#rows`: enumerator that yields each row in order
- `#columns`: enumerator that yields each column in order
- `#values`: enumerator that yields all values in the grid one by one, in reading order.
- `#values_with_positions`: enumerator that yields each value with its (x,y) position

```
Vect2.new(...).values_with_positions.each { |value, (x, y)| ... }
```
