--[[
  Author: Marllon
  Date: 2025-07-14
  Book: Programming in Lua (4th ed.)
  Book Author: Roberto Ierusalimschy

  ========================================
  Part I: The Basics
  Chapter: 3 - Numbers
  ========================================

  These are the notes and code examples from the third chapter of the book.

  obs: i have no idea what i am doing.
--]]

--------------------------------------------------------------------------------

--[[
  In lua 5.2 and previous versions, all numbers are represented as double-precision floating-point numbers.
  In version 5.3 and later, Lua now uses two types of numbers: integers(64 bits) and floats.
--]]

--------------------------------------------------------------------------------

-- [[ Numerals: ]]

-- In lua we can write numeric constants in several ways:
--[[
  4       --> 4
  0.4     --> 0.4
  4.57e-3 --> 0.00457
  0.3e12  --> 300000000000.0
  5E+20   --> 5e+20
--]]
-- using the type function we can see that integers and floats are both represented as numbers:
print(type(4))       --> number
print(type(0.4))     --> number
print(type(4.57e-3)) --> number

-- Integers and floats that have the same value are considered equal:
print(4 == 4.0)                 --> true
print(0.3e12 == 300000000000.0) --> true
print(0.2e3 == 200)             --> true

-- to differentiate between integers and floats, we can use the math.type function:
print(math.type(4))       --> integer
print(math.type(0.4))     --> float
print(math.type(4.57e-3)) --> float

-- lua also supports hexadecimal numbers:
print(0xff)    --> 255
print(0xa.bp2) --> 42.75
print(0x0.2)   --> 0.125

-- we can write numbers in the hexadecimal format using string.format with %a:
print(string.format("%a", 419)) --> 0x1.a3p+8
print(string.format("%a", 0.1)) --> 0x1.999999999999ap-4

--------------------------------------------------------------------------------

-- [[ Arithmetic Operations: ]]
-- Lua supports the following arithmetic operations:
--[[
  Lua has the usual gang of arithmetic operators you'd expect:
  +   (addition)
  -   (subtraction)
  *   (multiplication)
  /   (division)
  ^   (exponentiation)
  %   (modulo)
  //  (floor division)
  -   (unary negation, e.g., -10)
--]]
--[[
  This is the main theme of the chapter. Lua 5.3 introduced a formal distinction
  between integers (whole numbers) and floats (numbers with decimal parts).
  The big idea is that you can either ignore the difference most of the time,
  or be super specific if you need to.

  The Basic Rule:
  For `+`, `-`, `*`, and unary `-`:
  - If BOTH operands are integers, the result is an INTEGER.
  - If EITHER operand is a float, the result is a FLOAT.

  Lua automatically converts the integer to a float when you mix them.
--]]

-- Integer + Integer -> Integer
print(10 + 5) --> 15

-- Float + Float -> Float
print(10.0 + 5.0) --> 15.0

-- Integer + Float -> Float (the integer 5 gets promoted to 5.0)
print(10.0 + 5) --> 15.0

-- Same deal for multiplication
print(-(3 * 6.0)) --> -18.0

-- Division (/) is Special
--[[
  Because dividing two integers doesn't always result in an integer (e.g., 5 / 2 = 2.5),
  the standard division operator `/` ALWAYS works with floats and ALWAYS returns a float.
  This avoids weird surprises.
--]]
print(3 / 2)     --> 1.5
print(4 / 2)     --> 2.0 (still a float, even though the value is whole)
print(4.0 / 2.0) --> 2.0

