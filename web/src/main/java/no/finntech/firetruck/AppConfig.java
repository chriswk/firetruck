package no.finntech.firetruck;

import javax.sql.DataSource;

import no.finntech.commons.ConstrettoFileToMapHelper;
import no.finntech.commons.db.PostgreSQLDataSourceBuilder;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class AppConfig {

    @Bean
    public DataSource dataSource() {
        if (System.getenv("JDBC_DATABASE_URL") != null) {
            return DataSourceBuilder.create()
                    .driverClassName("org.postgresql.Driver")
                    .url(System.getenv("JDBC_DATABASE_URL"))
                    .build();
        }
        return new PostgreSQLDataSourceBuilder()
                .withDatabase("firetruck")
                .withFallbackConfiguration(ConstrettoFileToMapHelper.fromIni("classpath:database.ini"))
                .build();
    }

}
