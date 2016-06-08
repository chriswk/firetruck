package no.finntech.firetruck.web;

import java.util.Arrays;

import no.finntech.firetruck.jpa.domain.IncidentTag;
import no.finntech.firetruck.jpa.repository.IncidentRepository;
import no.finntech.firetruck.jpa.repository.IncidentTagRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IncidentTagsController {
    IncidentTagRepository incidentTagRepository;
    IncidentRepository incidentRepository;

    @Autowired
    public IncidentTagsController(IncidentTagRepository incidentTagRepository, IncidentRepository incidentRepository) {
        this.incidentTagRepository = incidentTagRepository;
        this.incidentRepository = incidentRepository;
    }

    @RequestMapping("/incidenttags")
    public String list(Pageable page, ModelMap modelMap) {
        modelMap.put("incidenttags", incidentTagRepository.findAll(page));
        modelMap.put("pagination", page);
        return "incidenttags/index";
    }

    @RequestMapping("/incidenttags/{id}")
    public String view(@PathVariable("id") Long id, ModelMap modelMap) {
        IncidentTag tag = incidentTagRepository.findOne(id);
        modelMap.put("tag", tag);
        PageRequest pageRequest = new PageRequest(0, 5, Sort.Direction.DESC, "lastExecution");
        modelMap.put("mostRecentIncidents", incidentRepository.findByTags(Arrays.asList(tag), pageRequest));
        return "incidenttags/view";
    }
}
