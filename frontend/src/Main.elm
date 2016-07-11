module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Navigation exposing (program)
import Route
import Pages.Incidents as Incidents


type alias Model =
    { route : Route.Model
    , incidents : Incidents.Model
    }


type Msg
    = IncidentsMsg Incidents.Msg


init : Maybe Route.Location -> ( Model, Cmd Msg )
init location =
    let
        route =
            Route.init location

        ( inc, incMsg ) =
            Incidents.init
    in
        { route = route
        , incidents = inc
        }
            ! [ Cmd.map IncidentsMsg incMsg
              ]


view : Model -> Html Msg
view model =
    let
        activePage =
            case model.route of
                Just (Route.Home) ->
                    div [] []

                Just (Route.Incidents) ->
                    App.map IncidentsMsg <| Incidents.view model.incidents

                Nothing ->
                    Route.notFound

        navigation =
            Route.navigationView model.route
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


subscriptions : model -> Sub Msg
subscriptions model =
    Sub.none


updateRoute : Maybe Route.Location -> Model -> ( Model, Cmd Msg )
updateRoute route model =
    { model | route = route } ! []


main : Program Never
main =
    program (Navigation.makeParser Route.locFor)
        { init = init
        , subscriptions = subscriptions
        , update = update
        , urlUpdate = updateRoute
        , view = view
        }
