module Components.Incident.Models exposing (..)

import Date exposing (Date)
import Http exposing (Error)


type alias Model =
    { sort : Maybe Sort
    , incidents : List Incident
    , lastError : Maybe Http.Error
    , currentIncident : Maybe Incident
    }


type Msg
    = NoOp
    | IncidentsFetchFail Http.Error
    | IncidentsFetchSucceed IncidentsHalModel
    | IncidentFetchFail Http.Error
    | IncidentFetchSucceed Incident
    | FetchIncident String

type alias Links =
    { first : Link
    , self : Link
    , next : Link
    , last : Link
    , profile : Link
    , search : Link
    }


type alias Link =
    { href : String
    }


type alias IncidentLinks =
    { self : Link
    , incident : Link
    , tags : Link
    , comments : Link
    , teams : Link
    }


type alias Sort =
    ( String, Direction )


type alias Page =
    { size : Int
    , totalElements : Int
    , totalPages : Int
    , currentPage : Int
    }


type alias IncidentsHalModel =
    { incidents : IncidentList
    , links : Links
    , page : Page
    }


type alias Incident =
    { name : String
    , client : String
    , dc : String
    , lastExecution : Date
    , command : String
    , duration : Float
    , executed : Date
    , finnApp : String
    , finnEnv : String
    , out : String
    , links : IncidentLinks
    }


type alias IncidentList =
    { incidents : List Incident
    }


type Direction
    = ASC
    | DESC
