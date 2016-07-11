module Route exposing (..)

import String exposing (split)
import Navigation
import Html exposing (..)
import Html.Attributes exposing (..)
import Images exposing (topbarImage)


type alias Model =
    Maybe Location


type Location
    = Home
    | Incidents


init : Maybe Location -> Model
init location =
    location


urlFor : Location -> String
urlFor location =
    let
        url =
            case location of
                Home ->
                    "/"

                Incidents ->
                    "/incidents"
    in
        "#" ++ url


locFor : Navigation.Location -> Maybe Location
locFor path =
    let
        segments =
            path.hash
                |> split "/"
                |> List.filter (\seg -> seg /= "" && seg /= "#")
    in
        case segments of
            [] ->
                Just Home

            [ "incidents" ] ->
                Just Incidents

            _ ->
                Nothing


navItem : Model -> Location -> String -> Html msg
navItem model page caption =
    let
        active =
            case model of
                Nothing ->
                    False

                Just current ->
                    current == page
    in
        li
            [ classList
                [ ( "nav-item", True )
                , ( "active", active )
                ]
            ]
            [ a
                [ class "nav-link"
                , href (urlFor page)
                ]
                [ text caption ]
            ]


notFound : Html msg
notFound =
    div [] [ text "Could not find that page" ]


navigationView : Model -> Html msg
navigationView route =
    let
        link =
            \page caption -> navItem route page caption
    in
        div [ class "page" ]
            [ div [ class "topbar fixed nav-down" ]
                [ div [ class "container" ]
                    [ div [ class "page" ]
                        [ div [ class "nav-level1 h4" ]
                            [ homeLink
                            , link Incidents "Incidents"
                            ]
                        ]
                    ]
                ]
            ]


homeLink : Html msg
homeLink =
    a
        [ href (urlFor Home)
        ]
        [ span [ class "topbar-nav-svg-home" ]
            [ img [ topbarImage, alt "FINN", width 106, height 34 ] []
            ]
        , span [ class "topbar-nav-svg-caption caption showbydefault hide-lt900" ] [ text "FINN Firetruck" ]
        ]
