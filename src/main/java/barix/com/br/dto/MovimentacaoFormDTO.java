
package barix.com.br.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;

public class MovimentacaoFormDTO {

    @NotNull(message = "Selecione um produto.")
    private Integer produtoId;

    @NotNull(message = "Selecione um funcionário.")
    private Integer funcionarioId;

    @NotBlank(message = "Informe o tipo de movimentação.")
    @Pattern(
            regexp = "ENTRADA|SAÍDA",
            message = "Tipo de movimentação inválido."
    )
    private String tipo = "ENTRADA";

    @NotNull(message = "Informe a quantidade.")
    @Min(value = 1, message = "A quantidade deve ser positiva.")
    private Integer quantidade;


    public Integer getProdutoId() {
        return produtoId;
    }

    public void setProdutoId(Integer produtoId) {
        this.produtoId = produtoId;
    }

    public Integer getFuncionarioId() {
        return funcionarioId;
    }

    public void setFuncionarioId(Integer funcionarioId) {
        this.funcionarioId = funcionarioId;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }
}
