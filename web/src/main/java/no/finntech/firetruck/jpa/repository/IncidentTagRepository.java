package no.finntech.firetruck.jpa.repository;

import java.util.Optional;

import no.finntech.firetruck.jpa.domain.IncidentTag;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;


@RepositoryRestResource(path = "incidenttags", collectionResourceRel = "incidenttags")
public interface IncidentTagRepository extends PagingAndSortingRepository<IncidentTag, Long> {
    Optional<IncidentTag> findByName(String name);
}
