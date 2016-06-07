package no.finntech.firetruck.repository;

import no.finntech.firetruck.domain.Comment;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "comments", path = "comments")
public interface CommentRepository extends PagingAndSortingRepository<Comment, Long> {
}
