package barix.com.br.service;

import barix.com.br.dto.ComandaFiltroDTO;
import barix.com.br.entity.*;
import barix.com.br.repository.ComandaItemRepository;
import barix.com.br.repository.ComandaRepository;

import barix.com.br.repository.ItemRepository;
import barix.com.br.repository.MovimentacaoRepository;
import barix.com.br.specification.ComandaSpecification;
import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.PersistenceContext;
import org.springframework.data.domain.Sort;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

@Service
public class ComandaService {

    private static final String STATUS_ABERTA = "ABERTA";

    private final ComandaRepository comandaRepository;
    private final ComandaItemRepository comandaItemRepository;
    private final ItemRepository itemRepository;
    private final FuncionarioService funcionarioService;
    private final MovimentacaoRepository movimentacaoRepository;

    @PersistenceContext
    private EntityManager entityManager;


    public ComandaService(ComandaRepository comandaRepository,
                          ComandaItemRepository comandaItemRepository,
                          ItemRepository itemRepository,
                          FuncionarioService funcionarioService,
                          MovimentacaoRepository movimentacaoRepository) {

        this.comandaRepository = comandaRepository;
        this.comandaItemRepository = comandaItemRepository;
        this.itemRepository = itemRepository;
        this.funcionarioService = funcionarioService;
        this.movimentacaoRepository = movimentacaoRepository;
    }

    public List<Comanda> listarTodas() {

        return comandaRepository.findAll();
    }

    /*
     * Cria uma nova comanda.
     */
    public Comanda abrirComanda(String nomeCliente) {

        if (nomeCliente == null || nomeCliente.isBlank()) {

            throw new IllegalArgumentException("O nome do cliente é obrigatório.");
        }

        Comanda comanda = new Comanda();

        comanda.setNomeCliente(nomeCliente.trim());

        return comandaRepository.save(comanda);
    }

    /*
     * Lista somente comandas abertas.
     */
    public List<Comanda> listarAbertas() {

        return comandaRepository.findByStatusOrderByDataAberturaDesc(STATUS_ABERTA);
    }

    /*
     * Conta quantas comandas estão abertas.
     */
    public long contarAbertas() {

        return comandaRepository.countByStatus(STATUS_ABERTA);
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
    public List<ComandaItem> listarItens(Integer comandaId) {

        return comandaItemRepository.findByComandaId(comandaId);
    }

    /*
     * Calcula o valor atual da comanda.
     */
    public BigDecimal calcularTotal(Integer comandaId) {

        List<ComandaItem> itens = listarItens(comandaId);

        BigDecimal total = BigDecimal.ZERO;

        for (ComandaItem comandaItem : itens) {

            BigDecimal quantidade = BigDecimal.valueOf(comandaItem.getQuantidade());

            BigDecimal subtotal = comandaItem.getPrecoUnitario().multiply(quantidade);

            total = total.add(subtotal);
        }

        return total;
    }

    public List<Comanda> listarRecentesAbertas() {

        return comandaRepository.findTop6ByStatusOrderByDataAberturaDesc(STATUS_ABERTA);
    }
    /*
     * Adiciona um produto a uma comanda aberta.
     *
     * Não realiza baixa de estoque.
     * O preço é registrado no momento da inclusão.
     */
    @Transactional
    public ComandaItem adicionarProduto(Integer comandaId, Integer produtoId, Integer quantidade) {

        // 1. Valida os parâmetros recebidos.

        if (comandaId == null || produtoId == null || quantidade == null || quantidade <= 0) {

            throw new IllegalArgumentException("Produto, comanda ou quantidade inválidos.");
        }


        // 2. Busca a comanda.

        Comanda comanda = comandaRepository
                .buscarParaAtualizar(comandaId)
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Comanda não encontrada."
                        )
                );


        // 3. Não permite alterar uma comanda fechada.

        if (!STATUS_ABERTA.equals(comanda.getStatus())) {

            throw new IllegalStateException("Não é possível adicionar produtos a uma comanda fechada.");
        }


        // 4. Busca o produto no banco.

        Item produto = itemRepository.findById(produtoId).orElseThrow(() -> new IllegalArgumentException("Produto não encontrado."));


        // 5. Confere se o produto possui preço.

        if (produto.getPreco() == null || produto.getPreco().signum() < 0) {

            throw new IllegalArgumentException("O produto não possui um preço válido.");
        }


        // 6. Soma quantidades já adicionadas
        // desse produto na mesma comanda.

        long quantidadeJaAdicionada = comandaItemRepository
                .findByComandaId(comandaId)
                .stream()
                .filter(linha ->
                        linha.getItem()
                                .getId()
                                .equals(produtoId)
                )
                .mapToLong(ComandaItem::getQuantidade)
                .sum();


