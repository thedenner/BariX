package barix.com.br.repository;

import barix.com.br.entity.Item;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ItemRepository extends JpaRepository<Item, Integer> {

    boolean existsByNomeIgnoreCaseAndIdNot(String nome, Integer id);

    boolean existsByNomeIgnoreCase(String nome);

    long countByQuantidadeLessThan(Integer quantidade);

    List<Item> findByQuantidadeLessThanOrderByQuantidadeAsc(Integer quantidade);

    @Query("""
            SELECT i
            FROM Item i
            LEFT JOIN i.category c

            WHERE
                (
                    :nome IS NULL
                    OR LOWER(i.nome)
                    LIKE LOWER(CONCAT('%', :nome, '%'))
                )

                AND
                (
                    :categoriaId IS NULL
                    OR c.id = :categoriaId
                )

                AND
                (
                    :status IS NULL

                    OR (
                        :status = 'ALERTA'
                        AND i.quantidade < :limite
                    )

                    OR (
                        :status = 'NORMAL'
                        AND i.quantidade >= :limite
                    )
                )

            ORDER BY i.nome ASC
            """)//faz uma busca no SQL
    List<Item> filtrar(

            @Param("nome")
            String nome,

            @Param("categoriaId")
            Integer categoriaId,

            @Param("status")
            String status,

            @Param("limite")
            Integer limite

    );
}