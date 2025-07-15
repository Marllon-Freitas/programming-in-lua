--[[
  Author: Marllon
  Date: 2025-07-14
  Book: Programming in Lua (4th ed.)
  Book Author: Roberto Ierusalimschy

  ========================================
  Part I: The Basics
  Chapter: 2 - The Eight-Queen Puzzle
  ========================================

  These are the notes and code examples from the second chapter of the book.

  obs: i have no idea what i am doing.
--]]

--------------------------------------------------------------------------------

-- [[ The Problem: The Eight-Queen Puzzle ]]
-- The objective is to place eight chess queens on an 8x8 chessboard in such a
-- way that no two queens threaten each other. This means no two queens can
-- share the same row, column, or diagonal.

--------------------------------------------------------------------------------

--[[
  Board Representation:
  A key insight is that any valid solution must have exactly one queen per row.
  Therefore, we can represent the board using a simple one-dimensional array (a table in Lua)
  of size 8. The index of the array represents the row, and the value at that
  index represents the column where the queen is placed.

  For example, `a = {3, 7, 2, ...}` means the queen in row 1 is in column 3,
  the queen in row 2 is in column 7, the queen in row 3 is in column 2, and so on.

  This representation automatically satisfies the "one queen per row" constraint.
  The program must then check for column and diagonal conflicts.

  Backtracking Algorithm:
  The program uses a recursive technique called backtracking. It works as follows:
  1. Try to place a queen in a column of the current row.
  2. Check if this placement is valid (i.e., not attacked by queens already placed in previous rows).
  3. If it's valid, move to the next row and repeat step 1.
  4. If no valid column is found in the current row, or if a future step fails,
     "backtrack" to the previous row and try the next column for that queen.
  5. If a queen has been successfully placed in all rows, a solution has been found.
--]]

--------------------------------------------------------------------------------

-- [[ Code Breakdown: ]]

-- The program is structured into three main functions and a final call to start the process.
N = 8 -- Board size

--[[ isplaceok(a, n, c) ]]
-- This function checks if it's "OK" to place the n-th queen in column 'c'.
-- It iterates through all previously placed queens (from row 1 to n-1) and checks for conflicts.
function isplaceok(a, n, c)
  for i = 1, n - 1 do            -- For each queen already placed
    if (a[i] == c) or            -- Check for same column
        (a[i] - i == c - n) or   -- Check for same main diagonal
        (a[i] + i == c + n) then -- Check for same anti-diagonal
      return false               -- An attack is possible, so the place is not ok
    end
  end
  return true -- No attacks found; the place is ok
end

--[[ printsolution(a) ]]
-- This function takes a complete, valid board configuration `a` and prints it to the console.
-- It uses a nested loop to iterate through every square of the board.
-- It prints "X" for a queen and "-" for an empty square.
function printsolution(a)
  for i = 1, N do   -- For each row
    for j = 1, N do -- For each column
      -- Note the use of the `and-or` idiom from Chapter 1.
      -- If `a[i] == j` is true, the result is "X".
      -- If it's false, the result is "-".
      io.write(a[i] == j and "X" or "-", " ")
    end
    io.write("\n") -- Newline after each row
  end
  io.write("\n")   -- Extra newline to separate solutions
end

--[[ addqueen(a, n) ]]
-- This is the main recursive function that implements the backtracking algorithm.
-- It tries to place queens from row `n` to `N` on the board `a`.
function addqueen(a, n)
  if n > N then
    -- Base case: If `n` is greater than `N`, it means we have successfully
    -- placed all `N` queens. The solution is complete and can be printed.
    printsolution(a)
  else
    -- Recursive step: Try to place the n-th queen.
    for c = 1, N do -- Iterate through all possible columns for the current row `n`.
      if isplaceok(a, n, c) then
        a[n] = c    -- Place the n-th queen at column `c`.
        -- Now, recursively try to place the rest of the queens.
        addqueen(a, n + 1)
        -- The program automatically "backtracks" because if the `addqueen(a, n + 1)` call
        -- finishes (either by finding solutions or by hitting dead ends), this `for`
        -- loop simply continues to the next column `c`, overwriting `a[n]` with a new attempt.
      end
    end
  end
end

-- It calls `addqueen` with an empty board `{}` and tells it to start by placing the 1st queen.
addqueen({}, 1)

--------------------------------------------------------------------------------

--[[ Solutions for Exercises - Chapter 2 ]]

-- Exercise 2.1: Modify the eight-queen program so that it stops after printing the first solution.
--[[
  To exit the program after finding the first solution, we can use `os.exit()`.
  This will terminate the program immediately after printing the first valid board configuration.
--]]

function addqueen_and_stop(a, n)
  if n > N then
    print("--- Exercise 2.1: First solution found ---")
    printsolution(a)
    os.exit()
  else
    for c = 1, N do
      if isplaceok(a, n, c) then
        a[n] = c
        addqueen_and_stop(a, n + 1)
      end
    end
  end
end

--addqueen_and_stop({}, 1)

--------------------------------------------------------------------------------

-- Exercise 2.2: An alternative implementation for the eight-queen problem would be to generate all possible
-- permutations of 1 to 8 and, for each permutation, to check whether it is valid. Change the program to use
-- this approach. How does the performance of the new program compare with the old one? (Hint: compare
-- the total number of permutations with the number of times that the original program calls the function
-- isplaceok.)

--[[
  This program demonstrates two different approaches to solving the N-Queens problem:

  1. BACKTRACKING APPROACH (Original):
     - Uses recursive backtracking with constraint propagation
     - Places queens incrementally, one row at a time
     - Immediately abandons partial solutions when conflicts are detected
     - Employs pruning to avoid exploring invalid branches
     - Highly efficient due to early termination of invalid paths

  2. PERMUTATION APPROACH (Alternative):
     - Generates all possible permutations of column positions
     - Each permutation represents a complete queen placement (one per row/column)
     - Validates each complete permutation for diagonal conflicts
     - Must examine all N! possible arrangements before filtering valid solutions
     - Computationally expensive but conceptually straightforward

  The permutation method examines all 8! = 40,320 possible arrangements, while
  the backtracking method typically explores only a few thousand states due to
  intelligent pruning. This demonstrates the significant advantage of constraint
  satisfaction algorithms over brute-force enumeration approaches.
--]]

-- First, a function to check if a COMPLETED board is valid.
-- It only needs to check diagonals, since permutations already handle row/column conflicts.
function is_valid_permutation(a)
  for i = 1, N do
    for j = i + 1, N do
      -- math.abs(a[i] - a[j]) is the column distance
      -- (j - i) is the row distance
      -- if they're equal, the queens are on the same diagonal.
      if math.abs(a[i] - a[j]) == (j - i) then
        return false
      end
    end
  end
  return true
end

-- A counter to see how much work we're doing.
local permutation_checks = 0

-- A recursive function to generate all the permutations.
function generate_and_check(a, n)
  if n > N then
    permutation_checks = permutation_checks + 1
    if is_valid_permutation(a) then
      printsolution(a)
    end
  else
    for i = n, N do
      a[n], a[i] = a[i], a[n]
      generate_and_check(a, n + 1)
      a[n], a[i] = a[i], a[n]
    end
  end
end

print("\n--- Exercise 2.2: Brute-force permutation method ---")
local initial_board = { 1, 2, 3, 4, 5, 6, 7, 8 }
generate_and_check(initial_board, 1)
print("Total permutations checked: " .. permutation_checks)
print("the original program's makes ~15,720 checks.")
