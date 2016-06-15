module Components.Incident.Tasks exposing (..)

import Components.Incident.Decoders exposing (incidentCollectionDecoder)
import Components.Incident.Models exposing (IncidentHalModel, Msg)
import Http exposing (get, Error, fromJson, RawError, Response, send, defaultSettings, empty)
import Task exposing (Task)


getIncidentList : Task Http.Error IncidentHalModel
getIncidentList =
    get incidentCollectionDecoder "http://localhost:8080/api/incidents"


fetchMostRecentIncidents : Cmd Msg
fetchMostRecentIncidents =
    Task.perform Components.Incident.Models.IncidentFetchFail Components.Incident.Models.IncidentFetchSucceed getIncidentList
