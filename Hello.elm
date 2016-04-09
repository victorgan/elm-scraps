module Main (..) where

import Html exposing (Html)
import Html.Events as Events
import Keyboard
import Mouse



type alias Model = { count : Int }

-- state
initialModel : Model
initialModel = { count = 0 }


type Action = NoOp | Increase


-----------------------------------------------------------------
-- View displays model and hooks div elements to actions
-----------------------------------------------------------------
view : Signal.Address Action -> Model -> Html
view address model =
  Html.div []
    [ Html.div [] [ Html.text (toString model.count) ]
    , Html.button [ Events.onClick address Increase ] [ Html.text "Click" ]
    ]

-----------------------------------------------------------------
-- Logic to update model. Controller to centralize changes.
-----------------------------------------------------------------
updateModelCount : Action -> Model -> Model
updateModelCount action model = case action of
    NoOp -> model
    Increase -> { model | count = model.count + 1 }

-----------------------------------------------------------------
-- Actions to handle different user actions
-----------------------------------------------------------------
--actionSignal : Signal.Signal Action
--actionSignal = Signal.merge mouseClickSignal keyPressSignal

mb : Signal.Mailbox Action
mb = Signal.mailbox NoOp


-----------------------------------------------------------------
-- Next State
-----------------------------------------------------------------
modelSignal : Signal.Signal Model
modelSignal = Signal.foldp updateModelCount initialModel mb.signal

main : Signal.Signal Html
main = Signal.map (view mb.address) modelSignal
