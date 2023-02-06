-- Elm 0.19.1

-- Exercise 1: Write a function to find the product of a list of numbers.
product xs = List.foldl (*) 1 xs
product [1,2,3,4]

-- Exercise 2: Write a function to return all of the x fields from a list of point records.
allX ps =
  case ps of
    []     -> []
    p::t -> abs p.x :: allX t

allX [{x=5, y=3}, {x=12,y=111}]

-- Exercise 3: Use records to describe a person containing name, age and address. You should also express the address as a record.
address = { street = "Y ring"
          , town   = "Linkoping"
          , county = "Ostergotland"
          }

person = { name    = "Ali"
         , age     = 25
         , address = address
         }

-- Exercise 4: Is it easier to use abstract data types or records to solve the previous problem? Why?
-- Records are easier because I am more comfortable with the syntax :)

-- Exercise 5: Write a function called multiply.
multiply x y  = x * y

-- Exercise 6: Use currying to express 6 * 8.
multiplyBy6 y = multiply 6 y

-- Exercise 7:
people =
  [ { name = "OLD", age = 28}
  , { name = "TEEN",age = 16}
  , { name = "CHILD",age = 5}
  , { name = "OLDER",age = 33}
  , { name = "BABY",age = 2}
  ]

olderThan16 ps =
  case ps of
    []      -> []
    p::t  -> if p.age > 16
                  then p :: olderThan16 t
                  else olderThan16 t

olderThan16 people
