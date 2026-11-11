package barix.com.br.repository;

import barix.com.br.entity.Comanda;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ComandaRepository
        extends JpaRepository<Comanda, Integer> {

    List<Comanda> findByStatusOrderByDataAberturaDesc(
            String status
    );

    long countByStatus(String status);
}