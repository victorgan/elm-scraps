module Main (..) where

import String
import Html exposing (Html)
import Html.Events as Events
import StartApp.Simple


-------------------------------------------------------------------------------
-- Model: Data structure and initial state
-------------------------------------------------------------------------------
type alias Model =
  { savingsPerMonth : Float
  , savingsPerYear : Float
  , savingsPerDecade : Float
  }

initialModel : Model
initialModel =
  { savingsPerMonth = 0
  , savingsPerYear = 0
  , savingsPerDecade = 0
  }

type Action = NoOp | Increase

-------------------------------------------------------------------------------
-- View: Only transform to view. Do no calculation
-------------------------------------------------------------------------------
view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    [ htmlDivText (String.concat ["If I save $", toString model.savingsPerMonth, " per month"])
    , htmlDivText (String.concat ["I will save $", toString model.savingsPerYear, " in a year and $", toString model.savingsPerDecade, " in a decade"])
    , htmlDivText "Based on X% interest and X% inflation I will have an additional $Y due to savings"
    , Html.button [ Events.onClick address Increase ] [ Html.text "Click" ]
    ]

htmlDivText : String -> Html
htmlDivText text = Html.div [] [Html.text text]

-------------------------------------------------------------------------------
-- Update: Functions
-------------------------------------------------------------------------------
update : Action -> Model -> Model
update action = case action of
    Increase -> increaseSavings 1000
    _        -> identity

increaseSavings : Float -> Model -> Model
increaseSavings monthSavings model = 
    { model 
    | savingsPerMonth = model.savingsPerMonth + monthSavings
    , savingsPerYear = model.savingsPerYear + monthSavings*12
    , savingsPerDecade = model.savingsPerDecade + monthSavings*12*10
    }

-------------------------------------------------------------------------------
-- Main!
-------------------------------------------------------------------------------
main : Signal.Signal Html
main =
  StartApp.Simple.start
    { model = initialModel
    , view = view
    , update = update
    }
