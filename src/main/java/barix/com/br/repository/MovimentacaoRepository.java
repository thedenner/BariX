
package barix.com.br.repository;

import barix.com.br.entity.Movimentacao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MovimentacaoRepository
        extends JpaRepository<Movimentacao, Integer> {

    @EntityGraph(
            attributePaths = {
                    "item",
                    "funcionario",
                    "comanda"
            }
    )
    Page<Movimentacao> findAllByOrderByDataHoraDescIdDesc(
            Pageable pageable
    );
}
