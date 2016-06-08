package no.finntech.firetruck.jpa.repository;

import no.finntech.firetruck.jpa.domain.Incident;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "incidents", path = "incidents")
public interface IncidentRepository extends PagingAndSortingRepository<Incident, Long> {
}
