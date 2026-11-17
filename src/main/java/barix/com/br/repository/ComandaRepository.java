package barix.com.br.repository;

import barix.com.br.entity.Comanda;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ComandaRepository extends JpaRepository<Comanda, Integer> {

    List<Comanda> findTop6ByStatusOrderByDataAberturaDesc(String status);

    List<Comanda> findByStatusOrderByDataAberturaDesc(String status);

    long countByStatus(String status);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT c FROM Comanda c WHERE c.id = :id")
    Optional<Comanda> buscarParaAtualizar(
            @Param("id") Integer id
    );
}