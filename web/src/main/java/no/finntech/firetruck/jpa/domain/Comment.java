package no.finntech.firetruck.jpa.domain;

import java.sql.Timestamp;
import java.time.ZonedDateTime;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.SequenceGenerator;
import javax.validation.constraints.Size;

@Entity
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator="comment_gen")
    @SequenceGenerator(name = "comment_gen", sequenceName = "COMMENT_SEQ")
    private Long id;

    @Size(max = 10000)
    private String information;

    @OneToMany
    private List<IncidentTag> tags;

    private Timestamp posted;

    @ManyToOne
    private Incident incident;

    public Comment() {
    }

    public Comment(String information, List<IncidentTag> tags, Timestamp posted, Incident incident) {
        this.information = information;
        this.tags = tags;
        this.posted = posted;
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

    public List<IncidentTag> getTags() {
        return tags;
    }

    public void setTags(List<IncidentTag> tags) {
        this.tags = tags;
    }

    public Incident getIncident() {
        return incident;
    }

    public void setIncident(Incident incident) {
        this.incident = incident;
    }

    public Timestamp getPosted() {
        return posted;
    }

    public void setPosted(Timestamp posted) {
        this.posted = posted;
    }

    @PrePersist
    public void updatePosted() {
        setPosted(Timestamp.from(ZonedDateTime.now().toInstant()));
    }
}
