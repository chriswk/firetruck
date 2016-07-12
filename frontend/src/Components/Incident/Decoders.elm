module Components.Incident.Decoders exposing (..)

import Json.Decode.Extra exposing ((|:), date)
import Json.Decode exposing (Decoder, decodeValue, succeed, string, (:=), float, at, list, int)
import Components.Incident.Models exposing (Incident, IncidentLinks, IncidentCollection, Pagination)
import Links exposing (linkDecoder, linksDecoder)


incidentDecoder : Decoder Incident
incidentDecoder =
    succeed Incident
        |: ("checkName" := string)
        |: ("client" := string)
        |: ("dc" := string)
        |: ("command" := string)
        |: ("duration" := float)
        |: ("executed" := date)
        |: ("finnApp" := string)
        |: ("finnEnv" := string)
        |: ("output" := string)
        |: ("_links" := incidentLinksDecoder)


incidentCollectionDecoder : Decoder IncidentCollection
incidentCollectionDecoder =
    succeed IncidentCollection
        |: at [ "_embedded", "incidents" ] incidentListDecoder
        |: ("_links" := linksDecoder)
        |: ("page" := pageDecoder)


incidentLinksDecoder : Decoder IncidentLinks
incidentLinksDecoder =
    succeed IncidentLinks
        |: ("self" := linkDecoder)
        |: ("incident" := linkDecoder)
        |: ("tags" := linkDecoder)
        |: ("comments" := linkDecoder)
        |: ("teams" := linkDecoder)


incidentListDecoder : Decoder (List Incident)
incidentListDecoder =
    Json.Decode.list incidentDecoder


pageDecoder : Decoder Pagination
pageDecoder =
    succeed Pagination
        |: ("size" := int)
        |: ("totalElements" := int)
        |: ("totalPages" := int)
        |: ("number" := int)
