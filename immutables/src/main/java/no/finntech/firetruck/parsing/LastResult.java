package no.finntech.firetruck.parsing;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.immutables.value.Value;

import java.time.ZonedDateTime;
import java.util.List;

@Value.Immutable
@JsonSerialize(as = ImmutableLastResult.class)
@JsonDeserialize(as = ImmutableLastResult.class)
@JsonIgnoreProperties(ignoreUnknown = true)
public interface LastResult {
    public String action();
    public String command();
    public Double duration();
    public ZonedDateTime executed();
    @JsonProperty("finn_app")
    public String finnApp();
    @JsonProperty("finn_env")
    public String finnEnv();
    public String output();
    public List<String> teams();
    public List<String> tags();

}
