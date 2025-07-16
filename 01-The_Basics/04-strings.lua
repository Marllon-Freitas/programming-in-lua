--[[
  Author: Marllon
  Date: 2025-07-15
  Book: Programming in Lua (4th ed.)
  Book Author: Roberto Ierusalimschy

  ========================================
  Part I: The Basics
  Chapter: 4 - Strings
  ========================================

  These are the notes and code examples from the fourth chapter of the book.

  obs: i have no idea what i am doing.
--]]

--------------------------------------------------------------------------------

-- In lua strings can be a single digit or a whole book, we can story any binary data in them.
-- Strings are immutable, meaning that once created, they cannot be changed.
a = "one string"
b = string.gsub(a, "one", "another") -- change string parts
print(a)                             --> one string
print(b)                             --> another string
-- Strings can relocate memory if needed, so we don't need to worry about memory management.
-- to get the length of a string we can use the # operator that count the number of bytes in the string.
print(#a)                         --> 10
print(#b)                         --> 14
print(#"Hello World!")            --> 12
-- We can concatenate strings using the .. operator.
print("Hello" .. " " .. "World!") --> Hello World!
print("Hello" .. 123)             --> Hello123
-- The .. operator does not change the original strings, it creates a new string with the concatenated result.
a = "Hello"
print(a)              --> Hello
print(a .. " World!") --> Hello World!
print(a)              --> Hello

--------------------------------------------------------------------------------

-- [[Literal Strings: ]]
--[[
  Single vs. Double Quotes:
  You can use either single quotes ('') or double quotes ("") to create a string.
  They work the same way. The only real difference is that you can use the other
  type of quote inside the string without having to escape it.
--]]
a = "a line with 'single quotes' inside"
b = 'another line with "double quotes" inside'
print(a)
print(b)

--[[
  Escape Sequences:
  Lua understands C-style escape sequences to represent special characters.
  \a  (bell)
  \b  (backspace)
  \f  (form feed)
  \n  (newline)
  \r  (carriage return)
  \t  (horizontal tab)
  \v  (vertical tab)
  \\  (backslash)
  \"  (double quote)
  \'  (single quote)
--]]
print("one line\nand the\nnext line")

--[[
  Numeric and Hex Escapes:
  You can also specify a character by its byte value.
  - `\ddd`: A decimal value, with up to three digits.
  - `\xhh`: A hexadecimal value, with exactly two hex digits.
--]]
-- "A" is 65 in decimal, which is 41 in hex. Newline is 10.
print("\65LO\n")    --> ALO
print("\x41LO\x0a") --> ALO

--[[
  UTF-8 Escapes (Lua 5.3+):
  You can specify any Unicode character using `\u{...}` with its hex code point.
--]]
print("\u{3b1} \u{3b2} \u{3b3}") --> α β γ (if your terminal supports UTF-8)

--------------------------------------------------------------------------------

--[[ Long Strings and Multi-line Literals ]]

-- For long blocks of text, you can use long brackets `[[...]]`.
--[[
  - They can span multiple lines.
  - They do NOT interpret any escape sequences. `\n` is just a backslash and an 'n'.
  - If the first character after the `[[` is a newline, it gets ignored.

  They are perfect for embedding chunks of HTML, code, etc.
--]]
page = [[
<html>
  <head>
    <title>An HTML Page</title>
  </head>
  <body>
    <a href="http://www.lua.org">Lua</a>
  </body>
</html>
]]

print(page)

-- What if your string contains a `]]` ? You can add equals signs between the brackets.
--[[
  `[=[...]=]` will only close with a matching `]=]`. You can add as many `=` as you need.
  This is great for commenting out code that already contains long strings/comments.
--]]
long_string = [==[
  a = b[c[i]] this would normally break a [[...]] string
]==]

print(long_string)

--[[
  The `\z` Escape Sequence (Lua 5.2+):
  Long strings are not great for raw binary data written with hex escapes, because
  you'd get a super long line. The `\z` skips all whitespace characters that follow
  it until the next non-whitespace character.
  This lets you break up a long sequence of hex codes into multiple lines.
--]]
data = "\x00\x01\x02\x03\x04\x05\x06\x07\z
        \x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"
-- The byte \x08 comes right after \x07, with no newlines or spaces in between.

--------------------------------------------------------------------------------

-- [[ Coercions (String/Number Conversions): ]]
--[[
  "Coercion" is just a fancy word for Lua automatically converting a value
  from one type to another, like from a string to a number.

  Automatic Coercion:
  - In arithmetic operations, Lua will try to convert a string to a number.
  - In string concatenation, it will convert a number to a string.

  General advice: Don't rely on this too much. It can make code confusing.
  It's usually better to convert things explicitly.
--]]
print("10" + 1) --> 11.0 (Note: the result is a float)
print("10 + 1") --> 10 + 1 (This is just a string, no math happens)
print(10 .. 20) --> 1020 (The numbers 10 and 20 become strings)

--[[
  Explicit Conversions:
  - `tonumber(s, [base])`: Converts string `s` to a number. Returns `nil` if the
    string isn't a valid number. You can optionally provide a base (from 2 to 36)
    for things like binary or hexadecimal.
  - `tostring(n)`: Converts a number `n` to a string. This always works.
--]]
print(tonumber(" -3 "))  --> -3
print(tonumber("10e4"))  --> 10000.0
print(tonumber("hello")) --> nil

-- Using a different base
print(tonumber("100101", 2))  --> 37
print(tonumber("fff", 16))    --> 4095

print(tostring(123) == "123") --> true

--[[
  A Big Exception: Order Operators (<, >, <=, >=)
  These operators DO NOT coerce their arguments.
  If you try to compare a number and a string, Lua will throw an error.
  This prevents weird results, because "2" is alphabetically greater than "15".
--]]
-- print(2 < "15") -- This would cause an error: "attempt to compare number with string"

--------------------------------------------------------------------------------

-- [[ The String Library: ]]
--[[
  The real power for manipulating strings comes from the `string` library.
  Here are some of the most common functions.
--]]

-- `string.len(s)`: same as `#s`
print(string.len("hello")) --> 5

-- `string.rep(s, n)`: returns string `s` repeated `n` times.
print(string.rep("abc", 3)) --> abcabcabc

-- `string.reverse(s)`: reverses a string.
print(string.reverse("A Long Line!")) --> !eniL gnoL A

-- `string.lower(s)` and `string.upper(s)`: change case.
print(string.lower("A Long Line!")) --> a long line!
print(string.upper("A Long Line!")) --> A LONG LINE!

-- `string.sub(s, i, [j])`: gets a substring from index `i` to `j`.
-- Indices can be negative, counting from the end of the string (-1 is the last char).
local s = "[in brackets]"
print(string.sub(s, 2, -2)) --> in brackets

-- `string.char(...)` and `string.byte(s, [i], [j])`: convert between chars and their byte codes.
print(string.char(97))          --> a
print(string.byte("abc", 2))    --> 98
-- You can get multiple byte codes at once
print(string.byte("abc", 1, 3)) --> 97   98   99

-- `string.format(...)`: a powerful C-style string formatter.
-- `%d` for decimal, `%x` for hex, `%f` for float, `%s` for string.
-- You can add modifiers like `%.4f` (4 decimal places) or `%02d` (pad with 0 to 2 digits).
print(string.format("pi = %.4f", math.pi))          --> pi = 3.1416
print(string.format("%02d/%02d/%04d", 5, 11, 1990)) --> 05/11/1990

-- The Colon Operator
-- You can call string functions using `object:method()` syntax, which is just a
-- convenient shortcut. `s:sub(i, j)` is the same as `string.sub(s, i, j)`.
print(s:sub(2, -2)) --> in brackets

-- `string.gsub(s, pattern, replacement)`: global substitution.
-- It replaces all occurrences of the pattern and returns the new string
-- plus the number of replacements made.
print(string.gsub("hello world", "l", ".")) --> he..o wor.d   3

--------------------------------------------------------------------------------

----- [[ The UTF-8 Library: ]]
--[[
  Because strings are just bytes, some standard string functions don't work
  correctly with multi-byte characters (like in UTF-8).
  - Works fine: `..`, `<`, `==`, `string.len`, `string.sub` (these work on bytes, which is often ok)
  - Does NOT work: `string.reverse`, `string.upper`, `string.lower`, `string.byte` (these assume 1 byte = 1 char)

  For proper Unicode handling, Lua 5.3 introduced the `utf8` library.
--]]

-- `utf8.len(s)`: returns the number of CHARACTERS (codepoints), not bytes.
-- It also validates the string, returning nil and an error position if it's invalid.
print(utf8.len("résumé")) --> 6
print(utf8.len("ação"))   --> 4
print(utf8.len("ab\x93")) --> nil   3

-- `utf8.char(...)` and `utf8.codepoint(s, [i])`: The UTF-8 versions of `string.char/byte`.
print(utf8.char(114, 233, 115, 117, 109, 233)) --> résumé
print(utf8.codepoint("ação", 2))               --> 231

--[[
  Byte vs. Character Indices:
  Most functions in the `utf8` library still expect BYTE indices.
  To get the byte position of a character at a specific CHARACTER index, you use `utf8.offset`.
--]]
local s_utf8 = "Nähdään" -- This string has 7 characters but 8 bytes.
-- Get the byte position of the 5th character:
local byte_pos = utf8.offset(s_utf8, 5)
print(byte_pos)                         --> 6
-- Now use that byte position to get the character's code:
print(utf8.codepoint(s_utf8, byte_pos)) --> 228 (the codepoint for 'ä')

-- `utf8.codes(s)`: An iterator to loop over all characters in a string.
-- It gives you the byte position and the codepoint for each character.
for i, c in utf8.codes("Ação") do
  print(string.format("Byte position: %d, Codepoint: %d", i, c))
end
--[[
  --> Byte position: 1, Codepoint: 65
  --> Byte position: 2, Codepoint: 231
  --> Byte position: 4, Codepoint: 227
  --> Byte position: 6, Codepoint: 111
--]]

--[[
  For anything more complex (like what counts as a "letter" in different languages),
  you'll need an external library, as full Unicode support is huge and beyond
  the scope of Lua's small standard library.
--]]

--------------------------------------------------------------------------------

--[[ Solutions for Exercises - Chapter 4 ]]

-- Exercise 4.1: How can you embed the following fragment of XML as a string in a Lua program?

-- We can use long brackets with equals signs, `[=[...]=]`.
xml_fragment1 = [=[<![CDATA[
  Hello world
]]>]=]
xml_fragment2 = [===[<![CDATA[
  Hello world
]]>]===]
print(xml_fragment1)
print(xml_fragment2)

-- Exercise 4.2: Suppose you need to write a long sequence of arbitrary bytes as a literal string in Lua. What
-- format would you use? Consider issues like readability, maximum line length, and size.
--[[
  For a long string of arbitrary bytes, the best format is a standard quoted string
  that uses hexadecimal escapes (`\xHH`) for each byte, broken into multiple lines
  for readability using the `\z` escape sequence.
--]]
long_binary_data = "\xDE\xAD\xBE\xEF\xCA\xFE\z
                    \xBA\xBE\x00\xFF\x12\x34"


-- Exercise 4.3: Write a function to insert a string into another.
function insert(main_str, pos, insert_str)
  local left = string.sub(main_str, 1, pos - 1)
  local right = string.sub(main_str, pos)
  return left .. insert_str .. right
end

print(insert("hello world", 1, "start: ")) --> start: hello world
print(insert("hello world", 7, "small "))  --> hello small world


-- Exercise 4.4: Redo the insert function for UTF-8 strings.
function utf8_insert(main_str, char_pos, insert_str)
  local byte_pos_utf8 = utf8.offset(main_str, char_pos)
  if byte_pos_utf8 == nil then return nil end -- invalid position
  local left = string.sub(main_str, 1, byte_pos_utf8 - 1)
  local right = string.sub(main_str, byte_pos_utf8)
  return left .. insert_str .. right
end

print(utf8_insert("ação", 5, "!")) --> ação!


-- Exercise 4.5: Write a function to remove a slice from a string; the slice should be given by its initial
-- position and its length:
function remove(str, pos, len)
  local left = string.sub(str, 1, pos - 1)
  local right = string.sub(str, pos + len)
  return left .. right
end

print(remove("hello world", 7, 4)) --> hello d


-- Exercise 4.6: Redo the remove function for UTF-8 strings.
function utf8_remove(str, char_pos, char_len)
  local start_byte_pos = utf8.offset(str, char_pos)
  if start_byte_pos == nil then return nil end
  local end_byte_pos = utf8.offset(str, char_pos + char_len)

  local left = string.sub(str, 1, start_byte_pos - 1)
  local right = ""
  if end_byte_pos ~= nil then
    right = string.sub(str, end_byte_pos)
  end

  return left .. right
end

print(utf8_remove("ação", 2, 2)) --> ao


-- Exercise 4.7: Write a function to check whether a given string is a palindrome:
function is_palindrome(str)
  return str == string.reverse(str)
end

print(is_palindrome("step on no pets")) --> true
print(is_palindrome("banana"))          --> false


-- Exercise 4.8: Redo the previous exercise so that it ignores differences in spaces and punctuation.
function is_palindrome_adv(str)
  -- 1. Convert to lowercase
  local str_p = string.lower(str)
  -- 2. Remove all non-alphanumeric characters.
  --    In Lua patterns, `%a` is letters, `%d` is digits. `[^...]` is the complement.
  str_p = string.gsub(str_p, "[^%a%d]", "")
  -- 3. Check if the cleaned string is a palindrome.
  return str_p == string.reverse(str_p)
end

print(is_palindrome_adv("A man, a plan, a canal: Panama")) --> true
print(is_palindrome_adv("Madam, I'm Adam."))               --> true


-- Exercise 4.9: Redo the previous exercise for UTF-8 strings
-- First, we need a helper function to reverse a UTF-8 string, since string.reverse won't work.
function utf8_reverse(s)
  local reversed_chars = {}
  for _, c in utf8.codes(s) do
    table.insert(reversed_chars, 1, utf8.char(c))
  end
  return table.concat(reversed_chars)
end

function is_palindrome_utf8(str)
  local reversed_chars = {}
  for _, c in utf8.codes(str) do
    table.insert(reversed_chars, 1, utf8.char(c))
  end
  return str == table.concat(reversed_chars)
end

print(is_palindrome_utf8("madam"))  --> true
print(is_palindrome_utf8("arara"))  --> true
print(is_palindrome_utf8("ação"))   --> false
print(is_palindrome_utf8("osso"))   --> true
