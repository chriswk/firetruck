module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Navigation exposing (program)
import Route exposing (..)
import Hop.Types exposing (Location)
import Components.Incident.List as Incidents
import Components.Incident.Models as IncidentModel
import Components.Incident.View as Incident


type alias Model =
    { route : Route.Model
    , incidents : Incidents.Model
    , incident : Incident.Model
    }


type Msg
    = RouteMsg Route.Msg
    | IncidentsMsg IncidentModel.IncidentListMsg
    | IncidentMsg Incident.Msg


init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init router =
    let
        ( routeModel, routeMsg ) =
            Route.init router

        ( incidents, incidentsMsg ) =
            Incidents.init

        ( incident, incidentMsg ) =
            Incident.init
    in
        { route = routeModel
        , incidents = incidents
        , incident = incident
        }
            ! [ Cmd.map RouteMsg routeMsg
              , Cmd.map IncidentsMsg incidentsMsg
              , Cmd.map IncidentMsg incidentMsg
              ]


view : Model -> Html Msg
view model =
    let
        activePage =
            case model.route.route of
                Route.HomeRoute ->
                    div [] []

                Route.IncidentsRoute ->
                    App.map IncidentsMsg <| Incidents.view model.incidents

                Route.IncidentRoute id ->
                    App.map IncidentMsg <| Incident.view model.incident id

                Route.NotFoundRoute ->
                    Route.notFound

        navigation =
            App.map RouteMsg <| Route.navigationView model.route
    in
        div []
            [ navigation
            , div [ class "container", style [ ( "margin-top", "80px" ) ] ]
                [ activePage ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        IncidentsMsg msg ->
            let
                ( incidents, cmd ) =
                    Incidents.update msg model.incidents
            in
                { model | incidents = incidents } ! [ Cmd.map IncidentsMsg cmd ]

        IncidentMsg msg ->
            let
                ( incident, cmd ) =
                    Incident.update msg model.incident
            in
                { model | incident = incident } ! [ Cmd.map IncidentMsg cmd ]

        RouteMsg msg ->
            let
                ( route, cmd ) =
                    Route.update msg model.route
            in
                { model | route = route } ! [ Cmd.map RouteMsg cmd ]


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
            { model | route = { route = route', location = location' } }
    in
        newModel ! []


main : Program Never
main =
    program (Route.urlParser)
        { init = init
        , subscriptions = subscriptions
        , update = update
        , urlUpdate = urlUpdate
        , view = view
        }
