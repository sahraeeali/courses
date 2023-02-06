module Main exposing (..)

import Browser
import Html exposing (..)
import Task
import Time

-- MAIN
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL


type alias Model =
  { count: Int
  }

init : () -> (Model, Cmd Msg)
init _ =
  ( Model 0
  , Task.perform AdjustTimeZone Time.here
  )

-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      ( { model | count = model.count + 1 }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( model
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
  let
    count = String.fromInt model.count
  in
  h1 [] [ text count ]
