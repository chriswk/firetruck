package no.finntech.firetruck.parsing;

import java.time.ZonedDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.immutables.value.Value;

@Value.Immutable
@JsonSerialize(as = ImmutableLastResult.class)
@JsonDeserialize(as = ImmutableLastResult.class)
@JsonIgnoreProperties(ignoreUnknown = true)
public interface LastResult {
    @Value.Default
    public default String action() {
        return "";
    }
    @Value.Default
    public default String command() {
        return "unknown";
    }
    @Value.Default
    public default Double duration() {
        return 0.0d;
    };
    @Value.Default
    public default ZonedDateTime executed() {
        return ZonedDateTime.now();
    };

    @Value.Default
    @JsonProperty("finn_app")
    public default String finnApp() {
        return "unknown";
    }
    @Value.Default
    @JsonProperty("finn_env")
    public default String finnEnv() {
        return "unknown";
    }
    @Value.Default
    public default String output() {
        return "";
    }
    public List<String> teams();
    public List<String> tags();

}
