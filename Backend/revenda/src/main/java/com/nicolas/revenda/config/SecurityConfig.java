package com.nicolas.revenda.config;

/* ============================================================
   CONFIGURAÇÃO TEMPORÁRIA DE DESENVOLVIMENTO
   Esta configuração libera todos os endpoints sem autenticação
   Será substituída pela configuração JWT + Cookie HttpOnly
   NÃO usar em produção
   ============================================================= */

   import org.springframework.context.annotation.Bean;
   import org.springframework.context.annotation.Configuration;
   import org.springframework.security.config.annotation.web.builders.HttpSecurity;
   import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
   import org.springframework.security.web.SecurityFilterChain;

   @Configuration // Informa ao Spring que esta classe possui configuração.
   @EnableWebSecurity // Ativa a customização da segurança

   public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
       http
       .csrf(csrf -> csrf.disable()) // Desabilita temporariamente a proteção CSRF
       .authorizeHttpRequests(auth -> auth
        .anyRequest() .permitAll() // Permite qualquer requisição sem autenticação. GET POST PUT DELETE todos funcionarão.
       );
       return http.build(); 
    }
   }