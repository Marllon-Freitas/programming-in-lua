--[[
  Author: Marllon
  Date: 2025-07-15
  Book: Programming in Lua (4th ed.)
  Book Author: Roberto Ierusalimschy

  ========================================
  Part I: The Basics
  Chapter: 6 - Functions
  ========================================

  These are the notes and code examples from the sixth chapter of the book.

  obs: i have no idea what i am doing.
--]]

--------------------------------------------------------------------------------

-- [[ Functions: ]]
--[[
  Functions are the primary mechanism for code abstraction in Lua. They can be
  used in two main ways:

  1. As a procedure, to perform a specific task (a statement).
  2. As an expression, to compute and return a value.

  In Lua, functions can be written in either Lua or C, but from the user's
  perspective, they are called in exactly the same way.
--]]

-- A function call as a statement (does an action)
print(8 * 9)

-- A function call as an expression (produces a value)
local a = math.sin(3) + math.cos(10)

--[[
  The standard way to call a function is with its name followed by parentheses `()`
  containing its arguments.

  A special rule exists: if a function has exactly ONE argument, and that
  argument is either a string literal or a table constructor, the parentheses
  are optional.
--]]

-- Standard calls
-- print("Hello World")
-- dofile('a.lua')
-- f({ x = 10, y = 20 })
-- type({})

-- The same calls, but with the optional parentheses omitted
-- print "Hello World"
-- dofile 'a.lua'
-- f { x = 10, y = 20 }
-- type {}

--[[
  Lua also has a colon operator for object-oriented calls, like `o:foo(x)`,
  which will be covered in a later chapter.
--]]

--------------------------------------------------------------------------------

-- [[ Function Definitions ]]
--[[
  The conventional syntax for defining a function includes a name, a list of
  parameters, and a body of statements.
--]]
function add(a)       -- 'add' is the name, 'a' is the parameter
  local sum = 0       -- function body starts here
  for i = 1, #a do
    sum = sum + a[i]
  end
  return sum          -- function body ends here
end

--[[
  Parameters behave like local variables that are created and initialized with
  the argument values passed when the function is called.
--]]


--------------------------------------------------------------------------------

-- [[ Mismatched Arguments and Default Values ]]
--[[
  Lua is very flexible when it comes to function arguments.
  - If you pass MORE arguments than there are parameters, the extra arguments are discarded.
  - If you pass FEWER arguments, the extra parameters are assigned `nil`.
--]]
function f(a, b)
  print(a, b)
end

f()         --> nil   nil
f(3)        --> 3     nil
f(3, 4)     --> 3     4
f(3, 4, 5)  --> 3     4     (5 is discarded)

--[[
  This flexibility allows for a super useful trick for setting default argument values,
  using the `or` operator.
--]]
function incCount(n)
  -- If 'n' was not provided, it will be nil. `nil or 1` evaluates to 1.
  n = n or 1
  -- globalCounter = globalCounter + n
end

-- Calling `incCount()` with no arguments is equivalent to `incCount(1)`.


--------------------------------------------------------------------------------

-- [[ Multiple Results ]]
--[[
  A convenient feature of Lua is that functions can return multiple values.
  You just list them after the `return` keyword.
--]]
function maximum(a)
  local mi = 1 -- index of the maximum value
  local m = a[mi] -- maximum value
  for i = 1, #a do
    if a[i] > m then
      mi = i; m = a[i]
    end
  end
  return m, mi -- return the maximum and its index
end

-- print(maximum({8,10,23,12,5})) --> 23    3

--[[
  Lua adjusts the number of results from a function based on the context of the call.

  The rule is: you only get all results when the function call is the LAST (or only)
  expression in a list of expressions. These lists appear in:
  1. Multiple assignments
  2. Arguments to function calls
  3. Table constructors
  4. `return` statements

  Otherwise, the number of results is adjusted to one (or zero if called as a statement).
--]]
function foo0() end -- returns no results
function foo1() return "a" end -- returns 1 result
function foo2() return "a", "b" end -- returns 2 results

-- Case 1: Multiple Assignment
x, y = foo2()       -- x="a", y="b"
x, y = foo1()       -- x="a", y=nil (pads with nil)
x, y = foo2(), 20   -- x="a", y=20 (foo2 is not the last expression, so it only gives one result)

-- Case 2: Function Call Arguments
print(foo2())       --> a   b
print(foo2(), 1)    --> a   1
print(foo2() .. "x")--> ax (foo2 is in an expression, so only its first result "a" is used)

-- Case 3: Table Constructors
t = {foo2()}        -- t = {"a", "b"}
t = {foo1(), foo2()}-- t = {"a", "a"} (foo2 is not last, so only one result)

--[[
  You can always force a function call to produce exactly one result by enclosing
  it in an extra pair of parentheses.
--]]
print((foo2())) --> a


--------------------------------------------------------------------------------

-- [[ Variadic Functions ]]
--[[
  A variadic function is one that can accept a variable number of arguments.
  You define one by putting three dots `...` in its parameter list.
--]]
function add_variadic(...)
  local s = 0
  -- The expression `{...}` creates a table containing all the arguments.
  for _, v in ipairs{...} do
    s = s + v
  end
  return s
end

-- print(add_variadic(3, 4, 10, 25, 12)) --> 54

--[[
  You can also have fixed parameters before the variadic part.
--]]
function fwrite(fmt, ...)
  -- The `...` expression now only contains the arguments after `fmt`.
  return io.write(string.format(fmt, ...))
end

