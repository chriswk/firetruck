package no.finntech.firetruck.search;

import java.util.List;

import org.elasticsearch.search.aggregations.Aggregations;

public class SearchResult {
    public Aggregations aggregations;
    public List<IncidentDoc> incidents;
    public Long totalHits;

    public SearchResult() {
    }


    public Aggregations getAggregations() {
        return aggregations;
    }

    public void setAggregations(Aggregations aggregations) {
        this.aggregations = aggregations;
    }

    public List<IncidentDoc> getIncidents() {
        return incidents;
    }

    public void setIncidents(List<IncidentDoc> incidents) {
        this.incidents = incidents;
    }

    public Long getTotalHits() {
        return totalHits;
    }

    public void setTotalHits(Long totalHits) {
        this.totalHits = totalHits;
    }
}
