package barix.com.br.dto;

import java.math.BigDecimal;
import java.util.List;

public class ResumoFinanceiroDTO {
    private final BigDecimal receitaTotal;
    private final Long totalComandas;
    private final String tituloGrafico;
    private final List<ItemRankingDTO> itensPeso;
    private final List<ItemRankingDTO> top10Itens;

    public ResumoFinanceiroDTO(BigDecimal receitaTotal, Long totalComandas,
                               String tituloGrafico, List<ItemRankingDTO> itensPeso,
                               List<ItemRankingDTO> top10Itens) {
        this.receitaTotal = receitaTotal;
        this.totalComandas = totalComandas;
        this.tituloGrafico = tituloGrafico;
        this.itensPeso = List.copyOf(itensPeso);
        this.top10Itens = List.copyOf(top10Itens);
    }

    public BigDecimal getReceitaTotal() { return receitaTotal; }
    public Long getTotalComandas() { return totalComandas; }
    public String getTituloGrafico() { return tituloGrafico; }
    public List<ItemRankingDTO> getItensPeso() { return itensPeso; }
    public List<ItemRankingDTO> getTop10Itens() { return top10Itens; }
}
