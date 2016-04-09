module Main (..) where

import Html exposing (Html)
import Mouse


type alias Model = { count : Int }

type Action = NoOp | Increase

-- state
initialModel : Model
initialModel = { count = 0 }


-- does nothing but display model
view : Model -> Html
view model = Html.text (toString model.count)

updateModelCount : Action -> Model -> Model
updateModelCount action model = case action of
    Increase -> { model | count = model.count + 1 }
    NoOp -> model

actionSignal : Signal.Signal Action
actionSignal = Signal.map (\_ -> Increase) Mouse.clicks

modelSignal : Signal.Signal Model
modelSignal = Signal.foldp updateModelCount initialModel actionSignal


main : Signal.Signal Html
main =
  Signal.map view modelSignal
