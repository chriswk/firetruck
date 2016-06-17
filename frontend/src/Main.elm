module Main exposing (..)

import Html.App as Html
import Components.Incident.Tasks exposing (fetchIncident, fetchIncidents, fetchMostRecentIncidents)
import Components.Incident.Models exposing (Model, Msg(..), Incident)
import Components.Incident.Views exposing (view)


initialModel : Model
initialModel =
    { incidentsPage = Nothing
    , lastError = Nothing
    , currentIncident = Nothing
    , pageSize = 20
    , sort = Nothing
    , currentPage = 0
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchMostRecentIncidents )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        IncidentFetchFail e ->
            ( { model | lastError = Just e }, Cmd.none )

        IncidentFetchSucceed inc ->
            ( { model | currentIncident = Just inc, incidentsPage = Nothing }, Cmd.none )

        FetchIncident url ->
            ( model, (fetchIncident url) )

        IncidentsFetchSucceed incidentsPage ->
            ( { model | incidentsPage = Just incidentsPage, currentIncident = Nothing }, Cmd.none )

        IncidentsFetchFail err ->
            ( { model | lastError = Just err }, Cmd.none )

        UpdatePageSize size ->
            let
                updatedModel =
                    { model | pageSize = size }
            in
                ( updatedModel, (fetchIncidents updatedModel) )

        UpdatePage pageNo ->
            let
                updatedModel =
                    { model | currentPage = pageNo }
            in
                ( updatedModel, (fetchIncidents updatedModel) )

        UpdateSort sort ->
            let
                updatedModel =
                    { model | sort = Just sort }
            in
                ( updatedModel, (fetchIncidents updatedModel) )

        DisplayIncidentList ->
            ( model, (fetchIncidents model) )


main : Program Never
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
