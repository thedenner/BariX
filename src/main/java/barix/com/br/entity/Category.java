package barix.com.br.entity;

import jakarta.persistence.*;

@Entity
@Table(name ="categoria")

public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_categoria")
    private Integer id;

    @Column(
            name = "nome_categoria",
            nullable = false,
            unique = true,
            length = 50
    )
    private String nome;

    public Category() {
    }

    public Category(String nome) {
        this.nome = nome;
    }

    public Integer getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
}


