package no.finntech.firetruck.web;

import no.finntech.firetruck.jpa.repository.IncidentRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

    IncidentRepository incidentRepository;

    @Autowired
    public HomeController(IncidentRepository incidentRepository) {
        this.incidentRepository = incidentRepository;
    }

    @RequestMapping("/")
    public String index(ModelMap modelMap) {
        Sort sort = new Sort(Sort.Direction.DESC, "lastExecution");
        PageRequest pageRequest = new PageRequest(0, 5, sort);
        modelMap.put("mostRecentIncidents", incidentRepository.findAll(pageRequest));
        return "index";
    }
}
