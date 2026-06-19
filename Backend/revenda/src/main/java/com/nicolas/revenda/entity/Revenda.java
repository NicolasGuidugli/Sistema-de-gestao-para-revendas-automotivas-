package com.nicolas.revenda.entity; // Declara o pacote da classe

// == Transformando Revenda em Entity (Entidade) ==

import java.time.LocalDateTime;
import jakarta.persistence.*; // Importar ferramentas de banco de dados do JPA

@Entity // Diz ao spring "esta classe representa uma tabela do banco"
@Table(name = "revendas") // Diz qual tabela ela representa
public class Revenda {

    @Id // Indica a cahve primária PK
    @GeneratedValue(strategy = GenerationType.IDENTITY) // Diz que o banco vai gerar automaticamente o valor ou Serial
    private Long id;

    public Long getId() {
        return id;
    }

    public void setId(Long id){
        this.id = id;
    }

    //Column = Colunas da minha tabela do banco, Length = VARCHAR
    @Column(name = "nome", nullable = false, length = 150)
    private String nome;

    public String getNome() {
        return nome; /* Utilizando Getters e Setters, oque é um getter? Um getter é um método que permite ler um atributo privado 
         Exemplo: Quando alguem chamar Nome o valor armazenado em nome será retornado.*/ 
    }                      

    public void setNome(String nome) { /* Oque é um Setter? Um setter permite alterar um atributo privado. Exemplo quando alguem fizer revenda.setNome("Revenda Premium") o atributo nome receberá esse valor. */
        this.nome = nome; /* Oque significa this.nome é o atributo da classe, ja o = nome é o parametro recebido pelo método. */
    }

    @Column(name = "cnpj", nullable = false, unique = true, length = 18)
    private String cnpj;

    public String getCnpj() {
        return cnpj;
    }

    public void setCnpj(String cnpj) {
        this.cnpj = cnpj;
    }

    @Column(name = "email", length = 150)
    private String email;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Column(name = "telefone", length = 20)
    private String telefone; /*String = Texto, é o atributo (campo) da classe
    Private significa que a variavel só pode ser acessada diretamente dentro da própria classe. 
    telefone é o nome da variavel que guardara o valor */ 
    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    @Column(name = "ativo", nullable = false)
    private Boolean ativo = true;
    
    public Boolean getAtivo() {
        return ativo;
    }

    public void setAtivo(Boolean ativo) {
        this.ativo = ativo;
    }

    @Column(name = "criado_em", nullable = false)
    private LocalDateTime criadoEm;

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(LocalDateTime criadoEm) {
        this.criadoEm = criadoEm;
    }

    @Column(name = "atualizado_em")
    private LocalDateTime atualizadoEm;

    public LocalDateTime getAtualizadoEm() {
        return atualizadoEm;
    }

    public void setAtualizadoEm(LocalDateTime atualizadoEm) {
        this.atualizadoEm = atualizadoEm;
    }

    /* @PrePersist e @PreUpdate é um recurso muito útil do JPA/Hibernate.
     Eles servem para preencher datas automaticamente quando um registro é criado ou atualizado no banco. */
    @PrePersist
    public void prePersist() {                                    
        this.criadoEm = LocalDateTime.now();
        this.atualizadoEm = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        this.atualizadoEm = LocalDateTime.now();
    }

}



