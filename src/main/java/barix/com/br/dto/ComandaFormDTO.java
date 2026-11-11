package barix.com.br.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class ComandaFormDTO {

    @NotBlank(
            message = "O nome do cliente é obrigatório."
    )
    @Size(
            max = 100,
            message = "O nome deve possuir no máximo 100 caracteres."
    )
    private String nomeCliente;


    public String getNomeCliente() {
        return nomeCliente;
    }

    public void setNomeCliente(String nomeCliente) {
        this.nomeCliente = nomeCliente;
    }
}