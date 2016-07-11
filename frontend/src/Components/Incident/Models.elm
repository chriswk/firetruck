module Components.Incident.Models exposing (..)

import Links exposing (Link, Links)
import Date exposing (Date)


type alias IncidentId =
    Int


type alias Incident =
    { checkName : String
    , client : String
    , dc : String
    , command : String
    , duration : Float
    , executed : Date
    , finnApp : String
    , finnEnv : String
    , out : String
    , links : IncidentLinks
    }


type alias IncidentLinks =
    { self : Link
    , incident : Link
    , tags : Link
    , comments : Link
    , teams : Link
    }


type alias IncidentCollection =
    { incidents : List Incident
    , links : Links
    }


type Direction
    = Asc
    | Desc


type alias Column =
    String


type alias Sort =
    { column : Column
    , direction : Direction
    }
