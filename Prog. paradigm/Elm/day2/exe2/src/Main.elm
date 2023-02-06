--Exercise 2
module Main exposing (..)

import Playground exposing (..)

main =
  game view update ()

view computer memory =
  if computer.mouse.down then
      [ words black (String.fromFloat computer.mouse.y)
      ]
  else
      [ words black ""
      ]

update computer memory =
  memory
