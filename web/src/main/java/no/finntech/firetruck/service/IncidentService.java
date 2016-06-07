package no.finntech.firetruck.service;

import java.util.List;

import no.finntech.firetruck.domain.Incident;
import no.finntech.firetruck.domain.IncidentTag;
import no.finntech.firetruck.domain.Team;
import no.finntech.firetruck.parsing.SensuIncident;
import no.finntech.firetruck.repository.IncidentRepository;
import no.finntech.firetruck.repository.TagRepository;
import no.finntech.firetruck.repository.TeamRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import static java.util.stream.Collectors.toList;

@Service
public class IncidentService {
    IncidentRepository incidentRepository;
    TagRepository tagRepository;
    TeamRepository teamRepository;

    @Autowired
    public IncidentService(IncidentRepository incidentRepository, TagRepository tagRepository, TeamRepository teamRepository) {
        this.incidentRepository = incidentRepository;
        this.tagRepository = tagRepository;
        this.teamRepository = teamRepository;
    }

    public Page<no.finntech.firetruck.domain.Incident> findAll(Pageable page) {
        return incidentRepository.findAll(page);
    }

    public Iterable<no.finntech.firetruck.domain.Incident> findAll() {
        return incidentRepository.findAll();
    }

    public Incident save(SensuIncident sensuIncident) {
        Incident domainInc = new Incident();
        List<IncidentTag> tags = sensuIncident.lastResult().tags().stream().map(tagName -> tagRepository.findByName(tagName).orElseGet(() -> {
            IncidentTag temp = new IncidentTag();
            temp.setName(tagName);
            return temp;
        })).collect(toList());
        tagRepository.save(tags);
        List<Team> teams = sensuIncident.lastResult().teams().stream().map(teamName ->
                teamRepository.findByName(teamName).orElseGet(() -> {
                    Team team = new Team();
                    team.setName(teamName);
                    return team;
                })
        ).collect(toList());
        teamRepository.save(teams);

        teams.forEach(domainInc::addTeam);
        tags.forEach(domainInc::addTag);
        domainInc.setCheckName(sensuIncident.checkName());
        domainInc.setClient(sensuIncident.client());
        domainInc.setDc(sensuIncident.dc());
        domainInc.setDuration(sensuIncident.lastResult().duration());
        domainInc.setExecuted(sensuIncident.lastResult().executed());
        domainInc.setLast_execution(sensuIncident.lastExecution());
        domainInc.setCommand(sensuIncident.lastResult().command());
        domainInc.setFinn_app(sensuIncident.lastResult().finnApp());
        domainInc.setFinn_env(sensuIncident.lastResult().finnEnv());
        domainInc.setOutput(sensuIncident.lastResult().output());
        return incidentRepository.save(domainInc);
    }

    public void save(SensuIncident... incidents) {
        for(SensuIncident i : incidents) {
            save(i);
        }
    }
    public void save(List<SensuIncident> incidents) {
        incidents.forEach(this::save);
    }

    public Incident findById(long id) {
        return incidentRepository.findOne(id);
    }

}
