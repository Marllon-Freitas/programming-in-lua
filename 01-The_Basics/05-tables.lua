--[[
  Author: Marllon
  Date: 2025-07-15
  Book: Programming in Lua (4th ed.)
  Book Author: Roberto Ierusalimschy

  ========================================
  Part I: The Basics
  Chapter: 5 - Tables
  ========================================

  These are the notes and code examples from the fifth chapter of the book.

  obs: i have no idea what i am doing.
--]]

--------------------------------------------------------------------------------

-- [[ Tables: ]]
--[[
  Tables are the one and only data structuring mechanism in Lua.
  They are used to represent everything: arrays, sets, records, objects, packages, etc.
  At their core, tables are "associative arrays". You can think of them as a more
  powerful version of an array where the index (the "key") doesn't have to be a number.
  It can be a string, or any other Lua value except `nil`.
  Even when you write `math.sin`, Lua sees it as indexing the table named `math`
  with the string key `"sin"`.
--]]

--[[
  We can create a table using a constructor expression, which is just a pair of curly braces `{}`,
  and access elements using square brackets `[]`.
--]]
a = {} -- create an empty table

k = "x"
a[k] = 10       -- new entry, with key="x" and value=10
a[20] = "great" -- new entry, with key=20 (a number) and value="great"

print(a["x"])   --> 10

k = 20
print(a[k])         --> "great"

a["x"] = a["x"] + 1 -- you can modify entries just like variables
print(a["x"])       --> 11

--[[
  Tables in Lua are objects, not values.
  Variables do not *contain* tables; they hold a *reference* (or a pointer) to them.

  - Assigning a table to another variable (`b = a`) does NOT create a copy.
    It just creates a new reference to the same table.
  - Changes made through one reference are visible through all other references.
  - When a program has no more references to a table, Lua's garbage collector
    will eventually delete the table and free up its memory.
--]]

a = {}
a["x"] = 10

b = a         -- `b` now refers to the exact same table as `a`.

print(b["x"]) --> 10

-- Modify the table through `b`
b["x"] = 20

-- The change is visible through `a` because it's the same table.
print(a["x"]) --> 20

a = nil       -- Now only `b` refers to the table. The table still exists.
print(b["x"]) --> 20
b = nil       -- Now there are no references left. The table is eligible for garbage collection.

--------------------------------------------------------------------------------

-- [[ Table Indices: ]]
--[[
  A table can have keys of different types, and it grows automatically to fit new entries.
  If you try to access a key that doesn't exist, you get `nil`.
  You can also assign `nil` to a key to delete that entry from the table.
--]]
a = {}
for i = 1, 1000 do a[i] = i * 2 end
print(a[9])   --> 18
a["x"] = 10
print(a["x"]) --> 10
print(a["y"]) --> nil

--[[
  When using a string key that is a valid identifier, you can use dot notation.
  `a.name` is just a cleaner way of writing `a["name"]`.
  This is typically used when you treat a table like a record or structure with fixed fields.
--]]
a = {}
a.x = 10   -- same as a["x"] = 10
print(a.x) --> 10
print(a.y) --> nil

--[[
  - `a.x` means `a["x"]` (the key is the *string* "x").
  - `a[x]` means the key is the *value* of the variable `x`.
--]]
a = {}
x = "y"     -- the variable x holds the string "y"
a[x] = 10   -- same as a["y"] = 10

print(a[x]) --> 10 (gets a["y"])
print(a.x)  --> nil (gets a["x"], which is not defined)
print(a.y)  --> 10 (gets a["y"])

--[[
  Since any value can be a key, you have to be careful about types.
  The number `0` and the string `"0"` are different keys.
  However, integers and floats with the same mathematical value are treated as the same key.
--]]
a = {}
a[2.0] = 10
print(a[2]) --> 10 (the float 2.0 is converted to the integer 2 as a key)

a[2.1] = 20
print(a[2.1]) --> 20 (this float cannot be an integer, so it stays a float key)

--------------------------------------------------------------------------------

-- [[ Table Constructors: ]]
--[[
  Constructors are expressions that create and initialize tables in one go.
  Using a constructor is cleaner and more efficient than creating an empty
  table and filling it line by line.

  List-style:
  Initializes numeric keys starting from 1 not 0.
--]]
days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
print(days[4]) --> Wednesday

--[[
  Record-style:
  Uses the dot notation syntax to initialize string keys.
--]]
a = { x = 10, y = 20 } -- equivalent to a={}; a.x=10; a.y=20

