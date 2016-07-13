module Components.Incident.Pagination exposing (..)

import Helpers exposing (ariaLabel)
import Images exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Components.Incident.Models exposing (Page, Pagination, Msg, Msg(..))


startLink : Html Msg
startLink =
    a [ rel "start", class "mrn pam", ariaLabel "First", onClick (SwitchPage 0) ]
        [ firstPageIcon ]


prevAnchor : Page -> Html Msg
prevAnchor currentPage =
    let
        prevPage =
            currentPage - 1

        prevCmd =
            SwitchPage prevPage
    in
        a [ rel "prev", class "mrn pam", ariaLabel "Previous", onClick prevCmd ]
            [ prevPageIcon ]


prevLink : Page -> Maybe (Html Msg)
prevLink page =
    if (page == 0) then
        Nothing
    else
        Just (prevAnchor page)


nextAnchor : Page -> Html Msg
nextAnchor currentPage =
    let
        nextPage =
            currentPage + 1

        nextCmd =
            SwitchPage nextPage
    in
        a [ rel "next", class "mrn pam", ariaLabel "Next", onClick nextCmd ]
            [ nextPageIcon ]


nextLink : Pagination -> Maybe (Html Msg)
nextLink pagination =
    let
        currentPage =
            pagination.currentPage

        lastPage =
            pagination.totalPages - 1
    in
        if (currentPage < lastPage) then
            Just (nextAnchor currentPage)
        else
            Nothing


lastLink : Pagination -> Html Msg
lastLink pagination =
    let
        lastPage =
            pagination.totalPages - 1

        lastCmd =
            SwitchPage lastPage
    in
        a [ rel "last", class "mrn pam", ariaLabel "Last", onClick lastCmd ]
            [ lastPageIcon ]


pageLink : Pagination -> Page -> Html Msg
pageLink pagination page =
    let
        pageText =
            toString (page + 1)

        cmd =
            SwitchPage page
    in
        if (pagination.currentPage == page) then
            b [ class "phs valign-middle" ] [ text pageText ]
        else
            a [ class "mrn pam", onClick cmd ] [ text pageText ]


pageLinks : Pagination -> List (Html Msg)
pageLinks pagination =
    let
        lastPage =
            pagination.totalPages - 1

        curPage =
            pagination.currentPage

        minPage =
            Basics.max 0 (curPage - 3)

        maxPage =
            Basics.min lastPage (curPage + 3)

        range =
            [minPage..maxPage]

        linkFn =
            pageLink pagination
    in
        List.map linkFn range


paginate : Pagination -> Html Msg
paginate pagination =
    let
        prevL =
            prevLink pagination.currentPage

        nextL =
            nextLink pagination

        previous =
            case prevL of
                Nothing ->
                    text ""

                Just pre ->
                    pre

        next =
            case nextL of
                Nothing ->
                    text ""

                Just nex ->
                    nex

        last =
            lastLink pagination

        remainingPages =
            pageLinks pagination

        allLinks =
            List.concat [ [ startLink, previous ], remainingPages, [ next, last ] ]
    in
        div [ class "t4 centerify r-margin" ]
            allLinks
