package com.nicolas.revenda.repository;

import com.nicolas.revenda.entity.Funcionario;

import java.util.Optional;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FuncionarioRepository extends JpaRepository<Funcionario, Long> {

    // Buscar funcionario pelo CPF
    Optional<Funcionario> findByCpf(String cpf);

    // Verificar se já existe funcionario com esse CPF
    boolean existsByCpf(String cpf);

    // Buscar funcionarios pelo status
    List<Funcionario> findByStatusFuncionario(String statusFuncionario);
}