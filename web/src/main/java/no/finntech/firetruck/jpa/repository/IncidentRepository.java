package no.finntech.firetruck.jpa.repository;

import java.util.List;

import no.finntech.firetruck.jpa.domain.Incident;
import no.finntech.firetruck.jpa.domain.IncidentTag;
import no.finntech.firetruck.jpa.domain.Team;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "incidents", path = "incidents")
public interface IncidentRepository extends PagingAndSortingRepository<Incident, Long> {
    Page<Incident> findByTags(List<IncidentTag> incidentTags, Pageable page);
    Page<Incident> findByTeams(List<Team> teams, Pageable page);
}
