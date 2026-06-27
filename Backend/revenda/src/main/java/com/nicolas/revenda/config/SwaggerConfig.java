package com.nicolas.revenda.config;

// Configuraçoes do SWAGGER para documentação da API

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
            .info(new Info()
                .title("API - Sistema de Gestão de Revendas Automotivas")
                .description("API REST para gerenciamento de veículos, clientes e vendas")
                .version("v1.0.0")
                .contact(new Contact()
                    .name("Nicolas Guidugli")
                    .url("https://github.com/NicolasGuidugli")
                )
            );
    }
}