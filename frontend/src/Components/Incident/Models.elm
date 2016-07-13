module Components.Incident.Models exposing (..)

import Links exposing (Link, Links)
import Date exposing (Date)
import Http exposing (Error)


type alias IncidentId =
    Int


type Msg
    = IncidentsFetchFail Http.Error
    | IncidentsFetchSucceed IncidentCollection
    | FetchIncidents
    | SortTable Sort
    | SwitchPage Page


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


type alias Page =
    Int


type alias Pagination =
    { pageSize : Int
    , totalElements : Int
    , totalPages : Int
    , currentPage : Page
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
    , pagination : Pagination
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
