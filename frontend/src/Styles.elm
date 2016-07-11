module Styles exposing (..)

import Html
import Html.Attributes exposing (..)


tableStyle : Html.Attribute a
tableStyle =
    class "outerborder zebra-striped hover-rows"
