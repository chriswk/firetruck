package no.finntech.firetruck.parsing;

import java.time.ZonedDateTime;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.immutables.value.Value;

@Value.Immutable
@JsonSerialize(as = ImmutableSensuIncident.class)
@JsonDeserialize(as = ImmutableSensuIncident.class)
@JsonIgnoreProperties(ignoreUnknown = true)
public interface SensuIncident {
    @JsonProperty(value = "check")
    public String checkName();
    public String client();
    public String dc();
    @JsonProperty(value = "last_execution")
    public ZonedDateTime lastExecution();
    @JsonProperty(value = "last_result")
    public LastResult lastResult();

}
