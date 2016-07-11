package no.finntech.firetruck.search;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.annotation.Id;
import org.springframework.data.elasticsearch.annotations.Document;
import org.springframework.data.elasticsearch.annotations.Field;
import org.springframework.data.elasticsearch.annotations.FieldType;

@Document(indexName ="incidents", type ="incident")
public class IncidentDoc {
    @Id
    private String id;

    private String checkName;

    @Field(type = FieldType.Nested)
    private List<String> tags;

    @Field(type = FieldType.Nested)
    private List<String> teams;

    @Field(type = FieldType.Nested)
    private List<String> comments;

    public IncidentDoc() {
    }

    public IncidentDoc(String id, String checkName, List<String> tags, List<String> teams, List<String> comments) {
        this.id = id;
        this.checkName = checkName;
        this.tags = tags;
        this.teams = teams;
        this.comments = comments;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getCheckName() {
        return checkName;
    }

    public void setCheckName(String checkName) {
        this.checkName = checkName;
    }

    public List<String> getTags() {
        return tags;
    }

    public void setTags(List<String> tags) {
        this.tags = tags;
    }

    public void addTag(String tag) {
        if (this.tags == null) {
            setTags(new ArrayList<>());
        }
        getTags().add(tag);
    }

    public List<String> getTeams() {
        return teams;
    }

    public void setTeams(List<String> teams) {
        this.teams = teams;
    }
    public void addTeam(String team) {
        if (this.teams == null) {
            setTeams(new ArrayList<>());
        }
        getTeams().add(team);
    }

    public List<String> getComments() {
        return comments;
    }

    public void setComments(List<String> comments) {
        this.comments = comments;
    }

    public void addComment(String comment) {
        if (this.comments == null) {
            setComments(new ArrayList<>());
        }
        getComments().add(comment);
    }
}
