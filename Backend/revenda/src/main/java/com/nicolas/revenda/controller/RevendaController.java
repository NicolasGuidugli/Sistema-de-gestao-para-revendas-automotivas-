package com.nicolas.revenda.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.nicolas.revenda.entity.Revenda;
import com.nicolas.revenda.service.RevendaService;
import com.nicolas.revenda.dto.RevendaRequestDTO;
import com.nicolas.revenda.dto.RevendaResponseDTO;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/revendas")
@Tag(name = "Revendas", description = "Gerenciamento de revendas automotivas")
public class RevendaController {

    private final RevendaService revendaService;

    public RevendaController(RevendaService revendaService) {
        this.revendaService = revendaService;
    }

    @Operation(summary = "Lista todas as revendas", description = "Retorna uma lista com todas as revendas cadastradas no sistema")
    @ApiResponse(responseCode = "200", description = "Lista retornada com sucesso")
    @GetMapping
    public List<RevendaResponseDTO> listarTodas() {
        return revendaService.listarTodas()
            .stream()
            .map(RevendaResponseDTO::new)
            .collect(Collectors.toList());
    }

    @Operation(summary = "Busca revenda por ID", description = "Retorna os dados de uma revenda específica pelo seu ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Revenda encontrada com sucesso"),
        @ApiResponse(responseCode = "404", description = "Revenda não encontrada")
    })
    @GetMapping("/{id}")
    public ResponseEntity<RevendaResponseDTO> buscarPorId(
        @Parameter(description = "ID da revenda", example = "1") @PathVariable Long id) {
        return revendaService.buscarPorId(id)
            .map(revenda -> ResponseEntity.ok(new RevendaResponseDTO(revenda)))
            .orElse(ResponseEntity.notFound().build());
    }

    @Operation(summary = "Cadastra nova revenda", description = "Cria um novo registro de revenda no sistema")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Revenda cadastrada com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos ou campos obrigatórios ausentes")
    })
    @PostMapping
    public ResponseEntity<RevendaResponseDTO> criar(@Valid @RequestBody RevendaRequestDTO dto) {
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
        return ResponseEntity.status(201).body(new RevendaResponseDTO(salva));
    }

    @Operation(summary = "Atualiza uma revenda", description = "Atualiza os dados de uma revenda já cadastrada pelo seu ID")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Revenda atualizada com sucesso"),
        @ApiResponse(responseCode = "400", description = "Dados inválidos"),
        @ApiResponse(responseCode = "404", description = "Revenda não encontrada")
    })
    @PutMapping("/{id}")
    public ResponseEntity<RevendaResponseDTO> atualizar(
        @Parameter(description = "ID da revenda a ser atualizada", example = "1") @PathVariable Long id,
        @Valid @RequestBody RevendaRequestDTO dto) {
        return revendaService.buscarPorId(id)
            .map(revendaExistente -> {
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

    @Operation(summary = "Remove uma revenda", description = "Exclui permanentemente uma revenda do sistema pelo seu ID")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Revenda removida com sucesso"),
        @ApiResponse(responseCode = "404", description = "Revenda não encontrada")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(
        @Parameter(description = "ID da revenda a ser removida", example = "1") @PathVariable Long id) {
        return revendaService.buscarPorId(id)
            .map(revenda -> {
                revendaService.deletar(id);
                return ResponseEntity.noContent().<Void>build();
            })
            .orElse(ResponseEntity.notFound().build());
    }
}