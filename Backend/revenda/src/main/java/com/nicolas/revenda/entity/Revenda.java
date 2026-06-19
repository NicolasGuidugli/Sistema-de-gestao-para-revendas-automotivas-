package com.nicolas.revenda.entity; // Declara o pacote da classe

//! Colocando POO em pratica !//

// == Transformando Revenda em Entity (Entidade) ==

import jakarta.persistence.*; // Importar ferramentas de banco de dados do JPA
import java.time.LocalDateTime;
import java.util.UUID;

@Entity // Diz ao Spring "esta classe representa uma tabela do banco"
@Table(name = "revendas") // Diz qual tabela ela representa
public class Revenda {

    @Id // Indica a chave primária PK
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Diz que o banco vai gerar automaticamente o valor (SERIAL)
    @Column(name = "codigo") // Mapeia para a coluna "codigo" do banco
    private Long codigo;

    public Long getCodigo() {
        return codigo; // Getter: permite ler o valor do atributo privado codigo
    }

    public void setCodigo(Long codigo) {
        this.codigo = codigo; // Setter: this.codigo é o atributo da classe, codigo é o parâmetro recebido
    }

    // UUID gerado automaticamente — usado no frontend para nunca expor o ID numérico
    @Column(name = "uuid_revenda", nullable = false, unique = true)
    private UUID uuidRevenda;

    public UUID getUuidRevenda() {
        return uuidRevenda;
    }

    public void setUuidRevenda(UUID uuidRevenda) {
        this.uuidRevenda = uuidRevenda;
    }

    // Column = Colunas da minha tabela do banco, Length = VARCHAR
    @Column(name = "razao_social", nullable = false, length = 150)
    private String razaoSocial;

    public String getRazaoSocial() {
        return razaoSocial; // Getter: retorna o valor armazenado em razaoSocial
    }

    public void setRazaoSocial(String razaoSocial) {
        this.razaoSocial = razaoSocial; // Setter: this.razaoSocial é o atributo da classe, razaoSocial é o parâmetro recebido
    }

    @Column(name = "nome_fantasia", nullable = false, length = 150)
    private String nomeFantasia;

    public String getNomeFantasia() {
        return nomeFantasia;
    }

    public void setNomeFantasia(String nomeFantasia) {
        this.nomeFantasia = nomeFantasia;
    }

    @Column(name = "cnpj", nullable = false, unique = true, length = 18)
    private String cnpj;

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    @Column(name = "telefone", length = 20)
    private String telefone; /* Private significa que a variável só pode ser acessada
                                diretamente dentro da própria classe */

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    @Column(name = "email", length = 150)
    private String email;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Column(name = "endereco", length = 260)
    private String endereco;

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    @Column(name = "cidade", length = 150)
    private String cidade;

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    @Column(name = "estado", length = 2)
    private String estado;

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    @Column(name = "cep", length = 9)
    private String cep;

    public String getCep() {
        return cep;
    }

    public void setCep(String cep) {
        this.cep = cep;
    }

    @Column(name = "status_revenda", nullable = false, length = 20)
    private String statusRevenda = "ATIVA"; /* Valor padrão ATIVA — toda revenda
                                               começa ativa ao ser cadastrada */

    public String getStatusRevenda() {
        return statusRevenda;
    }

    public void setStatusRevenda(String statusRevenda) {
        this.statusRevenda = statusRevenda;
    }

    // data_cadastro é preenchida automaticamente pelo @PrePersist
    @Column(name = "data_cadastro", nullable = false)
    private LocalDateTime dataCadastro;

    public LocalDateTime getDataCadastro() {
        return dataCadastro;
    }

    public void setDataCadastro(LocalDateTime dataCadastro) {
        this.dataCadastro = dataCadastro;
    }

    /* @PrePersist é executado automaticamente pelo JPA antes de salvar
       um novo registro no banco — perfeito para preencher datas e UUID */
    @PrePersist
    public void prePersist() {
        this.dataCadastro = LocalDateTime.now(); // Preenche a data de cadastro automaticamente
        if (this.uuidRevenda == null) {
            this.uuidRevenda = UUID.randomUUID(); // Gera UUID automaticamente se não foi informado
        }
    }
}

