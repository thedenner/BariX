package barix.com.br.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;

@Entity
@Table(name = "comanda_item")
public class ComandaItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_comanda_item")
    private Integer id;

    @ManyToOne
    @JoinColumn(
            name = "id_comanda",
            nullable = false
    )
    private Comanda comanda;

    @ManyToOne
    @JoinColumn(
            name = "id_item",
            nullable = false
    )
    private Item item;

    @Column(
            name = "quantidade",
            nullable = false
    )
    private Integer quantidade;

    @Column(
            name = "preco_unitario",
            nullable = false,
            precision = 10,
            scale = 2
    )
    private BigDecimal precoUnitario;


    public ComandaItem() {
    }


    public Integer getId() {
        return id;
    }

    public Comanda getComanda() {
        return comanda;
    }

    public void setComanda(Comanda comanda) {
        this.comanda = comanda;
    }

    public Item getItem() {
        return item;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    public BigDecimal getPrecoUnitario() {
        return precoUnitario;
    }

    public void setPrecoUnitario(BigDecimal precoUnitario) {
        this.precoUnitario = precoUnitario;
    }
}