-- Floor Division (//)
--[[
  Since regular division always gives a float, Lua 5.3 added floor division `//`
  for when you specifically want an integer result from a division.

  - It performs the division and then rounds the result DOWN to the nearest integer
  - It follows the same integer/float rule as addition:
    - integer // integer -> integer
    - if either is a float -> float (but the value will be integral)
--]]
print(3 // 2)   --> 1
print(6 // 2)   --> 3
print(7.0 // 2) --> 3.0 (a float, but a whole number)
print(-9 // 2)  --> -5  (rounded DOWN from -4.5)

-- Modulo (%)
--[[
  The modulo operator gives you the remainder of a division.
  The formula is basically: `a % b == a - ((a // b) * b)`

  The result's sign is always the same as the SECOND operand's sign.
  This is super useful for making numbers wrap around in a predictable way.
--]]
print(10 % 3)   --> 1
print(10 % -3)  --> -2
print(-10 % 3)  --> 2
print(-10 % -3) --> -1

-- A cool trick: `x % K` for a positive `K` is always between 0 and K-1.
-- This is great for cycling through array indices, for example.
for i = -5, 5 do
  print(i, i % 2) -- result is always 0 or 1 (or -0, which is just 0)
end

-- Another weirdly useful trick: truncating decimals.
local pi = math.pi     -- approx 3.14159...
print(pi - pi % 0.01)  --> 3.14
print(pi - pi % 0.001) --> 3.141

-- And normalizing angles is a classic use case.
-- This function checks if a turn angle (in degrees) is basically a U-turn.
local tolerance = 10
function is_turn_back(angle)
  angle = angle % 360 -- Normalize angle to be between 0 and 359
  return (math.abs(angle - 180) < tolerance)
end

print(is_turn_back(181))  --> true
print(is_turn_back(-181)) --> true (because -181 % 360 is 179)

-- Exponentiation (^)
--[[
  The power operator `^` is like the division operator: it's a float-only party.
  It always works with floats and gives a float result, because exponents can
  get weird (e.g., 2^-2 = 0.25, which isn't an integer).
--]]
print(2 ^ 3)       --> 8.0
print(4 ^ 0.5)     --> 2.0 (this is how you do a square root)
print(8 ^ (1 / 3)) --> 2.0 (and a cubic root)

--------------------------------------------------------------------------------

-- [[ Relational Operators: ]]
--[[
  These are your standard comparison operators. They all return a boolean: `true` or `false`.
  <   (less than)
  >   (greater than)
  <=  (less than or equal to)
  >=  (greater than or equal to)
  ==  (equal to)
  ~=  (not equal to)

  The `==` (equality) and `~=` (inequality) operators can be used on any two values.
  - If the types are different, they are not equal. Simple as that.
  - If the types are the same, Lua compares their values.

  For numbers, the subtype (integer vs. float) doesn't matter for the comparison,
  only the mathematical value.
--]]
print(3 == 3.0)   --> true
print(3 ~= 3.0)   --> false
print(0 == "0")   --> false (different types)
print(2 < 10)     --> true
print("2" < "10") --> false (lexicographical/alphabetical comparison, "2" comes after "1")

--------------------------------------------------------------------------------

-- [[ The Mathematical Library (math): ]]
--[[
  Lua comes with a standard `math` library containing functions like trig functions (sin, cos, tan), logs,
  rounding functions, max/min, and random number generation.

  It also gives you a couple of useful constants: `math.pi` and `math.huge`.
  `math.huge` is the largest possible number your system can represent, which is
  usually infinity (`inf`).

  IMPORTANT: All trig functions in the math library work in RADIANS, not degrees.
  Luckily, the library includes `math.rad(degrees)` and `math.deg(radians)` to
  make conversion easy.
--]]

print(math.sin(math.pi / 2))     --> 1.0
print(math.cos(math.rad(180)))   --> -1.0
print(math.max(10.4, 7, -3, 20)) --> 20
print(math.huge)                 --> inf

-- Random-number Generator
-- The `math.random` function is your go-to for pseudo-random numbers.
-- You can call it in three ways:
-- 1. `math.random()`: no arguments, gives a float between 0 and 1 (e.g., 0.12345)
-- 2. `math.random(n)`: one integer argument, gives an integer between 1 and n (e.g., `math.random(6)` for a die roll)
-- 3. `math.random(l, u)`: two integer arguments, gives an integer between l and u (e.g., `math.random(10, 20)`)
print(math.random())
print(math.random(6))      --> 4 (example output, simulating a die roll)
print(math.random(10, 20)) --> 15 (example output, random number between 10 and 20)

-- To avoid getting the same sequence of "random" numbers every time you run the script,
-- you need to set a "seed". A common trick is to use the current time.
math.randomseed(os.time())

-- Rounding Functions
-- The math library gives you three ways to round:
-- `math.floor(x)`: rounds down (towards negative infinity)
-- `math.ceil(x)`: rounds up (towards positive infinity)
-- `math.modf(x)`: rounds towards zero. This one is special, it returns TWO values:
--                  the rounded integer part and the fractional part.

print(math.floor(3.3))  --> 3
print(math.floor(-3.3)) --> -4

print(math.ceil(3.3))   --> 4
print(math.ceil(-3.3))  --> -3

local int_part, frac_part = math.modf(3.3)
print(int_part, frac_part) --> 3   0.3

local int_part2, frac_part2 = math.modf(-3.3)
print(int_part2, frac_part2) --> -3  -0.3

-- How to Round to the Nearest Integer
-- The simple way is `math.floor(x + 0.5)`, but it can fail with really large numbers
-- or when you want "unbiased rounding".

-- Unbiased rounding means .5 is rounded to the nearest EVEN number (e.g., 2.5 -> 2, but 3.5 -> 4).
-- The book shows a clever way to do this using the modulo operator.
function unbiased_round(x)
  local f = math.floor(x)
  -- The `x % 2.0 == 0.5` part is a clever test to see if rounding `x + 0.5` would
  -- result in an odd number when it shouldn't.
  if (x == f) or (x % 2.0 == 0.5) then
    return f
  else
    return math.floor(x + 0.5)
  end
end

print(unbiased_round(2.5))  --> 2
print(unbiased_round(3.5))  --> 4
print(unbiased_round(-2.5)) --> -2

--------------------------------------------------------------------------------

-- [[ Representation Limits: ]]
--[[
  Integer Limits (64-bit):
  - There's a max and min value, available as `math.maxinteger` and `math.mininteger`.
  - When you go past these limits, the number "wraps around". It's like an old car's odometer
    flipping back to zero after hitting its max mileage.
  - This means adding 1 to the max integer gives you the min integer. Weird, but predictable.
--]]
print(math.maxinteger)                        --> 9223372036854775807
print(math.mininteger)                        --> -9223372036854775808

print(math.maxinteger + 1)                    --> -9223372036854775808
print(math.mininteger - 1)                    --> 9223372036854775807

print(math.maxinteger + 1 == math.mininteger) --> true
print(math.mininteger - 1 == math.maxinteger) --> true

--[[
  Floating-Point Limits (double precision):
  - Floats have a much, much larger range than integers (like, up to 10^308).
  - But they have limited precision. They can only accurately store about 16 decimal digits.
  - The big gotcha: some numbers that look simple in decimal (like 0.1 or 12.7) don't have
    an exact representation in binary, so tiny rounding errors can happen.
    `12.7 - 20 + 7.3` might not be exactly zero.

  Limits Colliding:
  - Because of these different behaviors, doing math at the limits can give wildly different results.
--]]
-- Integer addition wraps around
print(math.maxinteger + 2) --> -9223372036854775807

-- Float addition gets rounded to an approximate (and huge) value
print(math.maxinteger + 2.0) --> 9.2233720368548e+18

--[[
  - Up to 2^53 (which is a massive number), floats can represent every integer value exactly.
  - Inside this range, you can usually mix integers and floats without worrying.
  - Outside this range, you need to think about whether you need the exactness of an integer
    or the massive range of a float.
--]]

--------------------------------------------------------------------------------

-- [[ Conversions: ]]
--[[
  Sometimes you need to explicitly convert a number from one subtype to another.

  To Float:
  - The easy way to force a number to be a float is to add 0.0 to it.
  - Any integer up to 2^53 can be converted to a float with no loss of precision.
  - Above that, you might lose some precision due to rounding.
--]]
print(9007199254740992 + 0.0 == 9007199254740992) --> true
print(9007199254740993 + 0.0 == 9007199254740993) --> false (the float conversion rounds it down)

--[[
  To Integer:
  - You can use a bitwise OR with 0 (`| 0`) to force a number to an integer.
    This will only work if the number has no fractional part and fits inside the
    integer range. Otherwise, it throws an error.
  - A safer way is `math.tointeger(x)`. This function tries to convert `x` to an
    integer and returns `nil` if it can't (because it's out of range or has a
    fractional part). This is great for checking if a conversion is possible.
--]]
print(math.tointeger(-258.0)) --> -258
print(math.tointeger(5.01))   --> nil
print(math.tointeger(2 ^ 64)) --> nil

-- This makes it easy to write a "conditional conversion" function.
function cond2int(x)
  -- `tointeger` returns the integer if it works, or nil if it fails.
  -- The `or x` part means "if the first part was nil, just use the original x".
  return math.tointeger(x) or x
end

print(cond2int(3.0))  --> 3
print(cond2int(3.14)) --> 3.14

--------------------------------------------------------------------------------

-- [[ Operator Precedence: ]]
--[[
  This is the order of operations in Lua, from highest priority to lowest.
  Things at the top of the list get calculated before things at the bottom.

  1. ^ (exponentiation)
  2. unary operators (not, #, -, ~)
  3. * /   //   %
  4. +   -
  5. .. (string concatenation)
  6. <<  >> (bitwise shifts)
  7. & (bitwise AND)
  8. ~ (bitwise XOR)
  9. | (bitwise OR)
  10. <   >   <=  >=  ~=  ==
  11. and
  12. or

  Associativity:
  - Most operators are "left associative", meaning they are evaluated from left to right.
    `a + b + c` is the same as `(a + b) + c`.
  - The exceptions are `^` (exponentiation) and `..` (concatenation), which are
    "right associative". They get evaluated from right to left.
    `x^y^z` is the same as `x^(y^z)`.

  When in doubt, just use parentheses `()`. It makes your code easier to read
  and saves you from having to memorize this whole list.
--]]
-- -x^2 is the same as -(x^2)
print(-4 ^ 2) --> -16.0

-- x^y^z is the same as x^(y^z)
print(2 ^ 3 ^ 2) --> 512.0 (which is 2^9, not 8^2)

--------------------------------------------------------------------------------

--[[ Solutions for Exercises - Chapter 3 ]]

-- Exercise 3.1: Which of the following are valid numerals? What are their values?
--[[
  .0e12       -> Valid. It's 0.0 * 10^12, which is 0.0.
  .e12        -> Invalid. Missing digits before the exponent.
  0.0e        -> Invalid. Missing digits after the exponent.
  0x12        -> Valid. It's a hexadecimal number. 1*16 + 2 = 18.
  0xABFG      -> Invalid. 'F' is a valid hex digit, but 'G' is not.
  0xA         -> Valid. Hexadecimal 'A' is 10.
  FFFF        -> Invalid. Without the '0x' prefix, this is just an identifier.
  0xFFFFFFFF  -> Valid. Hexadecimal for 2^32 - 1.
  0x          -> Invalid. Needs digits after the '0x'.
  0x1P10      -> Valid. Hexadecimal float. 1 * 2^10 = 1024.0.
  0.1e1       -> Valid. It's 0.1 * 10^1, which is 1.0.
  0x0.1p1     -> Valid. Hexadecimal float. (1/16) * 2^1 = 0.125.
--]]

-- Exercise 3.2: Explain the following results:
--[[
  Remember that 64-bit integer math wraps around. The "number circle" has 2^64 positions.
  `math.maxinteger` is `2^63 - 1`. `math.mininteger` is `-2^63`.

  > math.maxinteger * 2 --> -2
    `maxinteger` is `2^63 - 1`.
    `2 * (2^63 - 1)` is `2^64 - 2`.
    Modulo `2^64`, this is simply `-2`. The `2^64` part wraps around to 0.

  > math.mininteger * 2 --> 0
    `mininteger` is `-2^63`.
    `2 * (-2^63)` is `-2^64`.
    Modulo `2^64`, this is `0`.

  > math.maxinteger * math.maxinteger --> 1
    This is `(2^63 - 1) * (2^63 - 1)`, which expands to `(2^63)^2 - 2*2^63 + 1`.
    This is `2^126 - 2^64 + 1`.
    Both `2^126` and `2^64` are multiples of `2^64`, so they wrap around to 0.
    What's left is just `1`.

  > math.mininteger * math.mininteger --> 0
    This is `(-2^63) * (-2^63)`, which is `(2^63)^2`, or `2^126`.
    Since `126 >= 64`, `2^126` is a multiple of `2^64`, so it wraps around to `0`.
--]]

print(math.maxinteger * 2)               --> -2
print(math.mininteger * 2)               --> 0
print(math.maxinteger * math.maxinteger) --> 1
print(math.mininteger * math.mininteger) --> 0

-- Exercise 3.3: What will the following program print?
for i = -10, 10 do
  print(i, i % 3)
end
--[[
  for i = -10, 10 do print(i, i % 3) end
  It will print the number `i` and the remainder of `i` divided by 3.
  The key is that the result of `a % b` always has the same sign as `b`.
  Since `b` is `3` (positive), the result will always be positive.
  The results for `i % 3` will cycle through `2, 0, 1, 2, 0, 1, ...`
  For example:
  -10  2
  -9   0
  -8   1
  ...
  0    0
  1    1
  2    2
  3    0
--]]

-- Exercise 3.4: What is the result of the expression 2^3^4? What about 2^-3^4?
--[[
  Exponentiation `^` is right-associative, so `a^b^c` is calculated as `a^(b^c)`.
  > 2^3^4 is `2^(3^4)`, which is `2^81`. This is a massive number.
  > 2^-3^4 is `2^(-(3^4))`, which is `2^-81`. This is a very tiny number, close to zero.
--]]
print(2 ^ 3 ^ 4)  --> 2.4178516392293e+24
print(2 ^ -3 ^ 4) --> 4.1359030627651e-25

-- Exercise 3.5: The number 12.7 is equal to the fraction 127/10, where the denominator is a power of ten. Can
-- you express it as a common fraction where the denominator is a power of two? What about the number 5.5?
--[[
  A number can have a finite representation in binary if and only if, when written as
  an irreducible fraction, its denominator is a power of two.

  > 12.7 = 127/10. The denominator is 10, which is `2 * 5`. Because of the `5`,
    it cannot be expressed as a fraction with a denominator that is a power of two.
    Therefore, 12.7 has an infinite representation in binary.

  > 5.5 = 55/10 = 11/2. The denominator is 2, which is `2^1`.
    Yes, this one can be represented. In binary, it's `101.1`.
--]]

-- Exercise 3.6: Write a function to compute the volume of a right circular cone, given its height and the
-- angle between a generatrix and the axis
function cone_volume(height, angle)
  -- The angle is between the generatrix and the axis.
  -- We need the radius, which is `r = height * tan(angle)`.
  -- The angle from the book must be in radians for `math.tan`.
  local radius = height * math.tan(angle)
  return (1 / 3) * math.pi * (radius ^ 2) * height
end

print(cone_volume(10, math.rad(30))) -- Example usage, height = 10, angle = 30 degrees

-- Exercise 3.7: Using math.random, write a function to produce a pseudo-random number with a standard
-- normal (Gaussian) distribution.
--[[
  This is a classic problem. The standard way to do it is with the "Box-Muller transform".
  It takes two independent, uniform random numbers from [0, 1) and generates two
  independent, standard normal random numbers.
--]]

local has_spare_gaussian = false
local spare_gaussian = 0

function gaussian_random()
  if has_spare_gaussian then
    has_spare_gaussian = false
    return spare_gaussian
  else
    local u, v, s
    repeat
      u = math.random() * 2 - 1 -- a random number in [-1, 1)
      v = math.random() * 2 - 1 -- another one
      s = u * u + v * v
    until s > 0 and s < 1

    local mul = math.sqrt(-2 * math.log(s) / s)
    spare_gaussian = v * mul
    has_spare_gaussian = true
    return u * mul
  end
end

for i = 1, 10 do
  print(gaussian_random())
end
