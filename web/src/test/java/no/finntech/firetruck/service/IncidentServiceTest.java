package no.finntech.firetruck.service;

import java.time.ZonedDateTime;
import java.util.Arrays;
import java.util.Optional;
import java.util.Random;
import javax.transaction.Transactional;

import no.finntech.firetruck.TestConfig;
import no.finntech.firetruck.jpa.domain.Incident;
import no.finntech.firetruck.jpa.domain.IncidentTag;
import no.finntech.firetruck.jpa.repository.IncidentRepository;
import no.finntech.firetruck.jpa.repository.IncidentTagRepository;
import no.finntech.firetruck.jpa.repository.TeamRepository;
import no.finntech.firetruck.parsing.ImmutableLastResult;
import no.finntech.firetruck.parsing.ImmutableSensuIncident;
import no.finntech.firetruck.parsing.LastResult;
import no.finntech.firetruck.parsing.SensuIncident;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.test.context.junit4.SpringRunner;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest(classes = TestConfig.class)
public class IncidentServiceTest {

    @Autowired
    IncidentService incidentService;

    @Autowired
    TeamRepository teamRepository;

    @Autowired
    IncidentTagRepository incidentTagRepository;

    @Autowired
    IncidentRepository incidentRepository;

    SensuIncident testSensuIncident;

    @Before
    public void setUp() {
        Random random = new Random();
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

    @Test
    @Transactional
    public void canSaveASingleIncident() {
        incidentService.save(testSensuIncident);
        incidentService.findAll().forEach(inc -> {
            assertThat(inc.getDc()).isEqualTo("sensudev");
            assertThat(inc.getClient()).isEqualTo("spring-boot");
        });
    }

    @Test
    @Transactional
    public void teamNamesAreUnique() {
        incidentService.save(testSensuIncident);
        incidentService.save(testSensuIncident);

        assertThat(teamRepository.findAll()).hasSize(1);
    }

    @Test
    @Transactional
    public void tagNamesAreUnique() {
        incidentService.save(testSensuIncident);
        incidentService.save(testSensuIncident);

        assertThat(incidentTagRepository.findAll()).hasSize(2);
    }

    @Test
    @Transactional
    public void canFindIncidentsViaTheirTag() {
        ImmutableLastResult extraResult = ImmutableLastResult.builder()
                .action("trigger_test")
                .addTags("firetruck", "database")
                .addTeams("Testing team")
                .command("http POST")
                .duration(new Random().nextDouble())
                .executed(ZonedDateTime.now().minusSeconds(1L))
                .finnApp("firetruck")
                .finnEnv("test")
                .output("201")
                .build();
        incidentService.save(testSensuIncident);
        ImmutableSensuIncident testIncident2 = ImmutableSensuIncident.copyOf(testSensuIncident).withLastResult(extraResult);
        incidentService.save(testIncident2);
        Optional<IncidentTag> databaseTag = incidentTagRepository.findByName("database");
        assertThat(databaseTag).isPresent();
        assertThat(databaseTag).hasValueSatisfying((i) -> assertThat(i.getIncidents()).hasSize(1));

        Page<Incident> byIncidentTags = incidentRepository.findByTags(Arrays.asList(databaseTag.get()), new PageRequest(0, 5));
        assertThat(byIncidentTags).hasSize(1);
        assertThat(byIncidentTags.getContent().get(0).getCommand()).isEqualTo("http POST");
    }


}
