module Components.Incident.Views exposing (..)

import Components.Incident.Models exposing (Incident, Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)
import Date.Format exposing (formatISO8601)


incidentRow : Incident -> Html Msg
incidentRow incident =
    let
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
            [ td [] [ text "Not yet" ]
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
