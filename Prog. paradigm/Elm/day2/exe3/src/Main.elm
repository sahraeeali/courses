--Exercise 2
module Main exposing (..)

import Playground exposing (..)

main =
  game view update ()

view computer memory =
  if computer.mouse.down then
      [ circle green 80
        |> moveX computer.mouse.x
        |> moveY computer.mouse.y
      ]
  else
      [ image 200 200 "Tiger.jpeg"
        |> moveX computer.mouse.x
        |> moveY computer.mouse.y
      ]

update computer memory =
  memory
