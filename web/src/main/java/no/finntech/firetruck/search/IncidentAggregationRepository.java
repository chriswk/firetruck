package no.finntech.firetruck.search;

public interface IncidentAggregationRepository {
    SearchResult findAllIncidentsWithTagsAndTeams();
}
