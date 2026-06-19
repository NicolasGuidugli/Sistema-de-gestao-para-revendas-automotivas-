package com.nicolas.revenda.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.nicolas.revenda.entity.Revenda;

public interface RevendaRepository extends JpaRepository<Revenda, Long> {
    
}
