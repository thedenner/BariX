
package barix.com.br.service;

import barix.com.br.entity.Funcionario;
import barix.com.br.repository.FuncionarioRepository;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FuncionarioService {

    private final FuncionarioRepository funcionarioRepository;

    public FuncionarioService(
            FuncionarioRepository funcionarioRepository
    ) {
        this.funcionarioRepository = funcionarioRepository;
    }

    public List<Funcionario> listarAtivos() {
        return funcionarioRepository
                .findByAtivoTrueOrderByNomeAsc();
    }

    public Funcionario buscarAtivoPorId(Integer id) {

        if (id == null) {
            throw new IllegalArgumentException(
                    "Informe o funcionário responsável."
            );
        }

        Funcionario funcionario = funcionarioRepository
                .findById(id)
                .orElseThrow(
                        () -> new IllegalArgumentException(
                                "Funcionário não encontrado."
                        )
                );

        if (!Boolean.TRUE.equals(funcionario.getAtivo())) {
            throw new IllegalStateException(
                    "O funcionário informado está inativo."
            );
        }

        return funcionario;
    }
}
