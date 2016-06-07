package no.finntech.firetruck.web;

import no.finntech.firetruck.domain.Team;
import no.finntech.firetruck.repository.TeamRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TeamsController {
    TeamRepository teamRepository;

    @Autowired
    public TeamsController(TeamRepository teamRepository) {
        this.teamRepository = teamRepository;
    }

    @RequestMapping("/teams")
    public String list(ModelMap modelMap, Pageable page) {
        modelMap.put("teams", teamRepository.findAll(page));
        return "teams/index";
    }

    @RequestMapping("/teams/{id}")
    public String view(@PathVariable("id") Long id, ModelMap modelMap) {
        Team team = teamRepository.findOne(id);
        modelMap.put("team", team);
        modelMap.put("incidents", team.getIncidents());
        return "teams/view";
    }
}
