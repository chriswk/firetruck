module Components.Incident.Detail exposing (..)

import Components.Incident.Models exposing (Incident, IncidentId)
import Components.Incident.Tasks exposing (fetchIncident)
import Html exposing (..)
import Http exposing (Error)
import Styles exposing (tableStyle)
import Task exposing (perform)


type Msg
    = IncidentFetchFail Http.Error
    | IncidentFetchSucceed Incident
    | FetchIncident Int


type alias Model =
    { incident : Maybe Incident
    }


view : Model -> Html Msg
view model =
    case model.incident of
        Nothing ->
            text ""

        Just incident ->
            incidentTable incident


incidentTable : Incident -> Html Msg
incidentTable incident =
    table [ tableStyle ]
        [ thead [] []
        , tbody []
            [ tr []
                [ td [] [ text "Environment" ]
                , td [] [ text incident.finnEnv ]
                ]
            , tr []
                [ td [] [ text "App" ]
                , td [] [ text incident.finnApp ]
                ]
            , tr []
                [ td [] [ text "Command run" ]
                , td [] [ text incident.command ]
                ]
            ]
        ]


init : ( Model, Cmd Msg )
init =
    { incident = Nothing } ! []


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        IncidentFetchFail e ->
            model ! []

        IncidentFetchSucceed incident ->
            { model | incident = Just incident } ! []

        FetchIncident id ->
            model ! [ (getIncident id) ]


getIncident : Int -> Cmd Msg
getIncident id =
    Task.perform IncidentFetchFail IncidentFetchSucceed (fetchIncident id)
