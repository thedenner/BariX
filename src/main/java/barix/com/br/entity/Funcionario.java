package barix.com.br.entity;

import jakarta.persistence.*;

    @Entity
    @Table(name = "funcionario")
    public class Funcionario {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id_funcionario")
        private Integer id;

        @Column(name = "nome_funcionario", nullable = false)
        private String nome;

        @Column(name = "status_funcionario")
        private Boolean ativo;

        public Funcionario() {
        }

        public Integer getId() {
            return id;
        }

        public String getNome() {
            return nome;
        }

        public Boolean getAtivo() {
            return ativo;
        }
    }


