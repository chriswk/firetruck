module Components.Incident.Decoders exposing (..)

import Components.Incident.Models exposing (..)
import Json.Decode.Extra exposing ((|:), date)
import Json.Decode exposing (Decoder, decodeValue, succeed, string, int, list, float, (:=), map)


linkDecoder : Decoder Link
linkDecoder =
    succeed Link
        |: ("href" := string)


pageDecoder : Decoder Page
pageDecoder =
    succeed Page
        |: ("size" := int)
        |: ("totalElements" := int)
        |: ("totalPages" := int)
        |: ("number" := int)


linksDecoder : Decoder Links
linksDecoder =
    succeed Links
        |: ("first" := linkDecoder)
        |: ("self" := linkDecoder)
        |: ("next" := linkDecoder)
        |: ("last" := linkDecoder)
        |: ("profile" := linkDecoder)
        |: ("search" := linkDecoder)


incidentLinksDecoder : Decoder IncidentLinks
incidentLinksDecoder =
    succeed IncidentLinks
        |: ("self" := linkDecoder)
        |: ("incident" := linkDecoder)
        |: ("tags" := linkDecoder)
        |: ("comments" := linkDecoder)
        |: ("teams" := linkDecoder)


incidentDecoder : Decoder Incident
incidentDecoder =
    succeed Incident
        |: ("checkName" := string)
        |: ("client" := string)
        |: ("dc" := string)
        |: ("lastExecution" := date)
        |: ("command" := string)
        |: ("duration" := float)
        |: ("executed" := date)
        |: ("finnApp" := string)
        |: ("finnEnv" := string)
        |: ("output" := string)
        |: ("_links" := incidentLinksDecoder)


listIncidentDecoder : Decoder (List Incident)
listIncidentDecoder =
    list incidentDecoder


incidentListDecoder : Decoder IncidentList
incidentListDecoder =
    succeed IncidentList
        |: ("incidents" := listIncidentDecoder)


incidentCollectionDecoder : Decoder IncidentsHalModel
incidentCollectionDecoder =
    succeed IncidentsHalModel
        |: ("_embedded" := incidentListDecoder)
        |: ("_links" := linksDecoder)
        |: ("page" := pageDecoder)
