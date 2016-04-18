module Main (..) where

import String
import Html exposing (Html)
import Html.Events as Events
import StartApp.Simple


-------------------------------------------------------------------------------
-- Model: Data structure and initial state
-------------------------------------------------------------------------------
type alias InterestRate = Float
type alias Percentage = Float
type alias Money = Float
type alias Time = Float
type alias MoneyPerTime = Float

type alias Model =
  { savingsPerYear : MoneyPerTime
  , interest : InterestRate
  , inflation : InterestRate
  , yearsSaved : Time
  }

initialModel : Model
initialModel =
  { savingsPerYear = 0
  , interest = 0.06
  , inflation = 0.02
  , yearsSaved = 12
  }

type Action = NoOp | Increase

-------------------------------------------------------------------------------
-- View: Only transform to view. Do no calculation
-------------------------------------------------------------------------------
view : Signal.Address Action -> Model -> Html
view address model =
  Html.div
    []
    [ htmlDivText (String.concat ["If I save $", toString model.savingsPerYear, " per year, or $", toString (model.savingsPerYear / 12), " per month, or $", toString (model.savingsPerYear / 52), " per week" ])
    , Html.button [ Events.onClick address Increase ] [ Html.text "Click" ]
    , htmlDivText (String.concat ["I will save $", toString (model.savingsPerYear * model.yearsSaved), " in ", toString model.yearsSaved," years in pricinpal"])
    , htmlDivText (String.concat ["Based on ", (toPercent >> toString) model.interest,"% interest and ", (toPercent >> toString) model.inflation,"% inflation"])
    , htmlDivText (String.concat ["I will gain $", (toPercent >> toString) model.interest,"% interest and ", (toPercent >> toString) model.inflation,"% inflation"])
    ]


-- HTML functions
htmlDivText : String -> Html
htmlDivText text = Html.div [] [Html.text text]

-- Pure Functions : do not reference state
monthToYear : Time -> Time
monthToYear month = month / 12

monthToDecade : Time -> Time
monthToDecade month = (monthToYear month) / 10

toPercent : InterestRate -> Float
toPercent = (*) 100

futureValueMultiplier : Time -> InterestRate -> Float
futureValueMultiplier time interest = (1 + interest)^time

effectiveInterestRate : InterestRate -> InterestRate -> InterestRate
effectiveInterestRate interest inflation = interest - inflation

-------------------------------------------------------------------------------
-- Update: Functions
-------------------------------------------------------------------------------
update : Action -> Model -> Model
update action = case action of
    Increase -> increaseSavings 500
    _        -> identity

increaseSavings : Float -> Model -> Model
increaseSavings yearSavings model = 
    { model 
    | savingsPerYear = model.savingsPerYear + yearSavings
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
