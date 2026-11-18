package barix.com.br.service;

import barix.com.br.dto.ItemRankingDTO;
import barix.com.br.dto.ResumoFinanceiroDTO;
import barix.com.br.repository.ComandaItemRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
public class FinanceiroService {

    private final ComandaItemRepository comandaItemRepository;

    public FinanceiroService(ComandaItemRepository comandaItemRepository) {
        this.comandaItemRepository = comandaItemRepository;
    }

    public String normalizarPeriodo(String periodo) {
        if (periodo == null) return "DIA";
        return switch (periodo.trim().toUpperCase(Locale.ROOT)) {
            case "SEMANA" -> "SEMANA";
            case "MES" -> "MES";
            default -> "DIA";
        };
    }

    @Transactional(readOnly = true)
    public ResumoFinanceiroDTO gerarResumo(String periodo, Integer categoriaId, Integer itemId) {
        LocalDate hoje = LocalDate.now();
        LocalDateTime inicio = switch (normalizarPeriodo(periodo)) {
            case "SEMANA" -> hoje.minusDays(6).atStartOfDay();
            case "MES" -> hoje.withDayOfMonth(1).atStartOfDay();
            default -> hoje.atStartOfDay();
        };
        // Limite exclusivo: inclui o último dia inteiro.
        LocalDateTime fim = hoje.plusDays(1).atStartOfDay();

        // Consulta agrupada: não carrega todas as linhas individuais de consumo.
        List<Object[]> linhas = comandaItemRepository.agruparReceitaPorItem(
                inicio, fim, categoriaId, itemId);
        Long totalComandas = comandaItemRepository.contarComandasFechadas(
                inicio, fim, categoriaId, itemId);

        BigDecimal receitaTotal = BigDecimal.ZERO;
        for (Object[] linha : linhas) {
            receitaTotal = receitaTotal.add((BigDecimal) linha[3]);
        }

        List<ItemRankingDTO> itens = new ArrayList<>();
        Map<Integer, AcumuladoCategoria> categorias = new LinkedHashMap<>();

        for (Object[] linha : linhas) {
            String nomeItem = (String) linha[0];
            String nomeCat = linha[1] == null ? "Sem categoria" : (String) linha[1];
            long qtd = ((Number) linha[2]).longValue();
            BigDecimal valor = (BigDecimal) linha[3];
            Integer categoria = (Integer) linha[4];

            itens.add(new ItemRankingDTO(nomeItem, nomeCat, qtd, valor,
                    calcularPercentual(valor, receitaTotal)));

            categorias.merge(categoria,
                    new AcumuladoCategoria(nomeCat, qtd, valor),
                    (anterior, novo) -> new AcumuladoCategoria(anterior.nome(),
                            anterior.quantidade() + novo.quantidade(),
                            anterior.valor().add(novo.valor())));
        }

        // Ranking ordenado pela receita na própria consulta, com desempate pelo ID.
        List<ItemRankingDTO> top10Itens = itens.stream().limit(10).toList();
        List<ItemRankingDTO> itensPeso;
        String tituloGrafico;
        if (categoriaId == null && itemId == null) {
            tituloGrafico = "Peso por Categoria na Receita";
            itensPeso = new ArrayList<>();
            for (AcumuladoCategoria cat : categorias.values()) {
                itensPeso.add(new ItemRankingDTO(cat.nome(), cat.nome(), cat.quantidade(),
                        cat.valor(), calcularPercentual(cat.valor(), receitaTotal)));
            }
            itensPeso.sort(Comparator.comparing(ItemRankingDTO::getValorTotal).reversed());
        } else {
            tituloGrafico = "Peso dos Itens na Receita Filtrada";
            itensPeso = itens;
        }

        return new ResumoFinanceiroDTO(receitaTotal, totalComandas, tituloGrafico,
                itensPeso, top10Itens);
    }

    private double calcularPercentual(BigDecimal parte, BigDecimal total) {
        if (total.signum() <= 0) return 0.0;
        return parte.multiply(BigDecimal.valueOf(100))
                .divide(total, 1, RoundingMode.HALF_UP).doubleValue();
    }

    private record AcumuladoCategoria(String nome, long quantidade, BigDecimal valor) {
    }
}
