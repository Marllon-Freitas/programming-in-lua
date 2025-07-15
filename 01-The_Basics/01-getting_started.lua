--[[
  Author: Marllon
  Date: 2025-07-13
  Book: Programming in Lua (4th ed.)
  Book Author: Roberto Ierusalimschy

  ========================================
  Part I: The Basics
  Chapter: 1 - Getting Started
  ========================================

  These are the notes and code examples from the first chapter of the book.
  The objetive is to learn the basics of Lua programming language.
  As I progress through the book, I will update this and future files with new examples and notes.
  Feel free to use this file as a reference for your own Lua learning journey.

  obs: this is only for help me to learn lua, not a complete guide, do not use this as a reference for production code.
  obs2: i have no idea what i am doing.
--]]

--------------------------------------------------------------------------------

-- [[ Chunks: ]]
-- In Lua, a chunk is simply a piece of code that is executed, which can be a line, a block of code, or even an entire file.

--------------------------------------------------------------------------------

-- [[ Some Lexical Conventions: ]]
--[[
  Lua is case-sensitive, identifiers can be any string of letters, digits, and underscores, but must start with a letter or underscore.
  identifiers that start with an underscore and uppercase letters are reserved for internal use by Lua.
  Like:
    _VERSION

  Here a list of all reserved words in Lua:
    and       break     do        else      elseif
    end       false     for       function  goto
    if        in        local     nil       not
    or        repeat    return    then      true
    until     while
--]]
-- comments in Lua can be single-line or multi-line
-- single-line comments start with '--'
-- multi-line comments start with '--[[' and end with ']]', there a convention to use '--[[' and '--]]' for multi-line comments

--[[
  Lua does not need a separator between consecutive statements. Some valid examples:
  a = 1
  b = a * 2

  a = 1;
  b = a * 2;

  a = 1; b = a * 2
  a = 1 b = a * 2 -- ugly, but valid
--]]

--------------------------------------------------------------------------------

-- [[ Global Variables: ]]
-- Global variables do not need to be declared beforehand. They are created dynamically the first time we assign a value to them.
-- Accessing a non-initialized global variable does not cause an error. The value returned is simply 'nil'.
print(x) --> nil

-- Assigning 'nil' to a global variable effectively "deletes" it. After the assignment, it behaves as if it had never been used.
b = 10
print(b) --> 10
b = nil
print(b) --> nil

-- Lua does not differentiate between a non-initialized variable and one that has been assigned 'nil'. For all practical purposes, both are considered 'nil'.
-- This feature allows Lua's garbage collector to free the memory associated with the variable once it is set to 'nil', 
-- and there are no other references to its old value.

--------------------------------------------------------------------------------

-- [[ Types and Values: ]]
-- Lua is a dynamically-typed language. This means types belong to values, not to the variables that hold them.
-- Every value carries its own type information.
-- There are eight basic types in Lua:

-- nil, boolean, number, string, userdata, function, thread, and table.

-- The built-in function `type()` returns the type of any given value as a string.
type(true)     --> "boolean"
type(3.14)     --> "number"
type("hello")  --> "string"
type({})       --> "table"
type(print)    --> "function"
type(io.stdin) --> "userdata" -- (from the standard I/O library)

-- Since the `type()` function itself returns a string, the type of its result is always "string".

-- Variables do not have predefined types. Any variable can hold a value of any type, and the type it holds can change.
a = 10          -- 'a' now holds a number
type(a)         --> "number"
a = "a string"  -- 'a' now holds a string
type(a)         --> "string"

--[[
  The 'userdata' type is a special placeholder for arbitrary C data.
  It allows C libraries to create new types for use within Lua, such as the file handles
  used by the I/O library. It has no predefined operations in Lua itself.
--]]

--------------------------------------------------------------------------------

-- [[ Nil: ]]
-- The 'nil' represents the absence of a value or a non-initialized variable.

--------------------------------------------------------------------------------

-- [[ Booleans: ]]
-- What is Considered "False" in Lua? (Falsiness)
--  In conditional contexts (like 'if' statements), Lua considers only two values to be false:
--  - The boolean value 'false'
--  - The value 'nil'

-- What is Considered "True" in Lua? (Truthiness)
--  EVERYTHING else is considered true.
--  This includes the number 0 and empty strings "".
if 0 then
    print("0 is considered true") -- >> This line will be printed
end
if "" then
    print("The empty string is considered true") -- >> This line will also be printed
end

-- The Logical Operators: `and`, `or`
-- These operators don't always return 'true' or 'false'. Instead, they return one of their operands, which makes them very flexible.

-- The `and` operator:
-- - If the first value is falsy (false or nil), it returns that first value immediately.
-- - Otherwise, it returns the second value.
print(4 and 5)      -- >> 5      (4 is truthy, so it returns the second value)
print(nil and 13)   -- >> nil    (nil is falsy, so it returns the first value)
print(false and 13) -- >> false  (false is falsy, so it returns the first value)

-- The `or` operator:
-- - If the first value is truthy, it returns that first value immediately.
-- - Otherwise, it returns the second value.
print(0 or 5)        -- >> 0      (0 is truthy, so it returns the first value)
print(false or "hi") -- >> "hi"   (false is falsy, so it returns the second value)
print(nil or false)  -- >> false  (nil is falsy, so it returns the second value)

