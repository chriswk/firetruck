module Components.Incident.Tasks exposing (..)

import Components.Incident.Decoders exposing (incidentCollectionDecoder, incidentDecoder)
import Components.Incident.Models exposing (IncidentsHalModel, Incident, Msg(..))
import Http exposing (get, Error, fromJson, RawError, Response, send, defaultSettings, empty)
import Task exposing (Task)


getIncidentList : Task Http.Error IncidentsHalModel
getIncidentList =
    get incidentCollectionDecoder "http://localhost:8080/api/incidents"

getIncident : String -> Task Http.Error Incident
getIncident url =
    get incidentDecoder url

fetchMostRecentIncidents : Cmd Msg
fetchMostRecentIncidents =
    Task.perform IncidentsFetchFail IncidentsFetchSucceed getIncidentList

fetchIncident : String -> Cmd Msg
fetchIncident uri =
    Task.perform IncidentFetchFail IncidentFetchSucceed (getIncident uri)

