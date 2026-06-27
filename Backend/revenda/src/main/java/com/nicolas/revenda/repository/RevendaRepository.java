package com.nicolas.revenda.repository;

// == Repository: camada de acesso ao banco de dados ==

/* O Repository é a ponte entre o Java e o banco de dados
   ele traduz métodos Java em queries SQL automaticamente */

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.nicolas.revenda.entity.Revenda; // Faz conexão com a entidade Revenda

public interface RevendaRepository extends JpaRepository<Revenda, Long> {
    /* JpaRepository<Revenda, Long> :

       - Revenda -> a entidade que este Repository controla
       - Long    -> o tipo da chave primária (codigo)
       
       O JpaRepository já traz dezenas de métodos prontos:

       - findAll()        -> SELECT * FROM revendas
       - findById(id)     -> SELECT * FROM revendas WHERE codigo = id
       - save(revenda)    -> INSERT ou UPDATE
       - deleteById(id)   -> DELETE FROM revendas WHERE codigo = id
       - count()          -> SELECT COUNT(*) FROM revendas
       - existsById(id)   -> SELECT EXISTS(...)
                                                                   */

    // Busca uma revenda pelo CNPJ — útil para validar duplicidade no cadastro
    Optional<Revenda> findByCnpj(String cnpj);

    // Busca uma revenda pelo status — útil para listar só as ativas
    java.util.List<Revenda> findByStatusRevenda(String statusRevenda);

    // Verifica se já existe uma revenda com esse CNPJ — útil para validação
    boolean existsByCnpj(String cnpj);
}