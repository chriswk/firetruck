module Links exposing (..)

import Json.Decode.Extra exposing ((|:))
import Json.Decode exposing (Decoder, decodeValue, string, succeed, (:=), maybe)


type alias Link =
    { href : String
    }


type alias Links =
    { first : Maybe Link
    , self : Link
    , next : Maybe Link
    , last : Maybe Link
    , prev : Maybe Link
    }


linkDecoder : Decoder Link
linkDecoder =
    succeed Link
        |: ("href" := string)


linksDecoder : Decoder Links
linksDecoder =
    succeed Links
        |: (maybe ("first" := linkDecoder))
        |: ("self" := linkDecoder)
        |: (maybe ("next" := linkDecoder))
        |: (maybe ("last" := linkDecoder))
        |: (maybe ("prev" := linkDecoder))
