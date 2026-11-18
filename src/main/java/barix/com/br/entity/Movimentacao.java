package barix.com.br.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "movimentacao")
public class Movimentacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_movimentacao")
    private Integer id;

    @Column(
            name = "tipo_movimentacao",
            nullable = false,
            length = 10
    )
    private String tipo;

    @Column(
            name = "quantidade_movimentacao",
            nullable = false
    )
    private Integer quantidade;

    @Column(
            name = "data_hora_movimentacao",
            nullable = false
    )
    private LocalDateTime dataHora;

    @Column(
            name = "valor_compra_movimentacao",
            precision = 10,
            scale = 2
    )
    private BigDecimal valorCompra;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_item", nullable = false)
    private Item item;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_funcionario", nullable = false)
    private Funcionario funcionario;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_comanda")
    private Comanda comanda;

    public Movimentacao() {
    }

    @PrePersist
    public void prePersist() {
        if (dataHora == null) {
            dataHora = LocalDateTime.now();
        }
    }

    public Integer getId() {
        return id;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public void setQuantidade(Integer quantidade) {
        this.quantidade = quantidade;
    }

    public void setItem(Item item) {
        this.item = item;
    }

    public void setFuncionario(Funcionario funcionario) {
        this.funcionario = funcionario;
    }

    public void setComanda(Comanda comanda) {
        this.comanda = comanda;
    }

    public String getTipo() {
        return tipo;
    }

    public Integer getQuantidade() {
        return quantidade;
    }

    public LocalDateTime getDataHora() {
        return dataHora;
    }

    public BigDecimal getValorCompra() {
        return valorCompra;
    }

    public Item getItem() {
        return item;
    }

    public Funcionario getFuncionario() {
        return funcionario;
    }

    public Comanda getComanda() {
        return comanda;
    }
}
