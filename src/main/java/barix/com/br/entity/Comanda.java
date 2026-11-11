package barix.com.br.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "comanda")
public class Comanda {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_comanda")
    private Integer id;

    @Column(
            name = "nome_cliente",
            nullable = false,
            length = 100
    )
    private String nomeCliente;

    @Column(
            name = "status",
            nullable = false,
            length = 20
    )
    private String status;

    @Column(
            name = "data_abertura",
            nullable = false
    )
    private LocalDateTime dataAbertura;

    @Column(
            name = "data_fechamento"
    )
    private LocalDateTime dataFechamento;


    public Comanda() {
    }


    @PrePersist
    public void prePersist() {

        if (status == null) {
            status = "ABERTA";
        }

        if (dataAbertura == null) {
            dataAbertura = LocalDateTime.now();
        }
    }


    public Integer getId() {
        return id;
    }

    public String getNomeCliente() {
        return nomeCliente;
    }

    public void setNomeCliente(String nomeCliente) {
        this.nomeCliente = nomeCliente;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getDataAbertura() {
        return dataAbertura;
    }

    public void setDataAbertura(LocalDateTime dataAbertura) {
        this.dataAbertura = dataAbertura;
    }

    public LocalDateTime getDataFechamento() {
        return dataFechamento;
    }

    public void setDataFechamento(LocalDateTime dataFechamento) {
        this.dataFechamento = dataFechamento;
    }
}