--[[
  Accessing Variadic Arguments:
  There are a few ways to work with the `...` expression.

  1. `{...}`: The most common way. Collects all arguments into a table.
     The downside is that you can't tell if there were trailing `nil`s.

  2. `table.pack(...)`: (Lua 5.2+) This is a safer way to create the table.
     It returns a table with all the arguments, plus an extra field "n"
     that stores the *actual* total number of arguments, including any nils.

  3. `select(selector, ...)`: This function lets you access the arguments directly.
     - `select('#', ...)` returns the total number of arguments.
     - `select(n, ...)` returns all arguments from the nth one onwards.
--]]
-- Example using select:
function add_with_select(...)
  local s = 0
  for i = 1, select("#", ...) do
    s = s + select(i, ...)
  end
  return s
end

--[[
  Performance Note: For a small number of arguments, `select` can be faster
  because it avoids creating a new table. For a large number of arguments,
  the `{...}` or `table.pack` method is usually better.
--]]


--------------------------------------------------------------------------------

-- [[ The function table.unpack ]]
--[[
  The `table.unpack` function is the reverse of `table.pack`. It takes a table (a list)
  and returns all of its elements as a list of results.
--]]
print(table.unpack{10, 20, 30}) --> 10  20  30

a, b = table.unpack{10, 20, 30} -- a=10, b=20, 30 is discarded

--[[
  A major use for `table.unpack` is for generic calls. It allows you to
  dynamically call any function with any arguments stored in a table.
--]]
-- For example, instead of `string.find("hello", "ll")`
-- you can do this:
f = string.find
local example = {"hello", "ll"}
print(f(table.unpack(example))) --> 3   4

--[[
  By default, `unpack` uses the `#` operator, so it works on proper sequences.
  You can also provide optional start and end indices.
--]]
print(table.unpack({"Sun", "Mon", "Tue", "Wed"}, 2, 3)) --> Mon   Tue


--------------------------------------------------------------------------------

--[[ Solutions for Exercises - Chapter 6 ]]

-- Exercise 6.1: Write a function that takes an array and prints all its elements.
function print_elements(arr)
  -- `table.unpack` is perfect for this, as it returns all array elements
  -- as separate values, which `print` then receives as arguments.
  print(table.unpack(arr))
end
print_elements({10, "hi", false}) --> 10   hi   false

-- Exercise 6.2: Write a function that takes an arbitrary number of values and returns all of them, except
-- the first one.
function all_but_first(...)
  -- `select(n, ...)` returns all arguments from the nth one onwards.
  return select(2, ...)
end
print(all_but_first(1, 2, 3, 4)) --> 2   3   4

-- Exercise 6.3: Write a function that takes an arbitrary number of values and returns all of them, except
-- the last one.
function all_but_last(...)
  local n = select("#", ...)
  if n == 0 then return end -- No arguments, nothing to return.
  -- We can't just select from 1 to n-1, as select returns everything *after* n.
  -- So we pack the arguments into a table, remove the last one, and unpack.
  local t = table.pack(...)
  t.n = t.n - 1 -- Effectively shorten the list
  return table.unpack(t, 1, t.n)
end
-- print(all_but_last(1, 2, 3, 4)) --> 1   2   3

-- Exercise 6.4: Write a function to shuffle a given list. Make sure that all permutations are equally probable.
function shuffle(list)
  -- This uses the Fisher-Yates shuffle algorithm.
  for i = #list, 2, -1 do
    -- Pick a random index j from 1 to i
    local j = math.random(i)
    -- Swap the elements at positions i and j
    list[i], list[j] = list[j], list[i]
  end
  return list
end
print_elements(shuffle({1, 2, 3, 4, 5})) -- prints the numbers in a random order

--[[ 
  Exercise 6.5: Write a function that takes an array and prints all combinations of the elements in the array.
  (Hint: you can use the recursive formula for combination: C(n,m) = C(n -1, m -1) + C(n - 1, m). To generate
  all C(n,m) combinations of n elements in groups of size m, you first add the first element to the result and
  then generate all C(n - 1, m - 1) combinations of the remaining elements in the remaining slots; then you
  remove the first element from the result and then generate all C(n - 1, m) combinations of the remaining
  elements in the free slots. When n is smaller than m, there are no combinations. When m is zero, there is
  only one combination, which uses no elements.)
--]]
function combinations(arr, m)
  local function generate(start_index, combo)
    -- If the current combination has the desired size, print it.
    if #combo == m then
      print(table.unpack(combo))
      return
    end

    -- If there aren't enough elements left to fill the combo, stop.
    if #arr - start_index + 1 < m - #combo then
      return
    end

    -- Iterate through the remaining elements.
    for i = start_index, #arr do
      -- Add the current element to our combination.
      table.insert(combo, arr[i])
      -- Recurse to find combinations for the rest of the list.
      generate(i + 1, combo)
      -- Backtrack: remove the element we just added to try the next one.
      table.remove(combo)
    end
  end

  generate(1, {})
end
combinations({"a", "b", "c", "d"}, 2) -- prints all 2-element combinations

--[[
  Exercise 6.6: Write a program that performs an unbounded call chain without recursion.
  Sometimes, a language with proper-tail calls is called properly tail recursive, with the argument that this 
  property is relevant only when we have recursive calls. 
  (Without recursive calls, the maximum call depth of a program would be statically fixed.)

  Show that this argument does not hold in a dynamic language like Lua: write a program that performs an
  unbounded call chain without recursion. (Hint: see the section called “Compilation”.)
--]]
--[[
  This can be done by dynamically creating new functions using `load`.
  Each function compiles and calls a new version of itself. This is not
  recursion because the call stack does not grow; each function returns
  after calling the next one. It's a chain of calls, not a nested stack.
--]]
i = 0
chunk = [[
  i = i + 1
  print("call", i)
  if i < 10 then
    local f = load(chunk)
    f()
  end
]]

local fun = load(chunk)
fun() -- this would start the chain.
