package no.finntech.firetruck.domain;

import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.validation.constraints.Size;

@Entity
public class Comment {
    @Id
    @GeneratedValue
    private Long id;

    @Size(max = 10000)
    private String information;

    @OneToMany
    private List<Tag> tags;

    @ManyToOne
    private Incident incident;

    public Comment() {
    }

    public Comment(String information, List<Tag> tags, Incident incident) {
        this.information = information;
        this.tags = tags;
        this.incident = incident;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getInformation() {
        return information;
    }

    public void setInformation(String information) {
        this.information = information;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    public Incident getIncident() {
        return incident;
    }

    public void setIncident(Incident incident) {
        this.incident = incident;
    }
}
