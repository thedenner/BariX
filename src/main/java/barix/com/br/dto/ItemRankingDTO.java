package barix.com.br.dto;

import java.math.BigDecimal;

public class ItemRankingDTO {
    private String nome;
    private String categoria;
    private Long quantidadeVendida;
    private BigDecimal valorTotal;
    private double percentual;

    public ItemRankingDTO(String nome, String categoria, Long quantidadeVendida, BigDecimal valorTotal, double percentual) {
        this.nome = nome;
        this.categoria = categoria;
        this.quantidadeVendida = quantidadeVendida;
        this.valorTotal = valorTotal;
        this.percentual = percentual;
    }

    public String getNome() { return nome; }
    public String getCategoria() { return categoria; }
    public Long getQuantidadeVendida() { return quantidadeVendida; }
    public BigDecimal getValorTotal() { return valorTotal; }
    public double getPercentual() { return percentual; }
}