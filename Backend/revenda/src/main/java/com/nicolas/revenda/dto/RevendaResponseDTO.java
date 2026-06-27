package com.nicolas.revenda.dto;

// === DTO Response para Revenda ===
// Define quais os campos que o backend vai devolver para o frontend.

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDateTime;
import java.util.UUID;
import com.nicolas.revenda.entity.Revenda;

@Schema(description = "Dados retornados pela API após operações com revendas")
public class RevendaResponseDTO {

    @Schema(description = "ID interno da revenda", example = "1")
    private Long codigo;

    @Schema(description = "UUID único da revenda — use este para integrações externas", example = "550e8400-e29b-41d4-a716-446655440000")
    private UUID uuidRevenda;

    @Schema(description = "Razão social", example = "Guidugli Veículos Ltda")
    private String razaoSocial;

    @Schema(description = "Nome fantasia", example = "Guidugli Motors")
    private String nomeFantasia;

    @Schema(description = "CNPJ", example = "12.345.678/0001-99")
    private String cnpj;

    @Schema(description = "Telefone", example = "(54) 99999-0000")
    private String telefone;

    @Schema(description = "E-mail", example = "contato@guiduglimotos.com.br")
    private String email;

    @Schema(description = "Endereço", example = "Rua das Acácias, 123")
    private String endereco;

    @Schema(description = "Cidade", example = "Caxias do Sul")
    private String cidade;

    @Schema(description = "Estado (UF)", example = "RS")
    private String estado;

    @Schema(description = "CEP", example = "95012-000")
    private String cep;

    @Schema(description = "Status atual da revenda", example = "ATIVA", allowableValues = {"ATIVA", "INATIVA", "BLOQUEADA", "ENCERRADA"})
    private String statusRevenda;

    @Schema(description = "Data e hora do cadastro — preenchida automaticamente", example = "2025-06-27T03:10:00")
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

    // ====== GETTER e SETTER ======
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