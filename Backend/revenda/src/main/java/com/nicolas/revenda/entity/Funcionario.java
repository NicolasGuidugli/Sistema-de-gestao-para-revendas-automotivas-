package com.nicolas.revenda.entity;

import jakarta.persistence.*;
import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonBackReference;


@Entity
@Table(name = "funcionarios")
public class Funcionario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "codigo")
    private Long codigo;

    public Long getCodigo(){
        return codigo;
    }
    
    public void setCodigo(Long codigo) {
        this.codigo = codigo;
    }

    @Column(name = "nome", nullable = false, length = 100)
    private String nome;

    public String getNome(){
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    @Column(name = "cpf", nullable = false, unique = true, length = 14)
    private String cpf;

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    @Column(name = "telefone", length = 20)
    private String telefone;

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    @Column(name = "email", unique = true, length = 100)
    private String email;

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Column(name = "cargo", nullable = false, length = 100)
    private String cargo;

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    @Column(name = "status_funcionario", nullable = false, length = 20)
    private String statusFuncionario = "Ativo";

    public String getStatusFuncionario() {
        return statusFuncionario;
    }

    public void setStatusFuncionario(String statusFuncionario) {
        this.statusFuncionario = statusFuncionario;
    }

    @Column(name = "data_admissao")
    private LocalDate dataAdmissao;

    public LocalDate getDataAdmissao()  {
        return dataAdmissao;
    }

    public void setDataAdmissao(LocalDate dataAdmissao) {
        this.dataAdmissao = dataAdmissao;
    }

    @ManyToOne(fetch = FetchType.LAZY)  // ManyToOne = Siginifica: Muitos para 1 N:1 ou seja "Muitos funcionarios para uma única revenda"
    @JoinColumn(                        // fetch = FetchType.LAZY : Só carregue a Revenda quando eu realmente precisar dela
        name = "revenda_codigo",        // JoinColumn = Use a Coluna revenda_codigo da tabela Funcionarios para fazer a ligação.
        nullable = false
    )

    @JsonBackReference
    private Revenda revenda;

    public Revenda getRevenda() {
        return revenda;
    }

    public void setRevenda(Revenda revenda) {
        this.revenda = revenda;
    }

}
