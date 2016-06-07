package no.finntech.firetruck.repository;

import no.finntech.firetruck.domain.Team;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.Optional;


@RepositoryRestResource(collectionResourceRel = "teams", path = "teams")
public interface TeamRepository extends PagingAndSortingRepository<Team, Long> {
    public Optional<Team> findByName(String name);
}
