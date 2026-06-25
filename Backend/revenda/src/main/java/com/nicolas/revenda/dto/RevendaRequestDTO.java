package com.nicolas.revenda.dto;

// === DTO Request para Revenda ===
// Define quais campos o frontend pode enviar ao criar ou atualizar uma revenda

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class RevendaRequestDTO {

    @NotBlank(message = "Razão social é obrigatória")
    @Size(max = 150, message = "Razão social deve ter no máximo 150 caracteres")
    private String razaoSocial;

    @NotBlank(message = "Nome fantasia é obrigatório")
    @Size(max = 150, message = "Nome fantasia deve ter no máximo 150 caracteres")
    private String nomeFantasia;

    @NotBlank(message = "CNPJ é obrigatório")
    @Pattern(regexp = "\\d{2}\\.\\d{3}\\.\\d{3}/\\d{4}-\\d{2}", message = "CNPJ deve estar no formato 00.000.000/0000-00")
    private String cnpj;

    @Size(max = 20, message = "Telefone deve ter no máximo 20 caracteres")
    private String telefone;

    @Email(message = "Email inválido")
    @Size(max = 150, message = "Email deve ter no máximo 150 caracteres")
    private String email;

    
    @Size(max = 260, message = "Endereço deve ter no  máximo 260 caracteres")
    private String endereco;

    @Size(max = 150, message = "Cidade deve ter no máximo 150 caracteres")
    private String cidade;

    @Size(max = 2, message = "Estado deve possuir apenas 2 caracteres")
    private String estado;

    @Pattern(regexp = "^\\d{5}-\\d{3}$", message = "CEP deve estar no formato 00000-000")
    private String cep; // regexp = aceita 95900-000 e rejeita 9590000

    //==========================================================
    // GETTERS e SETTERS
    // Sem eles o Spring não consegue ler os dados da requisição.
    //==========================================================

    public String getRazaoSocial() {return razaoSocial;}
    public void  setRazaoSocial(String razaoSocial) { this.razaoSocial = razaoSocial; }
    
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