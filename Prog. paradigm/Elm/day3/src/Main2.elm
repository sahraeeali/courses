module Main exposing (..)

-- import Color exposing (..)
-- import Collage exposing (..)
import Browser exposing (..)
import Browser.Events exposing (..)
import Html exposing (..)
-- import Browser.Element exposing (Element, image, leftAligned, toHtml)
-- import Keyboard exposing (..)
import Playground exposing (..)
-- import Key exposing (..)
import List exposing ((::), all, filter, length)
import Random exposing (Seed, step, initialSeed, int)
-- import Text exposing (color, fromString, height, monospace)
import Time exposing (..)
import Time exposing (every)
import Svg exposing (..)
import Svg.Attributes exposing (..)

main = Browser.sandbox { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL
type State = Play | Pause | GameOver

type alias Head =
    {
        x: Float,
        y: Float,
        vx: Float,
        vy: Float,
        img: String
    }
type alias Player =
    {
        x: Float,
        score: Int
    }
type alias Model =
    {
        state: State,
        heads: List Head,
        player: Player,
        seed: Seed
    }

defaultHead n = { x=100.0, y=75, vx=60, vy=0.0, img=headImage n }
defaultGame = { state   = Pause,
                heads   = [],
                player  = {x=0.0, score=0},
                seed    = initialSeed 1234}

headImage n =
    case n of
        0 -> "evanczaplicki.jpg"
        1 -> "evanczaplicki.jpg"
        2 -> "evanczaplicki.jpg"
        3 -> "evanczaplicki.jpg"
        4 -> "evanczaplicki.jpg"
        _ -> ""

bottom = 550
secsPerFrame = 0.02
init = (defaultGame, Cmd.none)

-- UPDATE
stepGamePlay delta ({state, heads, player, seed} as game) = -- (4)
    let (rand, seeds) = step (int 0 4) seed
    in
        { game | state =  stepGameOver player heads
               , heads =  stepHeads heads delta player.score rand
               , player = stepPlayer player delta heads
               , seed  =  seeds}

stepGameOver player heads =
  if allHeadsSafe player heads then Play else GameOver

allHeadsSafe player heads =
    all (headSafe player) heads

headSafe player head =
    head.y < bottom || abs (head.x - player.x) < 50

stepHeads heads delta score rand =       -- (5)
  spawnHead score heads rand
  |> bounceHeads
  |> removeComplete
  |> moveHeads delta

spawnHead score heads rand =   -- (6)
  let addHead = length heads < (score // 5000 + 1) && all (\head -> head.x > 107.0) heads in
  if addHead then defaultHead rand :: heads else heads

bounceHeads heads = List.map bounce heads       -- (7)

bounce head =
  { head | vy = if head.y > bottom && head.vy > 0
                 then -head.vy * 0.95
                 else head.vy }

removeComplete heads = Svg.Attributes.filter (\x -> not (complete x)) heads  -- (8)

complete {x} = x > 750

moveHeads delta heads = List.map moveHead heads     -- (9)

moveHead ({x, y, vx, vy} as head) =
  { head | x = x + vx * secsPerFrame
         , y = y + vy * secsPerFrame
         , vy = vy + secsPerFrame * 400 }

stepPlayer player delta heads =
    { player | score = stepScore player heads }

stepPlayerLeft ({player} as model) =
    { model | player = { player | x = player.x - 75 } }

stepPlayerRight ({player} as model) =
    { model | player = { player | x = player.x + 75 } }

stepScore player heads =     -- (11)
  player.score +
  1 +
  1000 * (length (Svg.Attributes.filter complete heads))

stepGameFinished delta ({state, heads, player, seed} as game) =    -- (13)
  if player.score == 0 then defaultGame
  else { game | state = GameOver
              , player = { player |  x = toFloat 0 } }

flipPauseState model =
    case model.state of
        Play -> { model | state = Pause }
        Pause -> { model | state = Play }
        GameOver -> defaultGame

stepGame delta model =
    case model.state of
        Play -> stepGamePlay delta model
        Pause -> model
        GameOver -> stepGameFinished delta model


type Msg
    = Tick Time.Posix
      | Bool

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick delta -> (stepGame delta model, Cmd.none)
        True -> (flipPauseState model, Cmd.none)

-- Subscriptions
subscriptions : Model -> Computer -> Sub Msg
subscriptions model computer =
    Sub.batch
        [ Time.every 20 Tick
        , onKeyPress
        ]

-- VIEW
display ({state, heads, player, seed} as game) =
  let (w, h) = (800, 600)
  in ([ drawRoad w h
       , drawBuilding w h
       , drawPaddle w h player.x
       , drawScore w h player
       , drawMessage w h state] ++
       (drawHeads w h heads))

drawRoad w h =
  [rectangle gray (toFloat w) 100
  |> moveY (-(half h) + 50)]

drawBuilding w h =
  [rectangle red 100 (toFloat h)
  |> moveX (-(half w) + 50)]

drawHeads w h heads = List.map (drawHead w h) heads

drawHead w h head =
  let x = half w - head.x
      y = half h - head.y
      src = head.img
  in [Playground.image 75 75 src
     |> moveX -x
     |> moveY y
     |> Playground.rotate (x * 2 - 100)]

drawPaddle w h x =
  [rectangle black 80 10
  |> moveX (x +  10 -  half w)
  |> moveY (-(half h - 30))]

half x = toFloat x / 2

drawScore w h player =
  [words blue (String.fromInt player.score)
  |> moveX (half w - 150)
  |> moveY (half h - 40)]

drawMessage w h state =
  [words blue (stateMessage state)
  |> moveX 50
  |> moveY 50]

stateMessage state =
  if state == GameOver then "Game Over" else "Language Head"

view : Model -> Html Msg
view model memory = display model
