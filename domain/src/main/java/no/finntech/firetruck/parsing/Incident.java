package no.finntech.firetruck.parsing;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.immutables.value.Value;

import java.time.ZonedDateTime;

@Value.Immutable
@JsonSerialize(as = ImmutableIncident.class)
@JsonDeserialize(as = ImmutableIncident.class)
@JsonIgnoreProperties(ignoreUnknown = true)
public interface Incident {
    @JsonProperty(value = "check")
    public String checkName();
    public String client();
    public String dc();
    @JsonProperty(value = "last_execution")
    public ZonedDateTime lastExecution();
    @JsonProperty(value = "last_result")
    public LastResult lastResult();

}
