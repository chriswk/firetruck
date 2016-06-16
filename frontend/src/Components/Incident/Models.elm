module Components.Incident.Models exposing (..)

import Date exposing (Date)
import Http exposing (Error)


type alias Model =
    { sort : Maybe Sort
    , incidentsPage : Maybe IncidentsPage
    , lastError : Maybe Http.Error
    , currentIncident : Maybe Incident
    , pageSize : Int
    }


type Msg
    = NoOp
    | DisplayIncidentList
    | IncidentPage Int
    | IncidentsFetchFail Http.Error
    | IncidentsFetchSucceed IncidentsPage
    | IncidentFetchFail Http.Error
    | IncidentFetchSucceed Incident
    | FetchIncident String


type alias Links =
    { first : Link
    , self : Link
    , next : Maybe Link
    , last : Link
    , profile : Link
    , search : Link
    , prev : Maybe Link
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


type alias Pagination =
    { size : Int
    , totalElements : Int
    , totalPages : Int
    , currentPage : Int
    }


type alias IncidentsPage =
    { incidents : IncidentsList
    , links : Links
    , pagination : Pagination
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


type alias IncidentsList =
    { incidents : List Incident
    }


type Direction
    = ASC
    | DESC
