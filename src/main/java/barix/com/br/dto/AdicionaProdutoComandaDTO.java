package barix.com.br.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public class AdicionaProdutoComandaDTO {

    @NotNull(message = "Selecione um produto.")
    private Integer produtoId;

    @NotNull(message = "Informe a quantidade.")
    @Min(
            value = 1,
            message = "A quantidade deve ser maior que zero."
    )
    private Integer quantidade;

    public Integer getProdutoId() {
        return produtoId;
    }

    public void setProdutoId(Integer produtoId) {
        this.produtoId = produtoId;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }
}
