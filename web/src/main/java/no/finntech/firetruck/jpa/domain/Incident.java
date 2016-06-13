package no.finntech.firetruck.jpa.domain;

import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.validation.constraints.Size;

@Entity
public class Incident {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO, generator="incident_gen")
    @SequenceGenerator(name = "incident_gen", sequenceName = "INCIDENT_SEQ")
    private Long id;
    private String checkName;
    private String client;
    private String dc;
    private ZonedDateTime lastExecution;

    @Size(max = 10000)
    private String command;
    private Double duration;
    private ZonedDateTime executed;
    private String finnApp;
    private String finnEnv;

    @Size(max = 10000)
    private String output;


    @ManyToMany(mappedBy = "incidents")
    private List<Team> teams;

    @ManyToMany(mappedBy = "incidents")
    private List<IncidentTag> tags;

    @OneToMany(mappedBy = "incident")
    private List<Comment> comments;


    public Incident() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCheckName() {
        return checkName;
    }

    public void setCheckName(String checkName) {
        this.checkName = checkName;
    }

    public String getClient() {
        return client;
    }

    public void setClient(String client) {
        this.client = client;
    }

    public String getDc() {
        return dc;
    }

    public void setDc(String dc) {
        this.dc = dc;
    }


    public String getCommand() {
        return command;
    }

    public void setCommand(String command) {
        this.command = command;
    }

    public Double getDuration() {
        return duration;
    }

    public void setDuration(Double duration) {
        this.duration = duration;
    }

    public ZonedDateTime getExecuted() {
        return executed;
    }

    public void setExecuted(ZonedDateTime executed) {
        this.executed = executed;
    }

    public String getOutput() {
        return output;
    }

    public void setOutput(String output) {
        this.output = output;
    }

    public List<Team> getTeams() {
        return teams;
    }

    public void setTeams(List<Team> teams) {
        this.teams = teams;
    }

    public List<IncidentTag> getTags() {
        return tags;
    }

    public void setTags(List<IncidentTag> tags) {
        this.tags = tags;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public ZonedDateTime getLastExecution() {
        return lastExecution;
    }

    public void setLastExecution(ZonedDateTime lastExecution) {
        this.lastExecution = lastExecution;
    }

    public String getFinnApp() {
        return finnApp;
    }

    public void setFinnApp(String finnApp) {
        this.finnApp = finnApp;
    }

    public String getFinnEnv() {
        return finnEnv;
    }

    public void setFinnEnv(String finnEnv) {
        this.finnEnv = finnEnv;
    }

    public void addTeam(Team team) {
        if (this.getTeams() == null) {
            this.setTeams(new ArrayList<>());
        }
        this.getTeams().add(team);
        team.addIncident(this);
    }

    public void addTag(IncidentTag tag) {
        if (this.getTags() == null) {
            this.setTags(new ArrayList<>());
        }
        this.getTags().add(tag);
        tag.addIncident(this);
    }

    public void addComment(Comment comment) {
        if (this.getComments() == null) {
            this.setComments(new ArrayList<>());
        }
        this.getComments().add(comment);
        comment.setIncident(this);
    }
}

