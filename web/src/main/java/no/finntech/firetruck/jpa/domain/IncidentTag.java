package no.finntech.firetruck.jpa.domain;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.SequenceGenerator;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
public class IncidentTag {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator="incidenttag_gen")
    @SequenceGenerator(name = "incidenttag_gen", sequenceName = "INCIDENTTAG_SEQ")
    private Long id;

    @Column(unique = true)
    private String name;

    @ManyToMany
    @JsonIgnore
    private List<Incident> incidents;

    public IncidentTag() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Incident> getIncidents() {
        return incidents;
    }

    public void setIncidents(List<Incident> incidents) {
        this.incidents = incidents;
    }

    public void addIncident(Incident incident) {
        if (getIncidents() == null) {
            setIncidents(new ArrayList<>());
        }
        getIncidents().add(incident);
    }
}

