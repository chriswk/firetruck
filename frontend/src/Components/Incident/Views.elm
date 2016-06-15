module Components.Incident.Views exposing (..)

import Components.Incident.Models exposing (Incident, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (map)
import Date.Format exposing (formatISO8601)
import String exposing (indices)

incidentRow : Incident -> Html Msg
incidentRow incident =
    let
        incidentUrl
           = incident.links.self.href

        urlLength = String.length incidentUrl

        slashIndices
            = String.indices "/" incidentUrl

        lastIndexOf
            = List.head (List.reverse slashIndices)

        idIndex = case lastIndexOf of
            Nothing -> urlLength
            Just id -> id + 1

        id = String.slice idIndex urlLength incidentUrl


        checkName =
            toString incident.name

        lastExecution =
            formatISO8601 incident.lastExecution

        finnApp =
            toString incident.finnApp

        finnEnv =
            toString incident.finnEnv
    in
        tr []
            [ td [ ] [ div [ onClick (FetchIncident incidentUrl) ] [ text id ] ]
            , td [] [ text checkName ]
            , td [] [ text lastExecution ]
            , td [] [ text finnApp ]
            , td [] [ text finnEnv ]
            , td [] [ text "View" ]
            ]


incidentTable : List Incident -> Html Msg
incidentTable incidents =
    let
        incidentRows =
            List.map incidentRow incidents
    in
        table [ class "outerborder zebra-striped hover-rows" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Checkname" ]
                    , th [] [ text "Last executed" ]
                    , th [] [ text "Finn app" ]
                    , th [] [ text "Finn env" ]
                    , th [] []
                    ]
                ]
            , tbody [] incidentRows
            ]
