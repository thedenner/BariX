package barix.com.br.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;

@Entity
@Table(name = "item")
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_item")
    private Integer id;

    @Column(
            name = "nome_item",
            nullable = false,
            unique = true,
            length = 100
    )
    private String nome;

    @Column(
            name = "preco_item",
            precision = 10,
            scale = 2
    )
    private BigDecimal preco;

    @Column(
            name = "quantidade_item",
            nullable = false
    )
    private Integer quantidade;

    @ManyToOne //chave estrangeira
    @JoinColumn(name = "id_categoria")
    private Category category;

    public Item() {
    }

    public Integer getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public BigDecimal getPreco() {
        return preco;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public Category getCategory() {
        return category;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setPreco(BigDecimal preco) {
        this.preco = preco;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

}