        long quantidadeSolicitada = quantidadeJaAdicionada + quantidade;


        // 7. Verifica o estoque atual.
        // Esta consulta NÃO reserva o estoque.

        if (produto.getQuantidade() == null || quantidadeSolicitada > produto.getQuantidade()) {

            throw new IllegalArgumentException("Quantidade solicitada superior ao estoque disponível.");
        }


        // 8. Cria a linha de consumo.

        ComandaItem comandaItem = new ComandaItem();

        comandaItem.setComanda(comanda);
        comandaItem.setItem(produto);
        comandaItem.setQuantidade(quantidade);

        /*
         * Registra o preço atual do produto.
         * Alterações futuras de preço não afetam
         * esta linha da comanda.
         */
        comandaItem.setPrecoUnitario(produto.getPreco());


        // 9. Grava no banco.

        return comandaItemRepository.save(comandaItem);
    }


    /*
     * Remove uma linha de consumo de uma comanda.
     *
     * Regras:
     * - A comanda precisa existir.
     * - A comanda precisa estar ABERTA.
     * - A linha precisa pertencer à comanda.
     * - Não altera a quantidade do produto em estoque.
     */
    @Transactional
    public void removerProduto(Integer comandaId, Integer comandaItemId) {

        if (comandaId == null || comandaItemId == null) {
            throw new IllegalArgumentException("Comanda ou item inválido.");
        }

        // 1. Localiza a comanda.

        Comanda comanda = comandaRepository
                .buscarParaAtualizar(comandaId)
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Comanda não encontrada."
                        )
                );

        // 2. Impede alterações em comandas fechadas.

        if (!STATUS_ABERTA.equals(comanda.getStatus())) {
            throw new IllegalStateException("Não é possível remover itens de uma comanda fechada.");
        }

        // 3. Localiza a linha pertencente à comanda.

        ComandaItem linha = comandaItemRepository
                .findByIdAndComanda_Id(comandaItemId, comandaId)
                .orElseThrow(() -> new IllegalArgumentException("Item não encontrado nesta comanda."));

        // 4. Exclui somente a linha de consumo.

        comandaItemRepository.delete(linha);
    }


    /*
     * Fecha uma comanda e registra a saída de estoque.
     *
     * Toda a operação ocorre em uma única transação.
     */
    @Transactional
    public void fecharComanda(
            Integer comandaId,
            Integer funcionarioId
    ) {

        if (comandaId == null || comandaId <= 0) {
            throw new IllegalArgumentException(
                    "Comanda inválida."
            );
        }

        // 1. Bloqueia a comanda para atualização.

        Comanda comanda = comandaRepository
                .buscarParaAtualizar(comandaId)
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Comanda não encontrada."
                        )
                );

        if (!STATUS_ABERTA.equals(comanda.getStatus())) {
            throw new IllegalStateException(
                    "Esta comanda já foi fechada."
            );
        }


        // 2. Identifica o funcionário responsável.

        Funcionario funcionario =
                funcionarioService.buscarAtivoPorId(
                        funcionarioId
                );


        // 3. Recupera as linhas de consumo.

        List<ComandaItem> linhas =
                comandaItemRepository.findByComandaId(
                        comandaId
                );

        if (linhas.isEmpty()) {
            throw new IllegalStateException(
                    "Não é possível fechar uma comanda sem produtos."
            );
        }


        /*
         * 4. Agrupa quantidades por produto.
         *
         * TreeMap mantém os IDs ordenados.
         * Isso padroniza a ordem de aquisição dos
         * bloqueios e reduz risco de deadlock.
         */
        Map<Integer, Integer> quantidades =
                new TreeMap<>();

        for (ComandaItem linha : linhas) {

            if (linha.getQuantidade() == null
                    || linha.getQuantidade() <= 0
                    || linha.getItem() == null
                    || linha.getItem().getId() == null) {

                throw new IllegalStateException(
                        "A comanda possui uma linha inválida."
                );
            }

            Integer produtoId = linha.getItem().getId();

            long soma =
                    (long) quantidades.getOrDefault(
                            produtoId, 0
                    ) + linha.getQuantidade();

            if (soma > Integer.MAX_VALUE) {
                throw new IllegalStateException(
                        "Quantidade total de produto inválida."
                );
            }

            quantidades.put(
                    produtoId,
                    (int) soma
            );
        }


        /*
         * 5. Bloqueia cada produto, verifica o saldo,
         * baixa o estoque e registra a movimentação.
         */
        for (Map.Entry<Integer, Integer> entrada
                : quantidades.entrySet()) {

            Integer produtoId = entrada.getKey();
            Integer quantidade = entrada.getValue();

            Item produto = itemRepository
                    .buscarParaAtualizar(produtoId)
                    .orElseThrow(
                            () -> new IllegalArgumentException(
                                    "Produto não encontrado."
                            )
                    );

            entityManager.refresh(
                    produto,
                    LockModeType.PESSIMISTIC_WRITE
            );
            if (produto.getQuantidade() == null || produto.getQuantidade() < quantidade) {

                throw new IllegalStateException("Estoque insuficiente: " + produto.getNome());
            }


            // Baixa o estoque.

            produto.setQuantidade(produto.getQuantidade() - quantidade);

            itemRepository.save(produto);


            // Registra a saída associada à comanda.

            Movimentacao movimentacao = new Movimentacao();

            movimentacao.setTipo("SAÍDA");
            movimentacao.setQuantidade(quantidade);
            movimentacao.setItem(produto);
            movimentacao.setFuncionario(funcionario);
            movimentacao.setComanda(comanda);

            movimentacaoRepository.save(movimentacao);
        }


        // 6. Finaliza a comanda.

        comanda.setStatus("FECHADA");

        comanda.setDataFechamento(LocalDateTime.now());

        comandaRepository.save(comanda);
    }

    /*
     * Retorna as comandas FECHADAS, com paginação.
     *
     * Cada página contém até 10 registros.
     */
    @Transactional(readOnly = true)
    public Page<Comanda> listarFechadas(int pagina) {

        int paginaValida = Math.max(0, pagina);

        return comandaRepository
                .findByStatusOrderByDataFechamentoDesc(
                        "FECHADA",
                        PageRequest.of(paginaValida, 10)
                );
    }

    /*
     * Calcula os totais de várias comandas
     * sem executar uma consulta por comanda.
     *
     * Exemplo:
     * Comanda #1 = R$ 25,00
     * Comanda #2 = R$ 40,00
     * Comanda #3 = R$ 0,00
     */
    @Transactional(readOnly = true)
    public Map<Integer, BigDecimal> calcularTotaisEmLote(
            List<Comanda> comandas
    ) {

        Map<Integer, BigDecimal> totais =
                new HashMap<>();

        if (comandas.isEmpty()) {
            return totais;
        }

        List<Integer> ids = new ArrayList<>();

        // Inicializa todas as comandas com total zero.

        for (Comanda comanda : comandas) {

            ids.add(comanda.getId());

            totais.put(
                    comanda.getId(),
                    BigDecimal.ZERO
            );
        }


        // Uma consulta para localizar os itens.

        List<ComandaItem> linhas =
                comandaItemRepository.findByComanda_IdIn(
                        ids
                );


        // Soma os subtotais por comanda.

        for (ComandaItem linha : linhas) {

            Integer idComanda =
                    linha.getComanda().getId();

            BigDecimal subtotal =
                    linha.getPrecoUnitario().multiply(
                            BigDecimal.valueOf(
                                    linha.getQuantidade()
                            )
                    );

            totais.merge(
                    idComanda,
                    subtotal,
                    BigDecimal::add
            );
        }

        return totais;
    }


    /*
     * Pesquisa comandas abertas utilizando
     * os filtros informados pelo usuário.
     */
    @Transactional(readOnly = true)
    public List<Comanda> buscarAbertas(
            ComandaFiltroDTO filtro
    ) {

        if ("FECHADA".equals(filtro.getStatus())) {
            return List.of();
        }

        return comandaRepository.findAll(

                ComandaSpecification.filtrar(
                        filtro,
                        "ABERTA"
                ),

                Sort.by(
                        Sort.Direction.DESC,
                        "dataAbertura",
                        "id"
                )
        );
    }


    /*
     * Pesquisa comandas fechadas
     * combinando Specification e paginação.
     */
    @Transactional(readOnly = true)
    public Page<Comanda> buscarFechadas(ComandaFiltroDTO filtro, int pagina) {

        PageRequest pageable = PageRequest.of(

                Math.max(0, pagina),

                10,

                Sort.by(
                        Sort.Direction.DESC,
                        "dataFechamento",
                        "id"
                )
        );


        if ("ABERTA".equals(filtro.getStatus())) {
            return Page.empty(pageable);
        }


        Page<Comanda> resultado =
                comandaRepository.findAll(

                        ComandaSpecification.filtrar(
                                filtro,
                                "FECHADA"
                        ),

                        pageable
                );


        // Corrige páginas que deixaram de existir.

        if (pagina > 0 && resultado.isEmpty()) {

            int ultimaPagina = Math.max(
                    0,
                    resultado.getTotalPages() - 1
            );

            resultado = comandaRepository.findAll(

                    ComandaSpecification.filtrar(
                            filtro,
                            "FECHADA"
                    ),

                    pageable.withPage(ultimaPagina)
            );
        }

        return resultado;
    }




}