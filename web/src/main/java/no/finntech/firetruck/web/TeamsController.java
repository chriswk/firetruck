package no.finntech.firetruck.web;

import java.util.Arrays;

import no.finntech.firetruck.jpa.domain.Team;
import no.finntech.firetruck.jpa.repository.IncidentRepository;
import no.finntech.firetruck.jpa.repository.TeamRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TeamsController {
    TeamRepository teamRepository;
    IncidentRepository incidentRepository;

    @Autowired
    public TeamsController(TeamRepository teamRepository, IncidentRepository incidentRepository) {
        this.teamRepository = teamRepository;
        this.incidentRepository = incidentRepository;
    }

    @RequestMapping("/teams")
    public String list(ModelMap modelMap, Pageable page) {
        modelMap.put("teams", teamRepository.findAll(page));
        modelMap.put("pagination", page);
        return "teams/index";
    }

    @RequestMapping("/teams/{id}")
    public String view(@PathVariable("id") Long id, ModelMap modelMap) {
        Team team = teamRepository.findOne(id);
        modelMap.put("team", team);
        modelMap.put("mostRecentIncidents", incidentRepository.findByTeams(Arrays.asList(team)));
        return "teams/view";
    }
}
