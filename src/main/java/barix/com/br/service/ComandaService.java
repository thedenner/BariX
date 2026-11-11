package barix.com.br.service;

import barix.com.br.entity.Comanda;
import barix.com.br.entity.ComandaItem;
import barix.com.br.repository.ComandaItemRepository;
import barix.com.br.repository.ComandaRepository;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@Service
public class ComandaService {

    private static final String STATUS_ABERTA = "ABERTA";

    private final ComandaRepository comandaRepository;
    private final ComandaItemRepository comandaItemRepository;


    public ComandaService(
            ComandaRepository comandaRepository,
            ComandaItemRepository comandaItemRepository
    ) {

        this.comandaRepository = comandaRepository;
        this.comandaItemRepository = comandaItemRepository;
    }

    public List<Comanda> listarTodas() {

        return comandaRepository.findAll();
    }


    /*
     * Cria uma nova comanda.
     */
    public Comanda abrirComanda(String nomeCliente) {

        if (nomeCliente == null || nomeCliente.isBlank()) {

            throw new IllegalArgumentException(
                    "O nome do cliente é obrigatório."
            );
        }


        Comanda comanda = new Comanda();

        comanda.setNomeCliente(
                nomeCliente.trim()
        );


        return comandaRepository.save(comanda);
    }


    /*
     * Lista somente comandas abertas.
     */
    public List<Comanda> listarAbertas() {

        return comandaRepository
                .findByStatusOrderByDataAberturaDesc(
                        STATUS_ABERTA
                );
    }


    /*
     * Conta quantas comandas estão abertas.
     */
    public long contarAbertas() {

        return comandaRepository
                .countByStatus(
                        STATUS_ABERTA
                );
    }


    /*
     * Busca uma comanda pelo ID.
     */
    public Optional<Comanda> buscarPorId(Integer id) {

        return comandaRepository.findById(id);
    }


    /*
     * Lista os produtos pertencentes
     * a determinada comanda.
     */
    public List<ComandaItem> listarItens(
            Integer comandaId
    ) {

        return comandaItemRepository
                .findByComandaId(
                        comandaId
                );
    }


    /*
     * Calcula o valor atual da comanda.
     */
    public BigDecimal calcularTotal(
            Integer comandaId
    ) {

        List<ComandaItem> itens =
                listarItens(comandaId);


        BigDecimal total =
                BigDecimal.ZERO;


        for (ComandaItem comandaItem : itens) {

            BigDecimal quantidade =
                    BigDecimal.valueOf(
                            comandaItem.getQuantidade()
                    );


            BigDecimal subtotal =
                    comandaItem
                            .getPrecoUnitario()
                            .multiply(quantidade);


            total = total.add(subtotal);
        }


        return total;
    }
}