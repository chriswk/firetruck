package no.finntech.firetruck.web;

import java.net.URI;
import java.time.ZonedDateTime;
import java.util.List;
import java.util.Random;
import javax.transaction.Transactional;

import no.finntech.firetruck.TestConfig;
import no.finntech.firetruck.jpa.domain.IncidentTag;
import no.finntech.firetruck.parsing.ImmutableLastResult;
import no.finntech.firetruck.parsing.ImmutableSensuIncident;
import no.finntech.firetruck.parsing.LastResult;
import no.finntech.firetruck.parsing.SensuIncident;

import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.boot.test.context.SpringBootTest.WebEnvironment.RANDOM_PORT;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = TestConfig.class, webEnvironment=RANDOM_PORT)
public class IncidentControllerTest {

    TestRestTemplate restTemplate = new TestRestTemplate();
    Random random = new Random();
    @Value("${local.server.port}")
    int port;

    SensuIncident testSensuIncident;
    URI importUrl;

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
        importUrl = createAbsoluteUri("/incidents/import");
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
        ResponseEntity<Object> objectResponseEntity = restTemplate.postForEntity(importUrl, testSensuIncident, null);
        assertThat(objectResponseEntity.getStatusCode()).isEqualTo(HttpStatus.CREATED);


        ResponseEntity<IncidentTag> tag = restTemplate.getForEntity(createAbsoluteUri("/api/incidenttags/1"), IncidentTag.class);
        assertThat(tag.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(tag.getBody().getName()).isEqualTo("tag1");
    }

    @Test
    @Transactional
    @Ignore("Cannot deserialize directly to list of objects, need to process the embedded information")
    public void postingSameIncidentTwiceDoesNotCauseDuplicationOfTeams() {
        ResponseEntity<Object> objectResponseEntity = restTemplate.postForEntity(importUrl, testSensuIncident, null);
        assertThat(objectResponseEntity.getStatusCode()).isEqualTo(HttpStatus.CREATED);

        ResponseEntity<Object> response2 = restTemplate.postForEntity(importUrl, testSensuIncident, null);
        assertThat(response2.getStatusCode()).isEqualTo(HttpStatus.CREATED);


        ResponseEntity<List<IncidentTag>> tags = restTemplate.exchange(createAbsoluteUri("/api/incidenttags"), HttpMethod.GET, null, new ParameterizedTypeReference<List<IncidentTag>>() {});
        assertThat(tags.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(tags.getBody()).hasSize(2);

    }
}
