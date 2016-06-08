package no.finntech.firetruck.jpa.repository;

import java.util.Optional;

import no.finntech.firetruck.jpa.domain.Team;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;


@RepositoryRestResource(collectionResourceRel = "teams", path = "teams")
public interface TeamRepository extends PagingAndSortingRepository<Team, Long> {
    public Optional<Team> findByName(String name);
}
