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
public class Team {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator="team_gen")
    @SequenceGenerator(name = "team_gen", sequenceName = "TEAM_SEQ")
    private Long id;

    @Column(unique = true)
    private String name;

    @ManyToMany
    @JsonIgnore
    public List<Incident> incidents;

    public Team() {
    }

    public Team(String name) {
        this.name = name;
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
        if(getIncidents() == null) {
            setIncidents(new ArrayList<>());
        }
        getIncidents().add(incident);
    }
}
