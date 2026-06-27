package com.nicolas.revenda.controller;

// Porta de entrada da API
// Recebe as requisições HTTP e devolve respostas
// Endpoints

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.nicolas.revenda.entity.Revenda;
import com.nicolas.revenda.service.RevendaService;

import jakarta.validation.Valid; // @Valid significa: "Antes de executar o método, valide todos os campos do DTO"

import com.nicolas.revenda.dto.RevendaRequestDTO;
import com.nicolas.revenda.dto.RevendaResponseDTO;

@RestController // Diz ao Spring que esta classe é um Controller que devolve JSON
@RequestMapping("/api/revendas") // Define o caminho base de todos os endpoints desta classe
public class RevendaController {

    private final RevendaService revendaService; // Injeta o Service — Controller não acessa o banco diretamente

    public RevendaController(RevendaService revendaService) {
        this.revendaService = revendaService; 
    }

    // Lista todas as revendas
    @GetMapping
    public List<RevendaResponseDTO> listarTodas() {
        return revendaService.listarTodas()
        .stream()
        .map(RevendaResponseDTO::new)
        .collect(Collectors.toList());
    }

    // Busca uma revenda específica pelo ID
    @GetMapping("/{id}")
    public ResponseEntity<RevendaResponseDTO> buscarPorId(@PathVariable Long id) {
        return revendaService.buscarPorId(id)
            .map(revenda -> ResponseEntity.ok(new RevendaResponseDTO(revenda))) // Se existir revenda .map executa new e devolve 200 -> OK
            .orElse(ResponseEntity.notFound().build()); // Se não existir (orElse) devolve 404 -> Not Found
    }

    // Cria uma nova revenda
    @PostMapping 
    public ResponseEntity<RevendaResponseDTO> criar(@Valid @RequestBody RevendaRequestDTO dto) { // Valida os campos do DTO e faz a Requisição POST
        Revenda revenda = new Revenda();

        revenda.setRazaoSocial(dto.getRazaoSocial());
        revenda.setNomeFantasia(dto.getNomeFantasia());
        revenda.setCnpj(dto.getCnpj());
        revenda.setTelefone(dto.getTelefone());
        revenda.setEmail(dto.getEmail());
        revenda.setEndereco(dto.getEndereco());
        revenda.setCidade(dto.getCidade());
        revenda.setEstado(dto.getEstado());
        revenda.setCep(dto.getCep());

        Revenda salva = revendaService.salvar(revenda);

        RevendaResponseDTO response = new RevendaResponseDTO(salva);
        return ResponseEntity.status(201).body(response);

        }
    

    // Atualiza uma revenda existente
    @PutMapping("/{id}")
    public ResponseEntity<RevendaResponseDTO> atualizar(
        @PathVariable Long id,
        @Valid @RequestBody RevendaRequestDTO dto) {

            return revendaService.buscarPorId(id) // primero buscamos o ID da revenda se ela existir acionamos o .map e atualizamos seus atributos.
            .map(revendaExistente -> {  // revendaExistente = Para atualizar somente uma revenda já cadastrada.

                revendaExistente.setRazaoSocial(dto.getRazaoSocial());
                revendaExistente.setNomeFantasia(dto.getNomeFantasia());
                revendaExistente.setCnpj(dto.getCnpj());
                revendaExistente.setTelefone(dto.getTelefone());
                revendaExistente.setEmail(dto.getEmail());
                revendaExistente.setEndereco(dto.getEndereco());
                revendaExistente.setCidade(dto.getCidade());
                revendaExistente.setEstado(dto.getEstado());
                revendaExistente.setCep(dto.getCep());

                Revenda atualizada = revendaService.atualizar(revendaExistente);

                return ResponseEntity.ok(new RevendaResponseDTO(atualizada));

            })

                .orElse(ResponseEntity.notFound().build());

        }


    // Destroi uma revenda :(
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        
        return revendaService.buscarPorId(id)  
            .map(revenda -> {
                revendaService.deletar(id);
                return ResponseEntity.noContent().<Void>build();  // Se a revenda existir devolve 200 Ok "A operação foi realizada com sucesso"
            })
             
            .orElse(ResponseEntity.notFound().build()); // Se não existir erro 404 Not Found. Sem retorno.
    }

}