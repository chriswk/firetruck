module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Html.App as App
import Navigation exposing (program)
import Route exposing (..)
import Components.Incident.List as Incidents
import Components.Incident.Models as IncidentModel
import Components.Incident.Detail as Incident
import Images exposing (topbarImage)
import Hop exposing (makeUrl, makeUrlFromLocation, matchUrl, setQuery, addQuery, clearQuery, matcherToPath)
import Hop.Types exposing (Config, Query, Location, PathMatcher, Router)


type alias Model =
    { location : Location
    , route : Route
    , incidents : Incidents.Model
    , incident : Incident.Model
    }


type Msg
    = NavigateTo String
    | SetQuery Query
    | AddQuery Query
    | ClearQuery
    | IncidentsMsg IncidentModel.Msg
    | IncidentMsg Incident.Msg


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


navigationView : Route -> Location -> Html Msg
navigationView route location =
    let
        incidentListLink =
            navItem IncidentsRoute "Incidents"

        links =
            [ homeLink
            , incidentListLink
            ]
    in
        div [ class "page" ]
            [ div [ class "topbar fixed nav-down" ]
                [ div [ class "container" ]
                    [ div [ class "page" ]
                        [ div [ class "nav-level1 h4" ]
                            links
                        ]
                    ]
                ]
            ]


navItem : Route -> String -> Html Msg
navItem page caption =
    let
        link =
            Route.linkTo page [ class "nav-link" ] [ text caption ]
    in
        li
            [ class "nav-item" ]
            [ link ]


init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location ) =
    let
        ( incidents, incidentsMsg ) =
            Incidents.init

        ( incident, detailMsg ) =
            Incident.init
    in
        { route = route
        , location = location
        , incidents = incidents
        , incident = incident
        }
            ! [ Cmd.map IncidentsMsg incidentsMsg
              , Cmd.map IncidentMsg detailMsg
              ]


view : Model -> Html Msg
view model =
    let
        navigation =
            navigationView model.route model.location

        content =
            contentWrapper model
    in
        div [ Route.catchNavigationClicks NavigateTo ]
            [ navigation
            , content
            ]


contentWrapper : Model -> Html Msg
contentWrapper model =
    let
        content =
            case model.route of
                Route.HomeRoute ->
                    div [] [ text "Super home page" ]

                Route.IncidentsRoute ->
                    App.map IncidentsMsg <| Incidents.view model.incidents

                Route.IncidentRoute id ->
                    App.map IncidentMsg <| Incident.view model.incident

                Route.NotFoundRoute ->
                    Route.notFound
    in
        div [ class "container", style [ ( "margin-top", "80px" ) ] ]
            [ content ]


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        IncidentMsg msg ->
            let
                ( incident, cmd ) =
                    Incident.update msg model.incident
            in
                { model | incident = incident } ! [ Cmd.map IncidentMsg cmd ]

        IncidentsMsg msg ->
            let
                ( incidents, cmd ) =
                    Incidents.update msg model.incidents
            in
                { model | incidents = incidents } ! [ Cmd.map IncidentsMsg cmd ]

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

        AddQuery query ->
            let
                command =
                    model.location
                        |> addQuery query
                        |> makeUrlFromLocation routerConfig
                        |> Navigation.newUrl
            in
                ( model, command )

        ClearQuery ->
            let
                command =
                    model.location
                        |> clearQuery
                        |> makeUrlFromLocation routerConfig
                        |> Navigation.newUrl
            in
                ( model, command )


subscriptions : model -> Sub Msg
subscriptions model =
    Sub.none


urlUpdate : ( Route, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
    let
        route' =
            Debug.log "route" route

        location' =
            Debug.log "location" location

        newModel =
            { model | route = route', location = location' }

        cmd =
            case route of
                HomeRoute ->
                    []

                IncidentsRoute ->
                    [ Cmd.map IncidentsMsg (Incidents.mountCmd newModel.incidents) ]

                IncidentRoute id ->
                    [ Cmd.map IncidentMsg (Incident.getIncident id) ]

                NotFoundRoute ->
                    []
    in
        newModel ! cmd


main : Program Never
main =
    program (Route.urlParser)
        { init = init
        , subscriptions = subscriptions
        , update = update
        , urlUpdate = urlUpdate
        , view = view
        }
