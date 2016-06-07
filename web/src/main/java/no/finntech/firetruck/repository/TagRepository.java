package no.finntech.firetruck.repository;

import java.util.Optional;

import no.finntech.firetruck.domain.IncidentTag;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;


@RepositoryRestResource(path = "tags", collectionResourceRel = "tags")
public interface TagRepository extends PagingAndSortingRepository<IncidentTag, Long> {
    public Optional<IncidentTag> findByName(String name);
}
