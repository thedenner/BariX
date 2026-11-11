package barix.com.br.dto;

import jakarta.validation.constraints.*;

import java.math.BigDecimal;

public class ItemFormDTO {

        @NotBlank(message = "O nome do produto é obrigatório.")
        @Size(
                max = 100,
                message = "O nome deve possuir no máximo 100 caracteres."
        )
        private String nome;

        @NotNull(message = "O preço é obrigatório.")
        @DecimalMin(
                value = "0.00",
                inclusive = true,
                message = "O preço não pode ser negativo."
        )
        private BigDecimal preco;

        @NotNull(message = "A quantidade é obrigatória.")
        @Min(
                value = 0,
                message = "A quantidade não pode ser negativa."
        )
        private Integer quantidade;

        @NotNull(message = "Selecione uma categoria.")
        private Integer categoriaId;


        public String getNome() {
            return nome;
        }

        public void setNome(String nome) {
            this.nome = nome;
        }

        public BigDecimal getPreco() {
            return preco;
        }

        public void setPreco(BigDecimal preco) {
            this.preco = preco;
        }

        public Integer getQuantidade() {
            return quantidade;
        }

        public void setQuantidade(Integer quantidade) {
            this.quantidade = quantidade;
        }

        public Integer getCategoriaId() {
            return categoriaId;
        }

        public void setCategoriaId(Integer categoriaId) {
            this.categoriaId = categoriaId;
        }
}

