package com.nicolas.revenda.dto;

// === DTO Response para Revenda ===
// Define quais os campos que o backend vai devolver para o frontend.

import java.time.LocalDateTime;
import java.util.UUID;

import com.nicolas.revenda.entity.Revenda;

public class RevendaResponseDTO {
    
    private Long codigo;
    private UUID uuidRevenda;
    private String razaoSocial;
    private String nomeFantasia;
    private String cnpj;
    private String telefone;
    private String email;
    private String endereco;
    private String cidade;
    private String estado;
    private String cep;
    private String statusRevenda;
    private LocalDateTime dataCadastro;

    // ============================================================
    // Construtor vazio — obrigatório para o Spring conseguir
    // instanciar o objeto automaticamente
    // ============================================================

    public RevendaResponseDTO() {}

    // ============================================================
    // Construtor que recebe uma Entity Revenda e preenche o DTO
    // Usado no Controller para converter Entity para DTO
    // Em vez de devolver a Entity direto, devolvemos o DTO
    // ============================================================

    public RevendaResponseDTO(Revenda revenda) {

        this.codigo = revenda.getCodigo();
        this.uuidRevenda = revenda.getUuidRevenda();
        this.razaoSocial = revenda.getRazaoSocial();
        this.nomeFantasia = revenda.getNomeFantasia();
        this.cnpj = revenda.getCnpj();
        this.telefone = revenda.getTelefone();
        this.email = revenda.getEmail();
        this.endereco = revenda.getEndereco();
        this.cidade = revenda.getCidade();
        this.estado = revenda.getEstado();
        this.cep = revenda.getCep();
        this.statusRevenda = revenda.getStatusRevenda();
        this.dataCadastro = revenda.getDataCadastro();
    }

    // === GETTERS e SETTERS ===
    // GETTER = Permite ler o valor do atributo privado.
    // SETTER = Permite alterar o valor do atributo privado.

    public Long getCodigo() { return codigo; }
    public void setCodigo(Long codigo) { this.codigo = codigo; }

    public UUID getUuidRevenda() { return uuidRevenda; }
    public void setUuidRevenda(UUID uuidRevenda) { this.uuidRevenda = uuidRevenda; }

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

    public String getStatusRevenda() { return statusRevenda; }
    public void setStatusRevenda(String statusRevenda) { this.statusRevenda = statusRevenda; }

    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }


}
