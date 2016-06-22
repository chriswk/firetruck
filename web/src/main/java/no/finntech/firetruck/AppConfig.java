package no.finntech.firetruck;

import javax.sql.DataSource;

import no.finntech.commons.ConstrettoFileToMapHelper;
import no.finntech.commons.db.PostgreSQLDataSourceBuilder;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@SpringBootApplication(scanBasePackages = "no.finntech.firetruck")
public class AppConfig {

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true); // you USUALLY want this
        config.addAllowedOrigin("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("GET");
        config.addAllowedMethod("PUT");
        config.addAllowedMethod("POST");
        config.addAllowedMethod("PATCH");
        config.addAllowedMethod("OPTIONS");
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }

    @Bean
    @Primary
    public DataSource dataSource() {
        return new PostgreSQLDataSourceBuilder()
                .withDatabase("firetruck")
                .withFallbackConfiguration(ConstrettoFileToMapHelper.fromIni("classpath:database.ini"))
                .build();
    }
}
