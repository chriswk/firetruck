package no.finntech.firetruck.web;

import java.util.List;

import no.finntech.firetruck.domain.Tag;
import no.finntech.firetruck.domain.Team;
import no.finntech.firetruck.parsing.Incident;
import no.finntech.firetruck.repository.IncidentRepository;
import no.finntech.firetruck.repository.TagRepository;
import no.finntech.firetruck.repository.TeamRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import static java.util.stream.Collectors.toList;


@RestController
public class IncidentController {
    IncidentRepository incidentRepository;
    TagRepository tagRepository;
    TeamRepository teamRepository;

    @Autowired
    public IncidentController(IncidentRepository incidentRepository, TagRepository tagRepository, TeamRepository teamRepository) {
        this.incidentRepository = incidentRepository;
        this.tagRepository = tagRepository;
        this.teamRepository = teamRepository;
    }

    @RequestMapping(value = "/incidents/import", method = RequestMethod.POST)
    public ResponseEntity<?> importIncident(@RequestBody Incident incident) {
        no.finntech.firetruck.domain.Incident domainInc = new no.finntech.firetruck.domain.Incident();
        List<Tag> tags = incident.lastResult().tags().stream().map(tagName -> {
            return tagRepository.findByName(tagName).orElseGet(() -> {
                Tag temp = new Tag();
                temp.setName(tagName);
                return temp;
            });
        }).collect(toList());
        tagRepository.save(tags);
        List<Team> teams = incident.lastResult().teams().stream().map(teamName ->
            teamRepository.findByName(teamName).orElseGet(() -> {
                Team team = new Team();
                team.setName(teamName);
                return team;
            })
        ).collect(toList());
        teamRepository.save(teams);
        domainInc.setTeams(teams);
        domainInc.setTags(tags);
        domainInc.setCheckName(incident.checkName());
        domainInc.setClient(incident.client());
        domainInc.setDc(incident.dc());
        domainInc.setDuration(incident.lastResult().duration());
        domainInc.setExecuted(incident.lastResult().executed());
        domainInc.setLast_execution(incident.lastExecution());
        domainInc.setCommand(incident.lastResult().command());
        domainInc.setFinn_app(incident.lastResult().finnApp());
        domainInc.setFinn_env(incident.lastResult().finnEnv());
        domainInc.setOutput(incident.lastResult().output());
        incidentRepository.save(domainInc);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @RequestMapping("/incidents")
    public String list(ModelMap modelMap, Pageable page) {
        modelMap.put("incidents", incidentRepository.findAll(page));
        return "incidents/index";
    }
}
