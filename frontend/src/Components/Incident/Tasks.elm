module Components.Incident.Tasks exposing (..)

import Components.Incident.Decoders exposing (incidentCollectionDecoder, incidentDecoder)
import Components.Incident.Models exposing (Incident, Msg(..), IncidentsPage)
import Http exposing (get, Error, fromJson, RawError, Response, send, defaultSettings, empty, url)
import Task exposing (Task)


incidentBaseUrl : String
incidentBaseUrl =
    "http://localhost:9090/api/incidents"


getIncidentList : String -> Task Http.Error IncidentsPage
getIncidentList url =
    get incidentCollectionDecoder url


getIncident : String -> Task Http.Error Incident
getIncident url =
    get incidentDecoder url


fetchMostRecentIncidents : Cmd Msg
fetchMostRecentIncidents =
    Task.perform IncidentsFetchFail IncidentsFetchSucceed (getIncidentList incidentBaseUrl)


fetchIncident : String -> Cmd Msg
fetchIncident uri =
    Task.perform IncidentFetchFail IncidentFetchSucceed (getIncident uri)


fetchIncidents : String -> Cmd Msg
fetchIncidents pageNo =
    let
        uri =
            url incidentBaseUrl [ ( "page", pageNo ) ]
    in
        Task.perform IncidentsFetchFail IncidentsFetchSucceed (getIncidentList uri)
