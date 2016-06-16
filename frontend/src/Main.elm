module Main exposing (..)

import Html.App as Html
import Components.Incident.Tasks exposing (fetchMostRecentIncidents, fetchIncident, fetchIncidents)
import Components.Incident.Models exposing (Model, Msg(..), Incident)
import Components.Incident.Views exposing (view)


initialModel : Model
initialModel =
    { sort = Nothing
    , incidentsPage = Nothing
    , lastError = Nothing
    , currentIncident = Nothing
    , pageSize = 20
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchIncidents "0" )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        IncidentsFetchSucceed incidentsPage ->
            ( { model | incidentsPage = Just incidentsPage, currentIncident = Nothing }, Cmd.none )

        IncidentsFetchFail a ->
            ( { model | lastError = Just a }, Cmd.none )

        IncidentFetchFail e ->
            ( { model | lastError = Just e }, Cmd.none )

        IncidentFetchSucceed inc ->
            ( { model | currentIncident = Just inc, incidentsPage = Nothing }, Cmd.none )

        FetchIncident url ->
            ( model, (fetchIncident url) )

        DisplayIncidentList ->
            ( model, fetchMostRecentIncidents )

        IncidentPage pageNo ->
            ( model, fetchIncidents (toString pageNo) )


main : Program Never
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
