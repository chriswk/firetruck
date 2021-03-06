module Images exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html.Attributes as H
import Html


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


topbarImage : Html.Attribute a
topbarImage =
    H.src "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjcuNDExIiBoZWlnaHQ9IjE2OS4zOTgiIHZpZXdCb3g9IjAgMCA1MjcuNDExIDE2OS4zOTgiPjxwYXRoIGZpbGw9IiNmZmYiIGQ9Ik00NjguNTA3IDBoLTI1Ni4xODdjLTIxLjcwNyAwLTQwLjY5NSAxMS44MTItNTAuOTEyIDI5LjMzNy0xMC4yMTYtMTcuNTI1LTI5LjIwNC0yOS4zMzctNTAuOTExLTI5LjMzN2gtNTEuNTk1Yy0zMi40NzkgMC01OC45MDIgMjYuNDI1LTU4LjkwMiA1OC45MDV2NTEuNTg3YzAgMzIuNDgxIDI2LjQyMyA1OC45MDYgNTguOTAyIDU4LjkwNmg0MDkuNjA1YzMyLjQ3OSAwIDU4LjkwMy0yNi40MjUgNTguOTAzLTU4LjkwNnYtNTEuNTg3Yy4wMDEtMzIuNDgtMjYuNDIzLTU4LjkwNS01OC45MDMtNTguOTA1eiIvPjxwYXRoIGZpbGw9IiMwOWYiIGQ9Ik00NjguNTA3IDE1My4zODNjMjMuNjg3IDAgNDIuODg4LTE5LjE5OSA0Mi44ODgtNDIuODl2LTUxLjU4OGMwLTIzLjY5MS0xOS4yMDEtNDIuODktNDIuODg4LTQyLjg5aC0yNTYuMTg3Yy0yMy42ODYgMC00Mi44ODcgMTkuMTk4LTQyLjg4NyA0Mi44OXY5NC40NzhoMjk5LjA3NHoiLz48cGF0aCBmaWxsPSIjMDA2IiBkPSJNMTUzLjM4NCAxNTMuMzgzdi05NC40NzhjMC0yMy42OTEtMTkuMjAxLTQyLjg5LTQyLjg4Ny00Mi44OWgtNTEuNTk1Yy0yMy42ODYgMC00Mi44ODcgMTkuMTk4LTQyLjg4NyA0Mi44OXY1MS41ODdjMCAyMy42OTEgMTkuMjAxIDQyLjg5IDQyLjg4NyA0Mi44OWg5NC40ODJ6Ii8%2BPHJlY3QgeD0iMzIwLjE1NiIgeT0iNzUuMjc1IiBmaWxsPSIjZmZmIiB3aWR0aD0iMTkuNjIxIiBoZWlnaHQ9IjUzLjIxMSIvPjxwYXRoIGZpbGw9IiNmZmYiIGQ9Ik0yNjIuOTEyIDg2LjI4MWMwLTUuNTI5IDMuODEzLTExLjAwNiAxMy4wNjktMTEuMDA2aDI4LjQyMXYxNS42MTNoLTE4LjYxMmMtMi40OTggMC0zLjI1NS45OTItMy4yNTUgMi42NjR2Ny40NzJoMjEuODY3djE1LjYxaC0yMS44Njd2MTEuODUyaC0xOS42MjN2LTQyLjIwNXpNMzc1LjE2NSA5MS4wOTloMTAuMzk5YzIuNDA5IDAgMy4yNDYuODMyIDMuMjQ2IDMuMjM1bC0uMDA4IDM0LjE1MmgxOS42MzJ2LTQxLjk5NmMwLTUuNTI3LTMuODE1LTExLjAwNC0xMy4wNjktMTEuMDA0aC0zOS44MjRsLS4wMSA1M2gxOS42MzR2LTM3LjM4N3pNNDQyLjcxOSA5MS4wOTloMTAuNGMyLjQwOCAwIDMuMjQ1LjgzMiAzLjI0NSAzLjIzNWwtLjAwOSAzNC4xNTJoMTkuNjM0di00MS45OTZjMC01LjUyNy0zLjgxNS0xMS4wMDQtMTMuMDctMTEuMDA0aC0zOS44MjNsLS4wMSA1M2gxOS42MzN2LTM3LjM4N3oiLz48L3N2Zz4%3D"
