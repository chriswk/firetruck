module Components.Incident.Views exposing (..)

import Components.Incident.Models exposing (..)
import Components.Incident.Pagination exposing (paginate)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List exposing (map)
import Date.Format exposing (formatISO8601)
import String exposing (indices)


incidentRow : Incident -> Html Msg
incidentRow incident =
    let
        incidentUrl =
            incident.links.self.href

        slashSep =
            String.split "/" incidentUrl

        maybeId =
            List.head (List.reverse slashSep)

        id =
            case maybeId of
                Nothing ->
                    ""

                Just i ->
                    toString i

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
            [ td [] [ div [ onClick (FetchIncident incidentUrl) ] [ text id ] ]
            , td [] [ text checkName ]
            , td [] [ text lastExecution ]
            , td [] [ text finnApp ]
            , td [] [ text finnEnv ]
            , td [] [ div [ onClick (FetchIncident incidentUrl) ] [ text "View" ] ]
            ]


incidentsPageView : Model -> Html Msg
incidentsPageView model =
    case model.incidentsPage of
        Nothing ->
            text ""

        Just page ->
            listView page


listView : IncidentsPage -> Html Msg
listView page =
    let
        pagination =
            paginate page.pagination

        overView =
            incidentsTable page.incidents
    in
        div []
            [ pagination
            , overView
            , pagination
            ]


tableStyle : Html.Attribute a
tableStyle =
    class "outerborder zebra-striped hover-rows"


incidentsTable : IncidentsList -> Html Msg
incidentsTable list =
    let
        incidentRows =
            List.map incidentRow list.incidents
    in
        table [ tableStyle ]
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


incidentView : Model -> Html Msg
incidentView model =
    let
        incView =
            case model.currentIncident of
                Nothing ->
                    text ""

                Just incident ->
                    incidentTable incident
    in
        incView


