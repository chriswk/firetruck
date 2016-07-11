module Components.Incident.List exposing (..)

import Http exposing (Error)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Task exposing (Task)
import Components.Incident.Models exposing (Incident, IncidentLinks, IncidentCollection, Sort, Column, Direction(..))
import Components.Incident.Tasks exposing (fetchIncidents)
import Styles exposing (tableStyle)


type alias IncidentId =
    Int


type Msg
    = NoOp
    | IncidentsFetchFail Http.Error
    | IncidentsFetchSucceed IncidentCollection
    | FetchIncidents
    | SortTable Sort


type alias Model =
    { incidents : List Incident
    , currentSort : Sort
    }


init : ( Model, Cmd Msg )
init =
    let
        currentSort =
            Sort "id" Desc
    in
        { incidents = [], currentSort = currentSort } ! [ (getIncidents currentSort) ]


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            model ! []

        IncidentsFetchFail a ->
            model ! []

        IncidentsFetchSucceed incidentCollection ->
            let
                incidentList =
                    incidentCollection.incidents
            in
                { model | incidents = incidentList } ! []

        SortTable sort ->
            { model | currentSort = sort } ! [ getIncidents sort ]

        FetchIncidents ->
            model ! [ getIncidents model.currentSort ]


view : Model -> Html Msg
view model =
    let
        incidents =
            List.map incidentRow model.incidents

        sortMsg =
            \colName -> SortTable (decideSort model.currentSort colName)
    in
        table [ tableStyle ]
            [ thead []
                [ tr []
                    [ th [ onClick (sortMsg "id") ] [ text "Id" ]
                    , th [ onClick (sortMsg "checkName") ] [ text "Checkname" ]
                    , th [ onClick (sortMsg "finnApp") ] [ text "Finn app" ]
                    , th [ onClick (sortMsg "finnEnv") ] [ text "Finn env" ]
                    ]
                ]
            , tbody [] incidents
            ]


decideSort : Sort -> Column -> Sort
decideSort sort column =
    let
        isCurrent =
            Debug.log "switching to" column == Debug.log "from column" sort.column

        direction' =
            if isCurrent then
                case sort.direction of
                    Asc ->
                        Desc

                    Desc ->
                        Asc
            else
                Desc
    in
        Sort column direction'


incidentRow : Incident -> Html Msg
incidentRow incident =
    let
        id =
            incident.links.self.href

        checkName =
            incident.checkName

        finnApp =
            incident.finnApp

        finnEnv =
            incident.finnEnv
    in
        tr []
            [ td [] [ text id ]
            , td [] [ text checkName ]
            , td [] [ text finnApp ]
            , td [] [ text finnEnv ]
            ]


type alias IncidentList =
    { incidents : List Incident
    }


getIncidents : Sort -> Cmd Msg
getIncidents sort =
    Task.perform IncidentsFetchFail IncidentsFetchSucceed (fetchIncidents sort)
