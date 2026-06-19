package com.nicolas.revenda.service;

//* Criando um CRUD
// O Service fica entre o Controller e o Repository
// Controller -> Service -> Repository -> Banco de dados

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.nicolas.revenda.entity.Revenda;
import com.nicolas.revenda.repository.RevendaRepository;

@Service // Diz ao Spring que esta classe é um Service 
public class RevendaService {

    private final RevendaRepository revendaRepository; /* O Service não acessa o banco diretamente
                                                          ele usa o Repository para isso */

    public RevendaService(RevendaRepository revendaRepository) {
        this.revendaRepository = revendaRepository; 
    }

    // Lista todas as revendas cadastradas
    public List<Revenda> listarTodas() {
        return revendaRepository.findAll(); // findAll() é um método pronto do JpaRepository
    }

    // Busca uma revenda pelo ID 
    public Optional<Revenda> buscarPorId(Long id) {
        return revendaRepository.findById(id); /* Optional evita NullPoint
                                                  se não encontrar retorna Optional.empty()
                                                  em vez de null */
    }

    // Salva uma nova revenda no banco
    public Revenda salvar(Revenda revenda) {
        validarStatusRevenda(revenda.getStatusRevenda()); // Valida o status antes de salvar
        return revendaRepository.save(revenda); // save() do JpaRepository faz o INSERT
    }

    // Atualiza uma revenda existente no banco
    public Revenda atualizar(Revenda revenda) {
        validarStatusRevenda(revenda.getStatusRevenda()); // Valida o status antes de atualizar
        return revendaRepository.save(revenda); /* save() do JpaRepository faz UPDATE
                                                   quando o objeto já tem ID preenchido */
    }

    // Remove uma revenda pelo ID
    public void deletar(Long id) {
        revendaRepository.deleteById(id); // deleteById() é um método pronto do JpaRepository
    }

    /* Valida se o status informado é um dos valores permitidos
       Os mesmos valores do CHECK constraint do banco de dados */
    private void validarStatusRevenda(String status) {
        if (status != null && !status.equals("ATIVA") &&
            !status.equals("INATIVA") &&
            !status.equals("BLOQUEADA") &&
            !status.equals("ENCERRADA")) {
            throw new IllegalArgumentException(
                "Status inválido. Use: ATIVA, INATIVA, BLOQUEADA ou ENCERRADA"
            );
        }
    }
}