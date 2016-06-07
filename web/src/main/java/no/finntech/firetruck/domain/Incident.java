package no.finntech.firetruck.domain;

import java.time.ZonedDateTime;
import java.util.List;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.OneToMany;
@Entity
public class Incident {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String checkName;
    private String client;
    private String dc;
    private ZonedDateTime last_execution;
    @Lob
    private String command;
    private Double duration;
    private ZonedDateTime executed;
    private String finn_app;
    private String finn_env;
    private String output;

    @OneToMany
    private List<Team> teams;

    @OneToMany
    private List<Tag> tags;

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

    public ZonedDateTime getLast_execution() {
        return last_execution;
    }

    public void setLast_execution(ZonedDateTime last_execution) {
        this.last_execution = last_execution;
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

    public String getFinn_app() {
        return finn_app;
    }

    public void setFinn_app(String finn_app) {
        this.finn_app = finn_app;
    }

    public String getFinn_env() {
        return finn_env;
    }

    public void setFinn_env(String finn_env) {
        this.finn_env = finn_env;
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

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }
}