topbarImage : Html.Attribute a
topbarImage =
    src "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjcuNDExIiBoZWlnaHQ9IjE2OS4zOTgiIHZpZXdCb3g9IjAgMCA1MjcuNDExIDE2OS4zOTgiPjxwYXRoIGZpbGw9IiNmZmYiIGQ9Ik00NjguNTA3IDBoLTI1Ni4xODdjLTIxLjcwNyAwLTQwLjY5NSAxMS44MTItNTAuOTEyIDI5LjMzNy0xMC4yMTYtMTcuNTI1LTI5LjIwNC0yOS4zMzctNTAuOTExLTI5LjMzN2gtNTEuNTk1Yy0zMi40NzkgMC01OC45MDIgMjYuNDI1LTU4LjkwMiA1OC45MDV2NTEuNTg3YzAgMzIuNDgxIDI2LjQyMyA1OC45MDYgNTguOTAyIDU4LjkwNmg0MDkuNjA1YzMyLjQ3OSAwIDU4LjkwMy0yNi40MjUgNTguOTAzLTU4LjkwNnYtNTEuNTg3Yy4wMDEtMzIuNDgtMjYuNDIzLTU4LjkwNS01OC45MDMtNTguOTA1eiIvPjxwYXRoIGZpbGw9IiMwOWYiIGQ9Ik00NjguNTA3IDE1My4zODNjMjMuNjg3IDAgNDIuODg4LTE5LjE5OSA0Mi44ODgtNDIuODl2LTUxLjU4OGMwLTIzLjY5MS0xOS4yMDEtNDIuODktNDIuODg4LTQyLjg5aC0yNTYuMTg3Yy0yMy42ODYgMC00Mi44ODcgMTkuMTk4LTQyLjg4NyA0Mi44OXY5NC40NzhoMjk5LjA3NHoiLz48cGF0aCBmaWxsPSIjMDA2IiBkPSJNMTUzLjM4NCAxNTMuMzgzdi05NC40NzhjMC0yMy42OTEtMTkuMjAxLTQyLjg5LTQyLjg4Ny00Mi44OWgtNTEuNTk1Yy0yMy42ODYgMC00Mi44ODcgMTkuMTk4LTQyLjg4NyA0Mi44OXY1MS41ODdjMCAyMy42OTEgMTkuMjAxIDQyLjg5IDQyLjg4NyA0Mi44OWg5NC40ODJ6Ii8%2BPHJlY3QgeD0iMzIwLjE1NiIgeT0iNzUuMjc1IiBmaWxsPSIjZmZmIiB3aWR0aD0iMTkuNjIxIiBoZWlnaHQ9IjUzLjIxMSIvPjxwYXRoIGZpbGw9IiNmZmYiIGQ9Ik0yNjIuOTEyIDg2LjI4MWMwLTUuNTI5IDMuODEzLTExLjAwNiAxMy4wNjktMTEuMDA2aDI4LjQyMXYxNS42MTNoLTE4LjYxMmMtMi40OTggMC0zLjI1NS45OTItMy4yNTUgMi42NjR2Ny40NzJoMjEuODY3djE1LjYxaC0yMS44Njd2MTEuODUyaC0xOS42MjN2LTQyLjIwNXpNMzc1LjE2NSA5MS4wOTloMTAuMzk5YzIuNDA5IDAgMy4yNDYuODMyIDMuMjQ2IDMuMjM1bC0uMDA4IDM0LjE1MmgxOS42MzJ2LTQxLjk5NmMwLTUuNTI3LTMuODE1LTExLjAwNC0xMy4wNjktMTEuMDA0aC0zOS44MjRsLS4wMSA1M2gxOS42MzR2LTM3LjM4N3pNNDQyLjcxOSA5MS4wOTloMTAuNGMyLjQwOCAwIDMuMjQ1LjgzMiAzLjI0NSAzLjIzNWwtLjAwOSAzNC4xNTJoMTkuNjM0di00MS45OTZjMC01LjUyNy0zLjgxNS0xMS4wMDQtMTMuMDctMTEuMDA0aC0zOS44MjNsLS4wMSA1M2gxOS42MzN2LTM3LjM4N3oiLz48L3N2Zz4%3D"


homeLink : Html Msg
homeLink =
    a [ href "#", onClick DisplayIncidentList ]
        [ span [ class "topbar-nav-svg-home" ]
            [ img [ topbarImage, alt "FINN", width 106, height 34 ] []
            ]
        , span [ class "topbar-nav-svg-caption caption showbydefault hide-lt900" ] [ text "Finn Firetruck" ]
        ]


navBarLinkClasses : String
navBarLinkClasses =
    "nav-element flex align-items-center centerify openlevel2"


navBarSpanClasses : String
navBarSpanClasses =
    "topbar-nav-svg-caption caption showbydefault"


incidentLink : Html Msg
incidentLink =
    a [ class navBarLinkClasses, href "#", onClick DisplayIncidentList ]
        [ span [ class navBarSpanClasses ] [ text "Incidents" ] ]


menuBar : Model -> Html Msg
menuBar model =
    div [ class "page" ]
        [ div [ class "topbar fixed nav-down" ]
            [ div [ class "container" ]
                [ div [ class "page" ]
                    [ div [ class "nav-level1 h4" ]
                        [ homeLink
                        , incidentLink
                        ]
                    ]
                ]
            ]
        ]


finnFooter : Model -> Html Msg
finnFooter model =
    div [] []


pageWrapper : Model -> Html Msg
pageWrapper model =
    div [ class "container", style [ ( "margin-top", "80px" ) ] ]
        [ incidentsPageView model
        , incidentView model
        ]


errorPrinter : Model -> Html Msg
errorPrinter model =
    case model.lastError of
        Nothing ->
            text ""

        Just err ->
            text (toString err)


view : Model -> Html Msg
view model =
    div []
        [ menuBar model
        , pageWrapper model
        , errorPrinter model
        , finnFooter model
        ]
