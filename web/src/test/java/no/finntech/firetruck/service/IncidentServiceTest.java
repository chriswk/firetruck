package no.finntech.firetruck.service;

import java.time.ZonedDateTime;
import java.util.Optional;
import java.util.Random;
import javax.transaction.Transactional;

import no.finntech.firetruck.TestConfig;
import no.finntech.firetruck.domain.IncidentTag;
import no.finntech.firetruck.parsing.ImmutableLastResult;
import no.finntech.firetruck.parsing.ImmutableSensuIncident;
import no.finntech.firetruck.parsing.LastResult;
import no.finntech.firetruck.parsing.SensuIncident;
import no.finntech.firetruck.repository.IncidentRepository;
import no.finntech.firetruck.repository.TagRepository;
import no.finntech.firetruck.repository.TeamRepository;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = TestConfig.class)
public class IncidentServiceTest {

    @Autowired
    IncidentService incidentService;

    @Autowired
    TeamRepository teamRepository;

    @Autowired
    TagRepository tagRepository;

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

        assertThat(tagRepository.findAll()).hasSize(2);
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
        incidentService.save(testIncident2);
        Optional<IncidentTag> databaseTag = tagRepository.findByName("database");
        assertThat(databaseTag).isPresent();
        assertThat(databaseTag).hasValueSatisfying((i) -> assertThat(i.getIncidents()).hasSize(1));
    }

}
