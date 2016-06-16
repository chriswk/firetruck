module Components.Icons exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)


firstPageIcon : Svg a
firstPageIcon =
    svg [ height "1em", viewBox "0 0 18 16", class "valign-middle" ]
        [ switch []
            [ g [ fill "none", stroke "#07E", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round" ]
                [ polyline [ points "8,2 2,8 8,14" ] []
                , polyline [ points "16,2 10,8 16,14" ] []
                ]
            , text "<<"
            ]
        ]


prevPageIcon : Svg a
prevPageIcon =
    svg [ height "1em", viewBox "0 0 10 16", class "valign-middle" ]
        [ switch []
            [ polyline [ points "8,2 2,8 8,14", fill "none", stroke "#07E", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round" ] []
            , text "<"
            ]
        ]


nextPageIcon : Svg a
nextPageIcon =
    svg [ height "1em", viewBox "0 0 10 16", class "valign-middle" ]
        [ switch []
            [ polyline [ points "2,2 8,8 2,14", fill "none", stroke "#07E", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round" ] []
            , text ">"
            ]
        ]


lastPageIcon : Svg a
lastPageIcon =
    svg [ height "1em", viewBox "0 0 18 16", class "valign-middle" ]
        [ switch []
            [ g [ fill "none", stroke "#07E", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round" ]
                [ polyline [ points "2,2 8,8 2,14", fill "none", stroke "#07E", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round" ] []
                , polyline [ points "10,2 16,8 10,14", fill "none", stroke "#07E", strokeWidth "2", strokeLinecap "round", strokeLinejoin "round" ] []
                ]
            , text ">>"
            ]
        ]
