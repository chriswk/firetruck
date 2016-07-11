module Helpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


ariaLabel : String -> Html.Attribute a
ariaLabel label =
    attribute "aria-label" label
