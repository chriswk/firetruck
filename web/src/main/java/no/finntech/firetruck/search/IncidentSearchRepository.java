package no.finntech.firetruck.search;

import org.springframework.data.elasticsearch.repository.ElasticsearchCrudRepository;

public interface IncidentSearchRepository extends ElasticsearchCrudRepository<IncidentDoc, Long>, IncidentAggregationRepository {
}
