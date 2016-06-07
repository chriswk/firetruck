package no.finntech.firetruck.parsing;

import org.junit.Test;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.stream.Collectors;

import static org.assertj.core.api.Assertions.assertThat;

public class ParserTest {

    @Test
    public void canReadASingle() throws IOException {
        Parser parser = new Parser();
        Incident incident = parser.parse(readFile("exampleincident.json"));
        assertThat(incident.dc()).isEqualTo("sensu");
        assertThat(incident.checkName()).isEqualTo("VETTING_HEALTH_CHECK_WEAK");
    }

    public String readFile(String filename) {
        try (InputStream stream = this.getClass().getClassLoader().getResourceAsStream(filename);
             InputStreamReader isReader = new InputStreamReader(stream, "utf-8");
             BufferedReader reader = new BufferedReader(isReader);
        ) {
            return reader.lines().collect(Collectors.joining("\n"));
        } catch (IOException ioEx) {
            return "";
        }
    }

}
