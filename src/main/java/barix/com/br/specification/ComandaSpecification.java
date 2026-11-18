
package barix.com.br.specification;

import barix.com.br.dto.ComandaFiltroDTO;
import barix.com.br.entity.Comanda;

import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;

import org.springframework.data.jpa.domain.Specification;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public final class ComandaSpecification {

    private ComandaSpecification() {
    }

    public static Specification<Comanda> filtrar(ComandaFiltroDTO filtro, String statusComanda) {

        return (root, query, cb) -> {

            List<Predicate> condicoes = new ArrayList<>();


            // 1. FILTRO POR STATUS

            condicoes.add(cb.equal(root.get("status"), statusComanda));

            // 2. FILTRO POR NOME DO CLIENTE

            if (filtro.getCliente() != null && !filtro.getCliente().isBlank()) {

                String nome = filtro.getCliente()
                        .trim()
                        .toLowerCase(Locale.ROOT)
                        .replace("!", "!!")
                        .replace("%", "!%")
                        .replace("_", "!_");

                condicoes.add(
                        cb.like(
                                cb.lower(
                                        root.<String>get("nomeCliente")
                                ),
                                "%" + nome + "%",
                                '!'
                        )
                );
            }


            // 3. DEFINE QUAL DATA SERÁ PESQUISADA

            Path<LocalDateTime> campoData =
                    root.get(
                            "FECHADA".equals(statusComanda)
                                    ? "dataFechamento"
                                    : "dataAbertura"
                    );


            // 4. FILTRO POR DATA INICIAL

            if (filtro.getDataInicial() != null) {

                condicoes.add(
                        cb.greaterThanOrEqualTo(
                                campoData,
                                filtro.getDataInicial()
                                        .atStartOfDay()
                        )
                );
            }


            // 5. FILTRO POR DATA FINAL

            if (filtro.getDataFinal() != null) {

                condicoes.add(
                        cb.lessThan(
                                campoData,
                                filtro.getDataFinal()
                                        .plusDays(1)
                                        .atStartOfDay()
                        )
                );
            }


            // 6. COMBINA TODAS AS CONDIÇÕES

            return cb.and(condicoes.toArray(Predicate[]::new));
        };
    }
}
