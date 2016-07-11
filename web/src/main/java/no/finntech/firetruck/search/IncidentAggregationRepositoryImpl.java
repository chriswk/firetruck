package no.finntech.firetruck.search;

import java.util.Map;

import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.bucket.terms.TermsBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.elasticsearch.core.ElasticsearchTemplate;
import org.springframework.data.elasticsearch.core.ResultsExtractor;
import org.springframework.data.elasticsearch.core.query.NativeSearchQuery;
import org.springframework.data.elasticsearch.core.query.NativeSearchQueryBuilder;
import org.springframework.stereotype.Component;

@Component
public class IncidentAggregationRepositoryImpl implements IncidentAggregationRepository {
    ElasticsearchTemplate template;

    @Autowired
    public IncidentAggregationRepositoryImpl(ElasticsearchTemplate template) {
        this.template = template;
    }

    @Override
    public SearchResult findAllIncidentsWithTagsAndTeams() {
        TermsBuilder tagsBuilder = new TermsBuilder("tags").field("tags");
        TermsBuilder teamsBuilder = new TermsBuilder("teams").field("teams");

        NativeSearchQuery queryWithAggs = new NativeSearchQueryBuilder()
                .withIndices("incidents")
                .withTypes("incident")
                .withFields("checkName", "tags", "teams", "comments", "id")
                .addAggregation(tagsBuilder)
                .addAggregation(teamsBuilder)
                .build();
        
        template.query(queryWithAggs, new ResultsExtractor<SearchResult>() {
            @Override
            public SearchResult extract(SearchResponse response) {
                SearchResult result = new SearchResult();
                result.setAggregations(response.getAggregations());
                response.
            }
        })
    }
}
