module Components.Incident.Tasks exposing (..)

import Components.Incident.Decoders exposing (incidentCollectionDecoder, incidentDecoder)
import Components.Incident.Models exposing (Incident, Msg(..), IncidentsPage, Sort, Direction(..), Model)
import Http exposing (get, Error, fromJson, RawError, Response, send, defaultSettings, empty, url)
import Task exposing (Task)


incidentBaseUrl : String
incidentBaseUrl =
    "/api/incidents"




getIncident : String -> Task Http.Error Incident
getIncident url =
    get incidentDecoder url


fetchMostRecentIncidents : Cmd Msg
fetchMostRecentIncidents =
    Task.perform IncidentsFetchFail IncidentsFetchSucceed (getIncidentList incidentBaseUrl)


fetchIncident : String -> Cmd Msg
fetchIncident uri =
    Task.perform IncidentFetchFail IncidentFetchSucceed (getIncident uri)

getIncidentList : String -> Task Http.Error IncidentsPage
getIncidentList url =
    get incidentCollectionDecoder url


fetchIncidents : Model -> Cmd Msg
fetchIncidents model =
    let
        sortString = case model.sort of
            Nothing -> []
            Just s -> [( "sort", sortParam s )]

        limitStr = [("size", toString model.pageSize)]

        pageStr = [("page", toString model.currentPage) ]

        params = List.concat [sortString, limitStr, pageStr]
        uri =
            url incidentBaseUrl params
    in
        Task.perform IncidentsFetchFail IncidentsFetchSucceed (getIncidentList uri)


sortParam : Sort -> String
sortParam sort =
    let
        dir = case sort.direction of
            ASC -> "asc"
            DESC -> "desc"

    in
        sort.column ++ "," ++ dir
