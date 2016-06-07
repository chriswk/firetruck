package no.finntech.firetruck.repository;

import no.finntech.firetruck.domain.Incident;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "incidents", path = "incidents")
public interface IncidentRepository extends PagingAndSortingRepository<Incident, Long> {
}
