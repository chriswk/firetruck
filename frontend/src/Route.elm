module Route exposing (..)

import Html exposing (..)
import Navigation
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Images exposing (topbarImage)
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery, matcherToPath)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)
import Hop.Matchers exposing (match1, match2, int)


type Route
    = HomeRoute
    | IncidentsRoute
    | IncidentRoute Int
    | NotFoundRoute


type Msg
    = NavigateTo String
    | SetQuery Query


type alias Model =
    { location : Location
    , route : Route
    }


init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location ) =
    Model location route ! []


navItem : Model -> Route -> String -> Html Msg
navItem model page caption =
    let
        active =
            model.route == page

        url =
            reverse page

        linkAction =
            NavigateTo url
    in
        li
            [ classList
                [ ( "nav-item", True )
                , ( "active", active )
                ]
            ]
            [ a
                [ class "nav-link"
                , onClick linkAction
                ]
                [ text caption ]
            ]


notFound : Html msg
notFound =
    div [] [ text "Could not find that page" ]


navigationView : Model -> Html Msg
navigationView route =
    let
        link =
            \page caption -> navItem route page caption
    in
        div [ class "page" ]
            [ div [ class "topbar fixed nav-down" ]
                [ div [ class "container" ]
                    [ div [ class "page" ]
                        [ div [ class "nav-level1 h4" ]
                            [ homeLink
                            , link IncidentsRoute "Incidents"
                            ]
                        ]
                    ]
                ]
            ]


homeLink : Html Msg
homeLink =
    a
        [ onClick (NavigateTo (reverse HomeRoute))
        ]
        [ span [ class "topbar-nav-svg-home" ]
            [ img [ topbarImage, alt "FINN", width 106, height 34 ] []
            ]
        , span [ class "topbar-nav-svg-caption caption showbydefault hide-lt900" ] [ text "FINN Firetruck" ]
        ]


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "msg" msg) of
        NavigateTo path ->
            let
                command =
                    makeUrl routerConfig path
                        |> Navigation.newUrl
            in
                ( model, Debug.log "command: " command )

        SetQuery query ->
            let
                command =
                    model.location
                        |> setQuery query
                        |> makeUrlFromLocation routerConfig
                        |> Navigation.newUrl
            in
                ( model, command )


reverse : Route -> String
reverse route =
    let
        route' =
            case route of
                HomeRoute ->
                    matcherToPath matcherHome []

                IncidentRoute id ->
                    matcherToPath matcherIncident [ toString id ]

                IncidentsRoute ->
                    matcherToPath matcherIncidents []

                NotFoundRoute ->
                    ""
    in
        route'


urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl routerConfig)
