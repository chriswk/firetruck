module Components.Incident.Tasks exposing (..)

import Task exposing (Task)
import Http exposing (Error, url)
import Components.Incident.Models exposing (Incident, IncidentCollection, Sort, Direction(..), Pagination)
import Components.Incident.Decoders exposing (incidentCollectionDecoder, incidentDecoder)


incidentBaseUrl : String
incidentBaseUrl =
    "/api/incidents"


sortParam : Sort -> String
sortParam sort =
    let
        dir =
            case sort.direction of
                Asc ->
                    "asc"

                Desc ->
                    "desc"
    in
        sort.column ++ "," ++ dir


fetchIncidents : Pagination -> Sort -> Task Error IncidentCollection
fetchIncidents pagination sort =
    let
        sortString =
            ( "sort", (sortParam sort) )

        pageNo =
            ( "page", toString (pagination.currentPage) )

        size =
            ( "size", (toString pagination.pageSize) )

        params =
            [ sortString, pageNo, size ]

        incidentUrl =
            Debug.log "incidenturl: " (url incidentBaseUrl params)
    in
        Http.get incidentCollectionDecoder incidentUrl


fetchIncident : Int -> Task Error Incident
fetchIncident id =
    let
        idStr =
            toString id

        url =
            incidentBaseUrl ++ "/" ++ idStr
    in
        Http.get incidentDecoder url