--[[
  You can mix list-style and record-style in the same constructor.
  The list-style part will get the integer keys 1, 2, 3, etc.
--]]
polyline = {
  color = "blue",
  thickness = 2,
  npoints = 4,
  { x = 0,   y = 0 }, -- this becomes polyline[1]
  { x = -10, y = 0 }, -- this becomes polyline[2]
  { x = -10, y = 1 }, -- this becomes polyline[3]
  { x = 0,   y = 1 }  -- this becomes polyline[4]
}
print(polyline.color) --> blue
print(polyline[2].x)  --> -10

--[[
  General Form (Explicit Keys):
  For more complex keys (like negative numbers, or strings that aren't valid
  identifiers), you can explicitly write the key in square brackets.
--]]
opnames = { ["+"] = "add", ["-"] = "sub", ["*"] = "mul", ["/"] = "div" }
i = 20; s = "-"
a = { [i + 0] = s, [i + 1] = s .. s, [i + 2] = s .. s .. s }
print(opnames[s]) --> sub
print(a[22])      --> ---

--[[
  Trailing commas are allowed, which can be handy for code generators.
  Semicolons can also be used instead of commas, but it's an old style.
--]]
a = { [1] = "red", [2] = "green", [3] = "blue", }

--------------------------------------------------------------------------------

-- [[ Arrays, Lists, and Sequences: ]]
--[[
  To represent an array or list, you just use a table with integer keys.
  It's customary in Lua to start arrays with index 1, not 0. (why?)

  A "sequence" is a special kind of list: one where the keys are the set
  1, 2, 3, ..., n for some n. In other words, a list with no `nil` values
  in the middle (no "holes").
--]]

