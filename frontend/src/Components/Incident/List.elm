module Components.Incident.List exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Task exposing (Task)
import Components.Incident.Models exposing (..)
import Components.Incident.Tasks exposing (fetchIncidents)
import Components.Incident.Pagination exposing (..)
import Styles exposing (tableStyle)
import String exposing (split, toInt)
import Route


type alias IncidentId =
    Int


type alias Model =
    { incidents : List Incident
    , currentSort : Sort
    , pagination : Pagination
    }


init : ( Model, Cmd Msg )
init =
    let
        currentSort =
            Sort "id" Desc

        pagination =
            Pagination 0 20 -1 -1
    in
        { incidents = [], currentSort = currentSort, pagination = pagination } ! [ (getIncidents pagination currentSort) ]


mountCmd : Model -> Cmd Msg
mountCmd model =
    getIncidents model.pagination model.currentSort


update : Msg -> Model -> ( Model, Cmd Msg )
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


tableHeader : Model -> Html Msg
tableHeader model =
    let
        sortMsg =
            \colName -> SortTable (decideSort model.currentSort colName)
    in
        thead []
            [ tr []
                [ th [ onClick (sortMsg "id") ] [ text "Id" ]
                , th [ onClick (sortMsg "checkName") ] [ text "Checkname" ]
                , th [ onClick (sortMsg "finnApp") ] [ text "Finn app" ]
                , th [ onClick (sortMsg "finnEnv") ] [ text "Finn env" ]
                , th [] [ text "Comments" ]
                ]
            ]


findId : String -> Int
findId id =
    let
        parts =
            String.split "/" id

        lastPart =
            List.head (List.reverse parts)

        idInt =
            String.toInt <|
                case lastPart of
                    Nothing ->
                        "-1"

                    Just idStr ->
                        idStr
    in
        Result.withDefault -1 idInt


incidentRow : Incident -> Html Msg
incidentRow incident =
    let
        id =
            incident.links.self.href

        idInt =
            findId id

        checkName =
            incident.checkName

        finnApp =
            incident.finnApp

        finnEnv =
            incident.finnEnv

        link =
            Route.linkTo (Route.IncidentRoute idInt)
    in
        tr []
            [ td []
                [ link []
                    [ text id ]
                ]
            , td [] [ text checkName ]
            , td [] [ text finnApp ]
            , td [] [ text finnEnv ]
            ]


view : Model -> Html Msg
view model =
    let
        incidents =
            List.map incidentRow model.incidents

        pagination =
            paginate model.pagination

        tableBody =
            tbody [] incidents

        incidentList =
            table [ tableStyle ]
                [ (tableHeader model)
                , tableBody
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


type alias IncidentList =
    { incidents : List Incident
    }


getIncidents : Pagination -> Sort -> Cmd Msg
getIncidents pagination sort =
    Task.perform IncidentsFetchFail IncidentsFetchSucceed (fetchIncidents pagination sort)
