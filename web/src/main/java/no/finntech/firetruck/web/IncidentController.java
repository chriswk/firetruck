package no.finntech.firetruck.web;

import javax.transaction.Transactional;
import javax.validation.Valid;

import no.finntech.firetruck.jpa.domain.Comment;
import no.finntech.firetruck.jpa.domain.Incident;
import no.finntech.firetruck.jpa.repository.IncidentRepository;
import no.finntech.firetruck.parsing.SensuIncident;
import no.finntech.firetruck.service.IncidentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class IncidentController {

    private final IncidentService incidentService;
    private final IncidentRepository incidentRepository;

    @Autowired
    public IncidentController(IncidentService incidentService, IncidentRepository incidentRepository) {
        this.incidentService = incidentService;
        this.incidentRepository = incidentRepository;
    }

    @RequestMapping(value = "/incidents/import", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<no.finntech.firetruck.jpa.domain.Incident> importIncident(@RequestBody SensuIncident sensuIncident) {

        return new ResponseEntity<>(incidentService.save(sensuIncident), HttpStatus.CREATED);
    }

    @RequestMapping(value = "/incidents/bulkimport", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> bulkImport(@RequestBody SensuIncident[] sensuIncidents) {
        incidentService.save(sensuIncidents);
        return new ResponseEntity(HttpStatus.CREATED);
    }

    @RequestMapping("/incidents/{id}")
    @Transactional
    public String view(@PathVariable("id") Long id, ModelMap modelMap) {
        Incident byId = incidentRepository.findOne(id);
        modelMap.put("incident", byId);
        modelMap.put("comments", byId.getComments());
        modelMap.put("comment", new Comment());
        return "incidents/view";
    }

    @RequestMapping("/incidents")
    public String list(ModelMap modelMap, Pageable page) {
        Page<Incident> all = incidentService.findAll(page);
        modelMap.put("incidents", all);
        modelMap.put("pagination", page);
        if (all.getTotalPages() > page.getPageNumber()) {
            modelMap.put("nextPage", page.next().getPageNumber());
        }
        return "incidents/index";
    }

    @RequestMapping(value = "/incidents/{incidentid}/comments", method = RequestMethod.POST)
    public String addComment(@PathVariable("incidentid") Long incidentId, @Valid @ModelAttribute("comment") Comment comment) {
        comment.setId(null);
        Incident i = incidentService.addComment(incidentId, comment);
        return "redirect:/incidents/" +incidentId;
    }
}
