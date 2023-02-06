#1. Fibonacci
"First Exercise" println

fib := method( num,
    if (num < 3,
        return 1
    )
    first := second := 1
    for( unused, 1, num-1,
        running_total := first + second
        first := second;
        second = running_total;
    )
    return first
)

writeln( "Iteration ",
                5,
                ": ",
              fib(5)
              )


writeln( "Iteration ",
                10,
                ": ",
              fib(10)
              )

# 2. How would you change / to return 0 if the denominator is zero?
"Second Exercise" println
Number origDiv := Number getSlot("/")
Number / = method(denom, if(denom == 0, 0, self origDiv(denom)))

4 / 2 println
4 / 0 println

# 3. Write a program to add up all of the numbers in a two-dimensional array.
"Third Exercise" println
list_sum := method ( list, list flatten sum )

list_sum( list( list(10,10), list(3,4))) println

# 4. Add a slot called myAverage to a list that computes the average of all the
# numbers in a list. What happens if there are no numbers in a list?
"Fourth Exercise" println
#List myAverage := method( return sum/size )
List myAverage := method(self average)

x := list (1,2,3)
x myAverage println

# 5. Write a prototype for a two-dimensional list. The dim(x,y) method should
# allocate a list of y lists that are x elements long, set(x, y, value) should
# set a value, and get(x, y) should return that value.
"Fifth Exercise" println

List2D := List clone
List2D transposed := false

List2D dim := method(x, y,
    y repeat(
        inner := list()
        x repeat(inner push(nil))
        self append(inner)
    )
)

List2D get := method (x,y,
        return self at(x) at(y)
)

List2D set := method (x,y,value,
        self at(x) atPut(y,value)
        return self
)

"Creating matrices" println
firstMatrix := List2D clone
firstMatrix dim(6,7) println
"" println

secondMatrix := List2D clone
secondMatrix dim(6,7) println
"" println

"Setting and getting a matrix" println
firstMatrix set(3,5,"blah blah")
firstMatrix println
"" println

firstMatrix get(3,5) println
firstMatrix get(2,2) println


"Sixth Exercise is a bonus exercise." println


# 7. Write the matrix to a file, and read a matrix from a file.
"Seventh Exercise." println
"Writing a matrix to a file" println
file := File with("matrix.txt")
file remove
file openForUpdating
file write(firstMatrix join(", "))
file close

"Reading a matrix from a file" println
file = File with("matrix.txt")
file openForReading
lines := file readLines
file close
lines at(0) type println
matrixFromFile := lines at(0) split(", ")
matrixFromFile type println
matrixFromFile println

# 8. Write a program that gives you ten tries to guess a random number from
# 1-100. If you would like, give a hint of "hotter" or "colder" after the first
# guess.
"Eighth Exercise: Random number guesser" println
to_guess  := Random value(1,100) round
i         := 0
prev_diff := nil
in        := File standardInput;

"\nGuess the number (1-100)!" println

while(i<10,
  guess := in readLine("Your guess: ")
  guess := guess asNumber
  difference := (to_guess - guess) abs
  if( difference == 0,
    "Congratulations, you win!" println
    break
  )
  if((prev_diff and prev_diff != difference),
    if(prev_diff > difference,
      "Hotter" println,
      "Colder" println
    )
  )
  prev_diff := difference
)
