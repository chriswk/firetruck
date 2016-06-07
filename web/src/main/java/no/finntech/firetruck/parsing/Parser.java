package no.finntech.firetruck.parsing;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jdk8.Jdk8Module;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import java.io.IOException;

public class Parser {
    public ObjectMapper objectMapper;

    public Parser() {
        objectMapper = new ObjectMapper()
                .registerModule(new JavaTimeModule())
                .registerModule(new Jdk8Module());
    }
    public Incident parse(String json) throws IOException {
        return objectMapper.readValue(json, Incident.class);
    }
}
