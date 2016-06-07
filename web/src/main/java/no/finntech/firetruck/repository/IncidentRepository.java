package no.finntech.firetruck.repository;

import no.finntech.firetruck.domain.Incident;
import no.finntech.firetruck.domain.Tag;
import no.finntech.firetruck.domain.Team;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RepositoryRestResource(collectionResourceRel = "incidents", path = "incidents")
public interface IncidentRepository extends PagingAndSortingRepository<Incident, Long> {
    public List<Incident> findByTags(@Param("tag") Tag tag);
    public List<Incident> findByTeams(@Param("team") Team team);

    @Query("select DISTINCT i FROM Incident i LEFT JOIN i.tags t WHERE t.id = ?1")
    @Transactional
    public List<Incident> findByTagId(@Param("tagId") Long tagId);
}
