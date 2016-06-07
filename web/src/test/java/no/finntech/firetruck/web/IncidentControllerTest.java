package no.finntech.firetruck.web;

import java.net.URI;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Random;
import javax.transaction.Transactional;

import no.finntech.firetruck.TestConfig;
import no.finntech.firetruck.domain.IncidentTag;
import no.finntech.firetruck.parsing.ImmutableSensuIncident;
import no.finntech.firetruck.parsing.ImmutableLastResult;
import no.finntech.firetruck.parsing.SensuIncident;
import no.finntech.firetruck.parsing.LastResult;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.boot.test.TestRestTemplate;
import org.springframework.boot.test.WebIntegrationTest;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.client.RestTemplate;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(TestConfig.class)
@WebIntegrationTest(randomPort = true)
public class IncidentControllerTest {

    RestTemplate restTemplate = new TestRestTemplate();
    Random random = new Random();
    @Value("${local.server.port}")
    int port;

    SensuIncident testSensuIncident;

    @Before
    public void setUp() {
        LastResult lastResult = ImmutableLastResult.builder()
                .action("trigger_test")
                .addTags("tag1", "tag2")
                .addTeams("Testing team")
                .command("http POST")
                .duration(random.nextDouble())
                .executed(ZonedDateTime.now().minusSeconds(1L))
                .finnApp("finntruck")
                .finnEnv("test")
                .output("201")
                .build();
        testSensuIncident = ImmutableSensuIncident.builder()
                .checkName("TEST_WEAK")
                .dc("sensudev")
                .client("spring-boot")
                .lastExecution(ZonedDateTime.now())
                .lastResult(lastResult)
                .build();
    }


    public URI createAbsoluteUri(String relativeUrl) {
        String absUrlSt = new StringBuilder("http://localhost:")
                .append(port)
                .append(relativeUrl)
                .toString();
        return URI.create(absUrlSt);
    }
    @Test
    @Transactional
    public void successfullyImport() {
        ResponseEntity<Object> objectResponseEntity = restTemplate.postForEntity(createAbsoluteUri("/incidents/import"), testSensuIncident, null);
        assertThat(objectResponseEntity.getStatusCode()).isEqualTo(HttpStatus.CREATED);


        ResponseEntity<IncidentTag> tag = restTemplate.getForEntity(createAbsoluteUri("/api/tags/1"), IncidentTag.class);
        assertThat(tag.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(tag.getBody().getName()).isEqualTo("tag1");
    }

    @Test
    @Transactional
    public void postingSameIncidentTwiceDoesNotCauseDuplicationOfTeams() {
        ResponseEntity<Object> objectResponseEntity = restTemplate.postForEntity(createAbsoluteUri("/incidents/import"), testSensuIncident, null);
        assertThat(objectResponseEntity.getStatusCode()).isEqualTo(HttpStatus.CREATED);

        ResponseEntity<Object> response2 = restTemplate.postForEntity(createAbsoluteUri("/incidents/import"), testSensuIncident, null);
        assertThat(response2.getStatusCode()).isEqualTo(HttpStatus.CREATED);


        ResponseEntity<List<IncidentTag>> tags = restTemplate.exchange(createAbsoluteUri("/api/tags"), HttpMethod.GET, null, new ParameterizedTypeReference<List<IncidentTag>>() {});
        assertThat(tags.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(tags.getBody()).hasSize(2);

    }
}
