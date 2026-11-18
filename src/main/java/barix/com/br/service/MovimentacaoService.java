
package barix.com.br.service;

import barix.com.br.dto.MovimentacaoFormDTO;

import barix.com.br.entity.Item;
import barix.com.br.entity.Funcionario;
import barix.com.br.entity.Movimentacao;

import barix.com.br.repository.ItemRepository;
import barix.com.br.repository.MovimentacaoRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MovimentacaoService {

    private static final String ENTRADA = "ENTRADA";
    private static final String SAIDA = "SAÍDA";

    private final ItemRepository itemRepository;
    private final MovimentacaoRepository movimentacaoRepository;
    private final FuncionarioService funcionarioService;


    public MovimentacaoService(
            ItemRepository itemRepository,
            MovimentacaoRepository movimentacaoRepository,
            FuncionarioService funcionarioService
    ) {

        this.itemRepository = itemRepository;
        this.movimentacaoRepository = movimentacaoRepository;
        this.funcionarioService = funcionarioService;
    }


    /*
     * REGISTRO DE MOVIMENTAÇÃO MANUAL
     */
    @Transactional
    public void registrarMovimentacao(
            MovimentacaoFormDTO dados
    ) {

        // 1. Valida os parâmetros.

        if (dados == null
                || dados.getProdutoId() == null
                || dados.getQuantidade() == null
                || dados.getQuantidade() <= 0) {

            throw new IllegalArgumentException(
                    "Dados da movimentação inválidos."
            );
        }


        String tipo = dados.getTipo();

        if (!ENTRADA.equals(tipo)
                && !SAIDA.equals(tipo)) {

            throw new IllegalArgumentException(
                    "Tipo de movimentação inválido."
            );
        }


        // 2. Identifica o funcionário responsável.

        Funcionario funcionario =
                funcionarioService.buscarAtivoPorId(
                        dados.getFuncionarioId()
                );


        // 3. Localiza e bloqueia o produto.

        Item produto = itemRepository
                .buscarParaAtualizar(
                        dados.getProdutoId()
                )
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Produto não encontrado."
                        )
                );


        // 4. Recupera o saldo atual.

        if (produto.getQuantidade() == null
                || produto.getQuantidade() < 0) {

            throw new IllegalStateException(
                    "O produto possui um estoque inválido."
            );
        }

        int estoqueAtual = produto.getQuantidade();

        int quantidade = dados.getQuantidade();

        long novoEstoque;


        // 5. Calcula o novo saldo.

        if (ENTRADA.equals(tipo)) {

            novoEstoque =
                    (long) estoqueAtual + quantidade;

        } else {

            novoEstoque =
                    (long) estoqueAtual - quantidade;
        }


        // 6. Valida o saldo resultante.

        if (novoEstoque < 0) {

            throw new IllegalStateException(
                    "Estoque insuficiente para realizar a saída."
            );
        }

        if (novoEstoque > Integer.MAX_VALUE) {

            throw new IllegalStateException(
                    "O limite de estoque foi ultrapassado."
            );
        }


        // 7. Atualiza o produto.

        produto.setQuantidade(
                (int) novoEstoque
        );

        itemRepository.save(produto);


        // 8. Cria o registro da movimentação.

        Movimentacao movimentacao =
                new Movimentacao();

        movimentacao.setTipo(tipo);

        movimentacao.setQuantidade(quantidade);

        movimentacao.setItem(produto);

        movimentacao.setFuncionario(funcionario);

        // Movimentação manual, sem vínculo com comanda.
        movimentacao.setComanda(null);


        // 9. Persiste a movimentação.

        movimentacaoRepository.save(movimentacao);
    }


    /*
     * HISTÓRICO PAGINADO
     */
    @Transactional(readOnly = true)
    public Page<Movimentacao> listarMovimentacoes(
            int pagina
    ) {

        PageRequest pageable = PageRequest.of(
                Math.max(0, pagina),
                15
        );

        Page<Movimentacao> resultado =
                movimentacaoRepository
                        .findAllByOrderByDataHoraDescIdDesc(
                                pageable
                        );

        if (pagina > 0 && resultado.isEmpty()) {

            int ultimaPagina = Math.max(
                    0,
                    resultado.getTotalPages() - 1
            );

            return movimentacaoRepository
                    .findAllByOrderByDataHoraDescIdDesc(
                            pageable.withPage(ultimaPagina)
                    );
        }

        return resultado;
    }
}
