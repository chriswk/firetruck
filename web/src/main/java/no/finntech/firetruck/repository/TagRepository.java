package no.finntech.firetruck.repository;

import no.finntech.firetruck.domain.Tag;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.Optional;


@RepositoryRestResource(path = "tags", collectionResourceRel = "Tags")
public interface TagRepository extends PagingAndSortingRepository<Tag, Long> {
    public Optional<Tag> findByName(String name);
}