-- Short-Circuit Evaluation:
-- The second operand is only evaluated if necessary. This is useful for preventing errors.
local i = 0
-- The expression `(10 / i > 2)` is never evaluated because `(i ~= 0)` is false.
if (i ~= 0 and 10 / i > 2) then
    -- This code is skipped, and no division-by-zero error occurs.
end

-- A Common Idiom: Setting a default value
-- The pattern `x = x or v` is a concise way to set a default value `v` if `x` is nil or false.
local name -- 'name' is currently nil
name = name or "Anonymous" -- Since name is nil (falsy), it gets the value "Anonymous".
print(name) -- >> Anonymous

-- The `not` Operator
-- Unlike `and` and `or`, the `not` operator ALWAYS returns a true boolean (`true` or `false`).
-- It inverts the truthiness/falsiness of its operand.
print(not nil)      -- >> true
print(not 0)        -- >> false (because 0 is truthy)
print(not "hello")  -- >> false (because a non-empty string is truthy)
print(not not 1)    -- >> true  (not 1 is false, so not false is true)

--------------------------------------------------------------------------------

--[[ Solutions for Exercises - Chapter 1 ]]

-- Exercise 1.1: Run the factorial example. What happens to your program if you enter a negative number?
-- Modify the example to avoid this problem.
--[[
  -- the standard factorial example:
  function fact(n)
    if n == 0 then
      return 1
    else
      return n * fact(n - 1)
    end
  end

  print("enter a number:")
  a = io.read("*n") -- reads a number
  print(fact(a))
--]]

-- Response:
-- If you enter a negative number, the program will enter an infinite recursion.
-- it will cause a "stack overflow" error. This is because the function
-- calls itself infinitely (fact(-1) calls fact(-2), etc.) and never
-- reaches the base case of n == 0.

-- Solution: 
-- we can modify the function to check for negative numbers and return an error message instead of continuing the recursion.

function safe_fact(n)
  if n < 0 then
    return nil, "error: input must be a non-negative number"
  elseif n == 0 then
    return 1
  else
    return n * safe_fact(n - 1)
  end
end

print(safe_fact(5))   --> 120
-- print(safe_fact(-1))  --> nil   error: input must be a non-negative number

-- Exercise 1.2: `dofile` vs. the `-l` option.
--[[
  This is a matter of preference and use case.
  `dofile("filename.lua")`: Simply executes the given file. It's best for
  running a standalone script once from within another script or the interpreter.

  `lua -l libname`: This is equivalent to `require("libname")`. It's designed
  for loading libraries. It is more robust: it prevents loading the same
  file multiple times (it caches the result) and searches in standard module
  paths.
  
  Preference: For building modular applications, `require` (and the `-l` flag)
  is the standard and preferred way. For a quick, one-off execution of a file,
  `dofile` is simpler.
--]]

-- Exercise 1.3: Other languages that use "--" for comments.
--[[
  Besides Lua, several other well-known languages use "--" for comments:
   - SQL (Structured Query Language)
   - Ada
   - Haskell
  you can see more here https://gist.github.com/dk949/88b2652284234f723decaeb84db2576c
--]]

-- Exercise 1.4: Valid Lua identifiers.
--[[
  ___       --> Valid. Can be composed of underscores.
  _end      --> Valid. Can start with an underscore.
  End       --> Valid. Lua is case-sensitive, so 'End' is not the keyword 'end'.
  end       --> Invalid. It is a reserved keyword.
  until?    --> Invalid. Contains an illegal character '?'.
  nil       --> Invalid. It is a reserved keyword.
  NULL      --> Valid. 'NULL' is not the keyword 'nil'.
  one-step  --> Invalid. Contains a hyphen '-', which is the subtraction operator.
--]]

-- Exercise 1.5: The value of `type(nil) == nil`.
--[[
  The value of this expression is `false`.
  Explanation:
  1. `type(nil)` is evaluated first. The `type()` function always returns a *string*.
     So, `type(nil)` evaluates to the string value "nil".
  2. The expression becomes `"nil" == nil`.
  3. This compares the string `"nil"` to the value `nil`. They are different types
     and different values, so the comparison results in `false`.
--]]

-- Exercise 1.6: How to check for a boolean without using `type()`.

-- A value is a boolean if, and only if, it is equal to `true` or `false`.
-- we can create a simple function like this:

function is_boolean(value)
  return (value == true or value == false)
end

print(is_boolean(true))    -- >> true
print(is_boolean(false))   -- >> true
print(is_boolean(0))       -- >> false
print(is_boolean(nil))     -- >> false

-- Exercise 1.7: Are parentheses necessary?
--[[
  Given the expression: (x and y and (not z)) or ((not y) and x)
  Are they necessary? No.
  Lua's operator precedence rules (`not` is highest, then `and`, then `or`)
  would cause the expression to be evaluated in the exact same order without them.
  Would you recommend them? Yes, absolutely.
  The parentheses make the programmer's intent explicit and the logic much
  easier to read at a glance. Relying on implicit precedence for complex
  expressions can lead to bugs and difficult-to-maintain code.
--]]

-- Exercise 1.8: Write a script that prints its own name.

-- When a Lua script is run from the command line, it can access its own name
-- through the global 'arg' table. The script's name is at index 0.

-- To try it, save this single line in a file (e.g., "my_name.lua"):

print(arg[0]) -- in this case it will print "getting_started.lua"
