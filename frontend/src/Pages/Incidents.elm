module Pages.Incidents exposing (..)

import Http exposing (Error)
import Html exposing (..)
import Html.Attributes exposing (..)
import Date exposing (Date)
import Json.Decode.Extra exposing ((|:), date)
import Json.Decode exposing (Decoder, decodeValue, succeed, string, (:=), float, at, list, int)
import Task exposing (Task)
import Debug exposing (log)


type alias IncidentId =
    Int


type Msg
    = NoOp
    | IncidentsFetchFail Http.Error
    | IncidentsFetchSucceed IncidentList
    | SortingMsg Msg
    | PaginationMsg Msg


type alias Incident =
    { checkName : String
    , client : String
    , dc : String
    , command : String
    , duration : Float
    , executed : Date
    , finnApp : String
    , finnEnv : String
    , out : String
    }


type alias Model =
    { incidents : List Incident
    }


tableStyle : Html.Attribute a
tableStyle =
    class "outerborder zebra-striped hover-rows"


init : ( Model, Cmd Msg )
init =
    { incidents = [] } ! [ getIncidents ]


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            model ! []

        IncidentsFetchFail a ->
            model ! []

        IncidentsFetchSucceed incidents ->
            let
                incidentList =
                    Debug.log "Incidents:" incidents.incidents
            in
                { model | incidents = incidents.incidents } ! []

        SortingMsg msg ->
            model ! []

        PaginationMsg msg ->
            model ! []


view : Model -> Html Msg
view model =
    let
        incidents =
            List.map incidentRow model.incidents
    in
        table [ tableStyle ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Checkname" ]
                    , th [] [ text "Finn app" ]
                    , th [] [ text "Finn env" ]
                    ]
                ]
            , tbody [] incidents
            ]


incidentRow : Incident -> Html Msg
incidentRow incident =
    let
        checkName =
            incident.checkName
    in
        tr []
            [ td [] [ text checkName ]
            ]


incidentBaseUrl : String
incidentBaseUrl =
    "/api/incidents"


type alias IncidentList =
    { incidents : List Incident
    }


incidentDecoder : Decoder Incident
incidentDecoder =
    succeed Incident
        |: ("checkName" := string)
        |: ("client" := string)
        |: ("dc" := string)
        |: ("command" := string)
        |: ("duration" := float)
        |: ("executed" := date)
        |: ("finnApp" := string)
        |: ("finnEnv" := string)
        |: ("output" := string)


incidentListDecoder : Decoder IncidentList
incidentListDecoder =
    succeed IncidentList
        |: at [ "_embedded", "incidents" ] (Json.Decode.list incidentDecoder)


fetchIncidents : Task Error IncidentList
fetchIncidents =
    Http.get incidentListDecoder incidentBaseUrl


getIncidents : Cmd Msg
getIncidents =
    Task.perform IncidentsFetchFail IncidentsFetchSucceed fetchIncidents
