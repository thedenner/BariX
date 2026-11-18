package barix.com.br.repository;

import barix.com.br.entity.ComandaItem;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;

public interface ComandaItemRepository extends JpaRepository<ComandaItem, Integer> {

    List<ComandaItem> findByComandaId(Integer comandaId);

    Optional<ComandaItem> findByIdAndComanda_Id(Integer id, Integer comandaId);

    List<ComandaItem> findByComanda_IdIn(
            Collection<Integer> comandaIds
    );


    @Query("""
    SELECT i.nome, cat.nome, SUM(ci.quantidade),
           SUM(ci.precoUnitario * ci.quantidade), cat.id

    FROM ComandaItem ci

    JOIN ci.comanda c
    JOIN ci.item i
    LEFT JOIN i.category cat

    WHERE c.status = 'FECHADA'

      AND c.dataFechamento >= :inicio
      AND c.dataFechamento < :fim

      AND (:categoriaId IS NULL OR cat.id = :categoriaId)
      AND (:itemId IS NULL OR i.id = :itemId)

    GROUP BY i.id, i.nome, cat.id, cat.nome

    ORDER BY SUM(ci.precoUnitario * ci.quantidade) DESC,
             i.id ASC
    """)
    List<Object[]> agruparReceitaPorItem(
            @Param("inicio") LocalDateTime inicio,
            @Param("fim") LocalDateTime fim,
            @Param("categoriaId") Integer categoriaId,
            @Param("itemId") Integer itemId
    );


    @Query("""
    SELECT COUNT(DISTINCT c.id)

    FROM ComandaItem ci

    JOIN ci.comanda c
    JOIN ci.item i
    LEFT JOIN i.category cat

    WHERE c.status = 'FECHADA'

      AND c.dataFechamento >= :inicio
      AND c.dataFechamento < :fim

      AND (:categoriaId IS NULL OR cat.id = :categoriaId)
      AND (:itemId IS NULL OR i.id = :itemId)
    """)
    Long contarComandasFechadas(
            @Param("inicio") LocalDateTime inicio,
            @Param("fim") LocalDateTime fim,
            @Param("categoriaId") Integer categoriaId,
            @Param("itemId") Integer itemId
    );


}