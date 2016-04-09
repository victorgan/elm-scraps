module Main (..) where

import Html exposing (Html)
import Mouse
import Keyboard

type alias Model = { count : Int }

type Action = NoOp | MouseClick | KeyPress

-- state
initialModel : Model
initialModel = { count = 0 }


-- does nothing but display model
view : Model -> Html
view model = Html.text (toString model.count)

updateModelCount : Action -> Model -> Model
updateModelCount action model = case action of
    NoOp -> model
    MouseClick -> { model | count = model.count + 1 }
    KeyPress -> { model | count = model.count - 1 }

-----------------------------------------------------------------
-- Defining Signals.
-----------------------------------------------------------------
keyPressSignal : Signal.Signal Action
keyPressSignal = Signal.map (\_ -> KeyPress) Keyboard.presses

mouseClickSignal : Signal.Signal Action
mouseClickSignal = Signal.map (\_ -> MouseClick) Mouse.clicks

actionSignal : Signal.Signal Action
actionSignal = Signal.merge mouseClickSignal keyPressSignal

-----------------------------------------------------------------
-- Next State
-----------------------------------------------------------------
modelSignal : Signal.Signal Model
modelSignal = Signal.foldp updateModelCount initialModel actionSignal


main : Signal.Signal Html
main = Signal.map view modelSignal
