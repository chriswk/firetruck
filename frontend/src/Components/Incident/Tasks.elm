module Components.Incident.Tasks exposing (..)

import Task exposing (Task)
import Http exposing (Error, url)
import Components.Incident.Models exposing (Incident, IncidentCollection, Sort, Direction(..))
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


fetchIncidents : Sort -> Task Error IncidentCollection
fetchIncidents sort =
    let
        sortString =
            ( "sort", (sortParam sort) )

        params =
            [ sortString ]

        incidentUrl =
            url incidentBaseUrl params
    in
        Http.get incidentCollectionDecoder incidentUrl


fetchIncident : Int -> Task Error Incident
fetchIncident id =
    let
        idStr =
            toString id

        incidentUrl =
            incidentBaseUrl ++ "/" ++ idStr
    in
        Http.get incidentDecoder incidentUrl
