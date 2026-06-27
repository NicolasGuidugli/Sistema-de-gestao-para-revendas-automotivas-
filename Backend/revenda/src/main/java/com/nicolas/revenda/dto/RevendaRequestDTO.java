package com.nicolas.revenda.dto;

// === DTO Request para Revenda ===
// Define quais campos o frontend pode enviar ao criar ou atualizar uma revenda

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;

@Schema(description = "Dados enviados para criar ou atualizar uma revenda")
public class RevendaRequestDTO {

    @Schema(description = "Razão social da empresa", example = "Guidugli Veículos Ltda")
    @NotBlank(message = "Razão social é obrigatória")
    @Size(max = 150)
    private String razaoSocial;

    @Schema(description = "Nome fantasia da revenda", example = "Guidugli Motors")
    @NotBlank(message = "Nome fantasia é obrigatório")
    @Size(max = 150)
    private String nomeFantasia;

    @Schema(description = "CNPJ no formato 00.000.000/0000-00", example = "12.345.678/0001-99")
    @NotBlank(message = "CNPJ é obrigatório")
    @Pattern(regexp = "\\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}-\\d{2}", message = "CNPJ deve estar no formato 00.000.000/0000-00")
    private String cnpj;

    @Schema(description = "Telefone de contato", example = "(54) 99999-0000")
    @Size(max = 20)
    private String telefone;

    @Schema(description = "E-mail da revenda", example = "contato@guiduglimotos.com.br")
    @Email(message = "Email inválido")
    @Size(max = 150)
    private String email;

    @Schema(description = "Endereço completo", example = "Rua das Acácias, 123")
    @Size(max = 260)
    private String endereco;

    @Schema(description = "Cidade", example = "Caxias do Sul")
    @Size(max = 150)
    private String cidade;

    @Schema(description = "Sigla do estado (UF)", example = "RS")
    @Size(max = 2)
    private String estado;

    @Schema(description = "CEP no formato 00000-000", example = "95012-000")
    @Pattern(regexp = "^\\d{5}-\\d{3}$", message = "CEP deve estar no formato 00000-000")
    private String cep;

    //==========================================================
    // GETTERS e SETTERS
    // Sem eles o Spring não consegue ler os dados da requisição.
    //==========================================================

    public String getRazaoSocial() { return razaoSocial; }
    public void setRazaoSocial(String razaoSocial) { this.razaoSocial = razaoSocial; }
    public String getNomeFantasia() { return nomeFantasia; }
    public void setNomeFantasia(String nomeFantasia) { this.nomeFantasia = nomeFantasia; }
    public String getCnpj() { return cnpj; }
    public void setCnpj(String cnpj) { this.cnpj = cnpj; }
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }
    public String getCidade() { return cidade; }
    public void setCidade(String cidade) { this.cidade = cidade; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    public String getCep() { return cep; }
    public void setCep(String cep) { this.cep = cep; }
}