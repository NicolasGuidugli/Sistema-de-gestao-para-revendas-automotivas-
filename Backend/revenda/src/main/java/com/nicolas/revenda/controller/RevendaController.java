package com.nicolas.revenda.controller;

//* Porta de entrada da API
// Recebe as requisições HTTP e devolve respostas

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
    public List<Revenda> listarTodas() {
        return revendaService.listarTodas();
    }

    // Busca uma revenda específica pelo ID
    @GetMapping("/{id}")
    public ResponseEntity<Revenda> buscarPorId(@PathVariable Long id) {
        return revendaService.buscarPorId(id)
            .map(ResponseEntity::ok) // Se encontrou → retorna 200 OK com a revenda
            .orElse(ResponseEntity.notFound().build()); // Se não encontrou → retorna 404
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
    public ResponseEntity<Revenda> atualizar(
        @PathVariable Long id,
        @RequestBody Revenda revenda) {

        return revendaService.buscarPorId(id)
            .map(existente -> {
                revenda.setCodigo(id); // Garante que o ID correto será usado na atualização
                return ResponseEntity.ok(revendaService.atualizar(revenda));
            })
            .orElse(ResponseEntity.notFound().build()); // Se não encontrou → retorna 404
    }

    // Destroi uma revenda :(
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
    if (!revendaService.buscarPorId(id).isPresent()) {
        return ResponseEntity.notFound().build(); // 404 se não encontrou
    }
    revendaService.deletar(id);
    return ResponseEntity.noContent().build(); // 204 No Content — deletado com sucesso
    }

}