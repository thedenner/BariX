package barix.com.br.config;

import jakarta.servlet.DispatcherType;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.DelegatingPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.crypto.password.Pbkdf2PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

import java.util.Map;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {

        PasswordEncoder pbkdf2 =
                new Pbkdf2PasswordEncoder(
                        "",
                        16,
                        600_000,
                        Pbkdf2PasswordEncoder
                                .SecretKeyFactoryAlgorithm
                                .PBKDF2WithHmacSHA256
                );

        return new DelegatingPasswordEncoder(
                "pbkdf2-v1",
                Map.of("pbkdf2-v1", pbkdf2)
        );
    }


    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http
    ) throws Exception {

        http.authorizeHttpRequests(auth -> auth

                .dispatcherTypeMatchers(
                        DispatcherType.FORWARD,
                        DispatcherType.ERROR
                ).permitAll()

                .requestMatchers(
                        "/login",
                        "/cadastro",
                        "/bootstrap/**",
                        "/css/**",
                        "/js/**",
                        "/images/**",
                        "/favicon.ico"
                ).permitAll()

                .anyRequest().authenticated()

        ).formLogin(login -> login

                .loginPage("/login")
                .loginProcessingUrl("/login")

                .usernameParameter("usuario")
                .passwordParameter("senha")

                .defaultSuccessUrl("/", true)
                .failureUrl("/login?erro=true")

                .permitAll()

        ).logout(logout -> logout

                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout=true")
                .invalidateHttpSession(true)

                .permitAll()
        );

        return http.build();
    }
}