-- For sequences, the length operator `#` gives you the number of elements.
a = { 10, 20, 30, 40 }
print(#a) --> 4

-- This leads to a common idiom for appending an element to the end of a sequence:
a[#a + 1] = 50
print(a[5]) --> 50

--[[
  The Problem with Holes:
  The length operator `#` is unreliable for tables that are not sequences.
  If a table has "holes" (nil values between other elements), the behavior
  of `#` is not guaranteed.
--]]
a = {}
a[1] = 1
a[3] = 1
a[4] = 1
-- The length of this table is ambiguous. It could be 1 or 4.
-- Lua makes no promises here.

--[[
  The Problem with Trailing nils:
  Remember that a key with a `nil` value is not actually in the table.
  So, a list created with nils at the end will have a shorter length than you might expect.
--]]
a = { 10, 20, 30, nil, nil }
print(#a) --> 3 (This is the same as `{10, 20, 30}`)

--[[
  - If your list is a sequence (no holes), the `#` operator is safe and useful.
  - If you need to have holes in your list, you should store the length
    explicitly in another field, e.g., `a.n = 5`.
--]]

--------------------------------------------------------------------------------

-- [[ Table Traversal: ]]
--[[
  How to loop through the elements of a table.

  `pairs` for everything:
  The `pairs(t)` iterator will loop through ALL key-value pairs in a table `t`.
  IMPORTANT: The order of traversal is not guaranteed! It can be different each time.
--]]
t = { 10, print, x = 12, k = "hi" }
for k, v in pairs(t) do
  print(k, v)
end
-- --> 1   10
-- --> k   hi
-- --> 2   function: 0x...
-- --> x   12
-- (The order could be different on your machine!)

--[[
  `ipairs` for sequences:
  The `ipairs(t)` iterator is specifically for looping over the array/sequence part
  of a table (keys 1, 2, 3, ...). It stops at the first `nil` value.
  This one guarantees the order, from 1 up to the end of the sequence.
--]]
t = { 10, print, 12, "hi" }
for k, v in ipairs(t) do
  print(k, v)
end
-- --> 1   10
-- --> 2   function: 0x...
-- --> 3   12
-- --> 4   hi

--[[
  Numerical `for` for sequences:
  You can also use a standard numerical for loop with the length operator `#`.
  This also works great for sequences and is often very clear.
--]]
t = { 10, print, 12, "hi" }
for k = 1, #t do
  print(k, t[k])
end
-- --> 1   10
-- --> 2   function: 0x...
-- --> 3   12
-- --> 4   hi

--------------------------------------------------------------------------------

-- [[ Safe Navigation: ]]
--[[
  Sometimes you need to access a deeply nested field in a table, where any
  part of the path could be `nil`. For example, trying to get `company.director.address.zipcode`
  will cause an error if `company` or `director` or `address` is `nil`.

  The naive solution is to chain `and` operators:
  zip = company and company.director and company.director.address and company.director.address.zipcode
  This is ugly and inefficient.

  Lua doesn't have a special "safe navigation operator" like `?.` in other languages,
  but we can emulate it with the `or` operator. The expression `(a or {}).b` will
  result in `nil` if `a` is `nil`, instead of causing an error.
--]]
-- Assume 'company' might be nil or might not have the full structure.
local company = {
  director = {
    address = {
      zipcode = "12345-678"
    }
  }
}
local E = {} -- A single empty table to reuse, slightly more efficient.

local zip = (((company or E).director or E).address or E).zipcode
print(zip)           --> "12345-678"

local company2 = nil -- A company that doesn't exist
local zip2 = (((company2 or E).director or E).address or E).zipcode
print(zip2)          --> nil (no error!)

--[[
  This syntax is a bit more verbose than a dedicated operator, but it's a
  good-enough, built-in way to handle these situations safely and efficiently.
--]]

--------------------------------------------------------------------------------

-- [[ The Table Library: ]]
--[[
  The table library provides useful functions for manipulating sequences.

  `table.insert(t, [pos,] value)`
  Inserts `value` into sequence `t` at `pos`. Elements are shifted up to make space.
  If `pos` is omitted, it inserts at the end of the sequence (a common "push" operation).
--]]
local t = { 10, 20, 30 }
table.insert(t, 1, 15) -- t is now {15, 10, 20, 30}
table.insert(t, 50)    -- t is now {15, 10, 20, 30, 50}

--[[
  `table.remove(t, [pos])`
  Removes an element from sequence `t` at `pos` and returns it. Elements are shifted down.
  If `pos` is omitted, it removes from the end of the sequence (a common "pop" operation).
--]]
local t2 = { 10, 20, 30, 40 }
print(table.remove(t2, 2)) --> 20 (t2 is now {10, 30, 40})
print(table.remove(t2))    --> 40 (t2 is now {10, 30})

--[[
  `table.move(a, f, e, t, [b])`
  Moves elements from table `a`, from index `f` to `e`, into position `t` of the
  destination table. The destination is `a` by default, or table `b` if it's provided.
  This is a more general (and often faster) way to shift blocks of elements.
--]]
-- Example: insert "x" at the beginning of a list
local t3 = { "a", "b", "c" }
table.move(t3, 1, #t3, 2) -- move elements from index 1 to 3, to position 2
-- t3 is now {"a", "a", "b", "c"}
t3[1] = "x"
-- t3 is now {"x", "a", "b", "c"}

-- Example: append all elements from t3 to t
table.move(t3, 1, #t3, #t + 1, t)
print(table.concat(t, ", ")) -- prints "15, 10, 20, 30, x, a, b, c"

--------------------------------------------------------------------------------

--[[ Solutions for Exercises - Chapter 5 ]]

-- Exercise 5.1: What will the following script print? Explain.

sunday = "monday"; monday = "sunday"
t = { sunday = "monday", [sunday] = monday }
print(t.sunday, t[sunday], t[t.sunday])
--[[
  Explanation:
  1. `sunday` (variable) = "monday"
  2. `monday` (variable) = "sunday"
  3. `t` is constructed:
      - `sunday = "monday"` is sugar for `["sunday"] = "monday"`.
      - `[sunday] = monday` uses the variables. It becomes `["monday"] = "sunday"`.
      - So, `t` is `{["sunday"] = "monday", ["monday"] = "sunday"}`.
  4. The print statement:
      - `t.sunday` is `t["sunday"]`, which is "monday".
      - `t[sunday]` is `t["monday"]`, which is "sunday".
      - `t[t.sunday]` is `t["monday"]`, which is "sunday".

  Result: The script will print `monday  sunday  sunday`.
--]]


-- Exercise 5.2: Assume the following code:
m = {}; m.m = m
-- What would be the value of m.m.m.m? Is any m in that sequence somehow different from the others?
print(m.m.m.m) -- This will print the table address
-- `m.m.m.m` is just `m`. It's a table with a field 'm' that points to itself.
-- No `m` in the sequence is different; they are all references to the same table.

-- Now, add the next line to the previous code:
m.m.m.m = 3
-- What would be the value of m.m.m.m now?
--[[
  After `m.m.m.m = 3`:
  The left side, `m.m.m.m`, resolves to `m` itself. So the statement is equivalent
  to `m.m = 3`. The table's 'm' field now holds the number 3 instead of pointing
  to the table. The cycle is broken.
  The value of `m.m.m.m` now would be an error, because `m.m` is 3, and you can't
  index a number (`3.m`).
--]]


-- Exercise 5.3: Suppose that you want to create a table that maps each escape sequence for strings (the
-- section called “Literal strings”) to its meaning. How could you write a constructor for that table?
escape_map = {
  ["\\a"] = "\a",
  ["\\b"] = "\b",
  ["\\f"] = "\f",
  ["\\n"] = "\n",
  ["\\r"] = "\r",
  ["\\t"] = "\t",
  ["\\v"] = "\v",
  ["\\\\"] = "\\",
  ["\\\""] = "\"",
  ["\\'"] = "\'",
}

-- Exercise 5.4: We can represent a polynomial anxn + an-1xn-1 + ... + a1x1 + a0 in Lua as a list of its coefficients, such as {a0, a1, ..., an}.
-- Write a function that takes a polynomial (represented as a table) and a value for x and returns the polynomial value
function eval_polynomial_basic(poly, x)
  local result = 0
  for i = 1, #poly do
    local power = i - 1 -- coefficient at index i corresponds to x^(i-1)
    result = result + poly[i] * (x ^ power)
  end
  return result
end

-- Example usage:
local poly = { 1, -2, 3 }             -- Represents 1 - 2x + 3x^2
print(eval_polynomial_basic(poly, 2)) -- Evaluates to 1 - 4 + 12 = 9.0

-- Exercise 5.5: Can you write the function from the previous item so that it uses at most n additions and n
-- multiplications (and no exponentiations)?
function eval_polynomial(poly, x)
  if #poly == 0 then
    return 0
  end
  -- Start with the highest degree coefficient
  local result = poly[#poly]
  for i = #poly - 1, 1, -1 do
    result = result * x + poly[i]
  end
  return result
end

-- Exercise 5.6: Write a function to test whether a given table is a valid sequence.
function is_sequence(t)
  if type(t) ~= "table" then return false end
  local i = 1
  -- ipairs stops at the first nil (hole)
  for _ in ipairs(t) do
    i = i + 1
  end
  -- Now, check if there are any other numeric keys beyond where ipairs stopped
  for k, v in pairs(t) do
    if type(k) == "number" and k >= i then
      return false -- Found a numeric key after a hole
    end
  end
  return true
end

print(is_sequence({ 1, 2, 3 }))                 --> true
print(is_sequence({ 1, 2, nil, 4 }))            --> false (has a hole)
print(is_sequence({ 1, 2, 3, 4, 5 }))           --> true
print(is_sequence({ 1, 2, 3, 4, 5, nil, 6 }))   --> false (has a hole)
print(is_sequence({ 1, 2, 3, 4, 5, [10] = 6 })) --> false (has a numeric key after the sequence)

-- Exercise 5.7: Write a function that inserts all elements of a given list into a given position of another given
-- list.
function insert_all(list1, pos, list2)
  -- 1. Make space in list1 by moving its elements to the right
  table.move(list1, pos, #list1, pos + #list2)
  -- 2. Copy elements from list2 into the new gap
  for i = 1, #list2 do
    list1[pos + i - 1] = list2[i]
  end
  return list1
end

-- Exercise 5.8: The table library offers a function table.concat, which receives a list of strings and
-- returns their concatenation:
print(table.concat({ "hello", " ", "world" })) --> hello world
-- Write your own version for this function.
-- Compare the performance of your implementation against the built-in version for large lists, with hundreds
-- of thousands of entries. (You can use a for loop to create those large lists.)

function my_concat(list)
  local result = ""
  for i = 1, #list do
    result = result .. list[i]
  end
  return result
end

print(my_concat({ "hello", " ", "world" })) --> hello world

local large_list = {}
for i = 1, 100000 do
  large_list[i] = "item" .. i .. " "
end
local start_time = os.clock()
local result = my_concat(large_list)
local end_time = os.clock()
print("My concat time:", end_time - start_time)
local start_time_builtin = os.clock()
local result_builtin = table.concat(large_list)
local end_time_builtin = os.clock()
print("Built-in concat time:", end_time_builtin - start_time_builtin)

--[[
  The custom `my_concat` function is MUCH slower than the built-in `table.concat`
  for large lists. This is because each `..` operation in the loop creates a completely
  new string by copying the old `result` string and the new element. This leads to
  a lot of memory allocation and copying, resulting in O(n^2) complexity.

  The built-in `table.concat` is implemented in C. It can calculate the total required
  size for the final string, allocate that memory block just once, and then copy all
  the small strings into it. This is much more efficient, with O(n) complexity.
--]]
