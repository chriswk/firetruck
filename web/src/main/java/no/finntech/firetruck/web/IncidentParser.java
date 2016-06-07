package no.finntech.firetruck.web;

import no.finntech.firetruck.parsing.Incident;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class IncidentParser {

    @RequestMapping(value = "/incident", method = RequestMethod.POST)
    public Incident parseDoc(@RequestParam(name="incident")Incident incident) {
        return incident;
    }
}
