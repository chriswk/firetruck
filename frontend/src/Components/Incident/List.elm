module Components.Incident.List exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Task exposing (Task)
import Components.Incident.Models exposing (..)
import Components.Incident.Tasks exposing (fetchIncidents)
import Components.Incident.Pagination exposing (..)
import Styles exposing (tableStyle)


type alias IncidentId =
    Int


type alias Model =
    { incidents : List Incident
    , currentSort : Sort
    , pagination : Pagination
    }


init : ( Model, Cmd IncidentListMsg )
init =
    let
        currentSort =
            Sort "id" Desc

        pagination =
            Pagination 0 20 -1 -1
    in
        { incidents = [], currentSort = currentSort, pagination = pagination } ! [ (getIncidents pagination currentSort) ]


update : IncidentListMsg -> Model -> ( Model, Cmd IncidentListMsg )
update action model =
    case action of
        IncidentsFetchFail a ->
            model ! []

        IncidentsFetchSucceed incidentCollection ->
            let
                incidentList =
                    incidentCollection.incidents

                pagination =
                    incidentCollection.pagination
            in
                { model | incidents = incidentList, pagination = pagination } ! []

        SortTable sort ->
            { model | currentSort = sort } ! [ getIncidents model.pagination sort ]

        FetchIncidents ->
            model ! [ getIncidents model.pagination model.currentSort ]

        SwitchPage page ->
            let
                oldPagination =
                    model.pagination

                newPagination =
                    { oldPagination | currentPage = page }

                updateIncidentList =
                    getIncidents newPagination model.currentSort
            in
                { model | pagination = newPagination } ! [ updateIncidentList ]


view : Model -> Html IncidentListMsg
view model =
    let
        incidents =
            List.map incidentRow model.incidents

        sortMsg =
            \colName -> SortTable (decideSort model.currentSort colName)

        pagination =
            paginate model.pagination

        incidentList =
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
    in
        div []
            [ pagination
            , incidentList
            , pagination
            ]


decideSort : Sort -> Column -> Sort
decideSort sort column =
    let
        isCurrent =
            column == sort.column

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


incidentRow : Incident -> Html IncidentListMsg
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


getIncidents : Pagination -> Sort -> Cmd IncidentListMsg
getIncidents pagination sort =
    Task.perform IncidentsFetchFail IncidentsFetchSucceed (fetchIncidents pagination sort)
