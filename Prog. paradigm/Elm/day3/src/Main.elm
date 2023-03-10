-- Compiled by Elm v0.15.1

module Main where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (Element, image, leftAligned)
import Keyboard
import List exposing ((::), all, filter, length)
import Mouse
import Random exposing (Seed, generate, initialSeed, int)
import Signal exposing (Signal, (<~), (~), foldp, map, sampleOn)
import Text exposing (color, fromString, height, monospace)
import Time exposing (Time, every, fps, inSeconds)
-- END:part1

-- START:part2
type State = Play | Pause | GameOver                               -- (1)

type alias Input = { space:Bool, x:Int, delta:Time }
type alias Head = { x:Float, y:Float, vx:Float, vy:Float, img:String }
type alias Player = { x:Float, score:Int }
type alias Game = { state:State, heads: List Head, player:Player, seed: Seed }

defaultHead n = {x=100.0, y=75, vx=60, vy=0.0, img=headImage n }   -- (2)

defaultGame = { state   = Pause,
                heads   = [],
                player  = {x=0.0, score=0},
                seed    = initialSeed 1234 }

headImage n =
  if | n == 0 -> "../evanczaplicki.jpg"
     | n == 1 -> "../e2.jpg"
     | n == 2 -> "../e3.jpeg"
     | n == 3 -> "../e4.jpg"
     | n == 4 -> "../e2.jpg"
     | otherwise -> ""

-- headImage n =
--   if n > headListLen || n < 0
--   then headList !! 1
--   else headList !! n



headList = [ "../evanczaplicki.jpg"
           , "../e2.jpg"
           , "../e3.jpeg"
           , "../e4.jpg"
           ]

headListLen = length headList - 1

infixl 9 !!
xs !! n = List.head (List.drop n xs)


bottom = 550
-- END:part2

-- START:part3
secsPerFrame = 1.0 / 50.0
delta = inSeconds <~ fps 50
input = sampleOn delta (Input <~ Keyboard.space
                               ~ Mouse.x
                               ~ delta)
main = map display (gameState)
gameState = foldp stepGame defaultGame input
-- END:part3

-- START:part4a
stepGame input game =                          -- (3)
  case game.state of
    Play -> stepGamePlay input game
    Pause -> stepGamePaused input game
    GameOver -> stepGameFinished input game

stepGamePlay {space, x, delta} ({state, heads, player, seed} as game) = -- (4)
    let (rand, seed') =
        generate (int 0 4) seed
    in
        { game | state <-  stepGameOver x heads
               , heads <-  stepHeads heads delta x player.score rand
               , player <- stepPlayer player x heads
               , seed  <-  seed' }

stepGameOver x heads =
  if allHeadsSafe (toFloat x) heads then Play else GameOver

allHeadsSafe x heads =
    all (headSafe x) heads

headSafe x head =
    head.y < bottom || abs (head.x - x) < 50
-- END:part4a

-- START:part4b
stepHeads heads delta x score rand =       -- (5)
  spawnHead score heads rand
  |> bounceHeads
  |> removeComplete
  |> moveHeads delta

spawnHead score heads rand =   -- (6)
  let addHead = length heads < (score // 5000 + 1)
    && all (\head -> head.x > 107.0) heads in
  if addHead then defaultHead rand :: heads else heads

bounceHeads heads = List.map bounce heads       -- (7)

gravity = 0.95
bounce head =
  { head | vy <- if head.y > bottom && head.vy > 0
                 then -head.vy * gravity
                 else head.vy }

removeComplete heads = filter (\x -> not (complete x)) heads  -- (8)

complete {x} = x > 750

moveHeads delta heads = List.map moveHead heads     -- (9)

moveHead ({x, y, vx, vy} as head) =
  { head | x <- x + vx * secsPerFrame
         , y <- y + vy * secsPerFrame
         , vy <- vy + secsPerFrame * 400 }
-- END:part4b

-- START:part4c
stepPlayer player mouseX heads =     -- (10)
  { player | score <- stepScore player heads
           , x <- toFloat mouseX }

stepScore player heads =     -- (11)
  player.score +
  1 +
  1000 * (length (filter complete heads))
-- END:part4c

-- START:part4d
stepGamePaused {space, x, delta} ({state, heads, player, seed} as game) =    -- (12)
  { game | state <- stepState space state
         , player <- { player |  x <- toFloat x } }

stepGameFinished {space, x, delta} ({state, heads, player, seed} as game) =    -- (13)
  if space then defaultGame
  else { game | state <- GameOver
              , player <- { player |  x <- toFloat x } }

stepState space state = if space then Play else state   -- (14)
-- END:part4d

-- START:part5
display ({state, heads, player, seed} as game) =   -- (15)
  let (w, h) = (800, 600)
  in collage w h
       ([ drawRoad w h
       , drawBuilding w h
       , drawPaddle w h player.x
       , drawScore w h player
       , drawMessage w h state] ++
       (drawHeads w h heads))

drawRoad w h =   -- (16)
  toForm (image 800 160 "../road.jpg")
  |> moveY (-(half h) + 50)

drawBuilding w h =
  toForm (image 140 600 "../building.jpeg")
  |> moveX (-(half w) + 50)

drawHeads w h heads = List.map (drawHead w h) heads    -- (17)

drawHead w h head =
  let x = half w - head.x
      y = half h - head.y
      src = head.img
  in toForm (image 75 75 src)
     |> move (-x, y)
     |> rotate (degrees (x * 2 - 100))

drawPaddle w h x =   -- (18)
  filled black (rect 80 10)
  |> moveX (x +  10 -  half w)
  |> moveY (-(half h - 30))

half x = toFloat x / 2

drawScore w h player =      -- (19)
  toForm (fullScore player)
  |> move (half w - 150, half h - 40)

fullScore player = txt (height 50) (toString player.score)

txt f = leftAligned << f << monospace << color blue << fromString

drawMessage w h state =    -- (20)
  toForm (txt (height 50) (stateMessage state))
  |> move (50, 50)

stateMessage state =
  case state of
    GameOver -> "Game Over"
    Pause -> "Press spacebar to start"
    otherwise -> "Language Head"
-- END:part5
