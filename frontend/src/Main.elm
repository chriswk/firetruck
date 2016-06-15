module Main exposing (..)

import Html.App as Html
import Components.Incident.Tasks exposing (fetchMostRecentIncidents, fetchIncident)
import Components.Incident.Models exposing (Model, Msg(..), Incident)
import Components.Incident.Views exposing (incidentTable)
import Html exposing (..)
import Html.Attributes exposing (..)


initialModel : Model
initialModel =
    { sort = Nothing
    , incidents = []
    , lastError = Nothing
    , currentIncident = Nothing
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

        IncidentsFetchSucceed apiResponse ->
            ( { model | incidents = apiResponse.incidents.incidents }, Cmd.none )

        IncidentsFetchFail a ->
            ( { model | lastError = Just a }, Cmd.none )
        IncidentFetchFail e ->
            ( { model | lastError = Just e }, Cmd.none )
        IncidentFetchSucceed inc ->
            ( { model | currentIncident = Just inc }, Cmd.none )
        FetchIncident url ->
            ( model, (fetchIncident url) )



view : Model -> Html Msg
view model =
    div []
        [ incidentTable model.incidents ]


main : Program Never
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
