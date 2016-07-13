module Route exposing (..)

import Html exposing (..)
import Navigation
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onWithOptions)
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery, addQuery, clearQuery, matcherToPath)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)
import Hop.Matchers exposing (match1, match2, int)
import Json.Decode as Json
import Json.Decode.Extra exposing (lazy)


type Route
    = HomeRoute
    | IncidentsRoute
    | IncidentRoute Int
    | NotFoundRoute


notFound : Html msg
notFound =
    div [] [ text "Could not find that page" ]


matcherHome : PathMatcher Route
matcherHome =
    match1 HomeRoute "/"


matcherIncidents : PathMatcher Route
matcherIncidents =
    match1 IncidentsRoute "/incidents"


matcherIncident : PathMatcher Route
matcherIncident =
    match2 IncidentRoute "/incidents/" int


matchers : List (PathMatcher Route)
matchers =
    [ matcherHome
    , matcherIncidents
    , matcherIncident
    ]


routerConfig : Config Route
routerConfig =
    { hash = True
    , basePath = ""
    , matchers = matchers
    , notFound = NotFoundRoute
    }


reverse : Route -> String
reverse route =
    let
        route' =
            case route of
                HomeRoute ->
                    matcherToPath matcherHome []

                IncidentsRoute ->
                    matcherToPath matcherIncidents []

                IncidentRoute id ->
                    matcherToPath matcherIncident [ (toString id) ]

                NotFoundRoute ->
                    ""
    in
        route'


catchNavigationClicks : (String -> msg) -> Attribute msg
catchNavigationClicks tagger =
    onWithOptions "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.map tagger (Json.at [ "target" ] pathDecoder))


pathDecoder : Json.Decoder String
pathDecoder =
    Json.oneOf
        [ Json.at [ "data-navigate" ] Json.string
        , Json.at [ "parentElement" ] (lazy (\_ -> pathDecoder))
        , Json.fail "no path found for click"
        ]


urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl routerConfig)


linkTo : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
linkTo route attrs content =
    Debug.log "Link built: " (a ((linkAttrs route) ++ attrs) content)


linkAttrs : Route -> List (Attribute msg)
linkAttrs route =
    let
        path =
            "#" ++ (reverse route)
    in
        [ href path
        , attribute "data-navigate" path
        ]
