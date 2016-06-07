package no.finntech.firetruck.repository;

import no.finntech.firetruck.domain.Comment;

import org.springframework.data.repository.PagingAndSortingRepository;

public interface CommentRepository extends PagingAndSortingRepository<Comment, Long> {
}
