package no.finntech.firetruck.web;

import no.finntech.firetruck.parsing.SensuIncident;
import no.finntech.firetruck.service.IncidentService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
public class IncidentController {

    private final IncidentService incidentService;

    @Autowired
    public IncidentController(IncidentService incidentService) {
        this.incidentService = incidentService;
    }

    @RequestMapping(value = "/incidents/import", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<no.finntech.firetruck.domain.Incident> importIncident(@RequestBody SensuIncident sensuIncident) {

        return new ResponseEntity<>(incidentService.save(sensuIncident), HttpStatus.CREATED);
    }

    @RequestMapping(value = "/incidents/bulkimport", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<?> bulkImport(@RequestBody SensuIncident[] sensuIncidents) {
        incidentService.save(sensuIncidents);
        return new ResponseEntity(HttpStatus.CREATED);
    }

    @RequestMapping("/incidents")
    public String list(ModelMap modelMap, Pageable page) {
        modelMap.put("incidents", incidentService.findAll(page));
        return "incidents/index";
    }
}
