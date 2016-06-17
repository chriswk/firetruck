module Components.Incident.Pagination exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Components.Incident.Models exposing (Msg(..), Pagination)
import Components.Icons exposing (firstPageIcon, prevPageIcon, nextPageIcon, lastPageIcon)


ariaLabel : String -> Html.Attribute a
ariaLabel label =
    attribute "aria-label" label


startLink : Html Msg
startLink =
    a [ rel "start", href "#", class "mrn pam", ariaLabel "First", onClick (UpdatePage 0) ]
        [ firstPageIcon ]


prevAnchor : Int -> Html Msg
prevAnchor currentPage =
    let
        newPage =
            currentPage - 1

        clickCmd =
            UpdatePage newPage
    in
        a [ rel "prev", href "#", class "mrn pam", ariaLabel "Previous", onClick clickCmd ]
            [ prevPageIcon ]


nextAnchor : Int -> Html Msg
nextAnchor currentPage =
    let
        nextPage =
            currentPage + 1

        clickCmd =
            UpdatePage nextPage
    in
        a [ rel "next", href "#", class "mrn pam", ariaLabel "Next", onClick clickCmd ]
            [ nextPageIcon ]


nextLink : Pagination -> Maybe (Html Msg)
nextLink pagination =
    let
        currentPage =
            pagination.currentPage

        lastPage =
            pagination.totalPages - 1

        nextL =
            if (currentPage < lastPage) then
                Just (nextAnchor currentPage)
            else
                Nothing
    in
        nextL


prevLink : Int -> Maybe (Html Msg)
prevLink currentPage =
    let
        prevLink =
            if (currentPage == 0) then
                Nothing
            else
                Just (prevAnchor currentPage)
    in
        prevLink


lastLink : Pagination -> Html Msg
lastLink pagination =
    let
        lastPage =
            pagination.totalPages - 1
    in
        a [ rel "last", href "#", class "mrn pam", ariaLabel "Last", onClick (UpdatePage lastPage) ]
            [ lastPageIcon ]


pageLink : Pagination -> Int -> Html Msg
pageLink pagination page =
    let
        pageText =
            toString (page + 1)

        link =
            if (pagination.currentPage == page) then
                b [ class "phs valign-middle" ] [ text pageText ]
            else
                a [ href "#", class "mrn pam", onClick (UpdatePage page) ] [ text pageText ]
    in
        link


pageLinks : Pagination -> List (Html Msg)
pageLinks pagination =
    let
        lastPage =
            pagination.totalPages

        range =
            [0..lastPage - 1]

        pages =
            List.map (pageLink pagination) range
    in
        pages


paginate : Pagination -> Html Msg
paginate pagination =
    let
        prevL =
            prevLink pagination.currentPage

        nextL =
            nextLink pagination

        prevLi =
            case prevL of
                Nothing ->
                    text ""

                Just prev ->
                    prev

        nextLi =
            case nextL of
                Nothing ->
                    text ""

                Just next ->
                    next

        lastLi =
            lastLink pagination

        separatePages =
            pageLinks pagination

        allLinks =
            List.concat [ [ startLink, prevLi ], separatePages, [ nextLi, lastLi ] ]
    in
        div [ class "t4 centerify r-margin" ]
            allLinks
