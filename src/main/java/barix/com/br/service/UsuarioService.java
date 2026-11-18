package barix.com.br.service;

import barix.com.br.entity.Usuario;
import barix.com.br.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UsuarioService implements UserDetailsService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final boolean cadastroHabilitado;

    public UsuarioService(UsuarioRepository usuarioRepository,
                          PasswordEncoder passwordEncoder,
                          @Value("${barix.auth.cadastro-habilitado:false}")
                          boolean cadastroHabilitado) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.cadastroHabilitado = cadastroHabilitado;
    }

    public boolean isCadastroHabilitado() {
        return cadastroHabilitado;
    }

    @Transactional
    public void cadastrar(String nomeCompleto, String usuario, String senha) {
        if (!cadastroHabilitado) {
            throw new IllegalStateException("Cadastro de usuários desabilitado.");
        }
        if (nomeCompleto == null || nomeCompleto.isBlank()
                || nomeCompleto.trim().length() > 120) {
            throw new IllegalArgumentException("Informe um nome de até 120 caracteres.");
        }
        if (usuario == null || usuario.isBlank() || usuario.trim().length() > 60) {
            throw new IllegalArgumentException("Informe um usuário de até 60 caracteres.");
        }
        if (senha == null || senha.isBlank() || senha.length() < 15 || senha.length() > 128) {
            throw new IllegalArgumentException("A senha deve ter entre 15 e 128 caracteres.");
        }
        String login = usuario.trim();
        if (usuarioRepository.existsByUsuario(login)) {
            throw new IllegalArgumentException("Não foi possível cadastrar este usuário. Escolha outro nome de acesso.");
        }
        Usuario novoUsuario = new Usuario();
        novoUsuario.setNomeCompleto(nomeCompleto.trim());
        novoUsuario.setUsuario(login);
        // Armazena somente o hash derivado com salt aleatório.
        novoUsuario.setSenha(passwordEncoder.encode(senha));
        usuarioRepository.save(novoUsuario);
    }

    @Override
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String usuario) {
        if (usuario == null || usuario.isBlank() || usuario.trim().length() > 60) {
            throw new UsernameNotFoundException("Credenciais inválidas.");
        }
        Usuario encontrado = usuarioRepository.findByUsuario(usuario.trim())
                .orElseThrow(() -> new UsernameNotFoundException("Credenciais inválidas."));

        // Rejeita senhas antigas em texto puro e formatos desconhecidos.
        if (encontrado.getSenha() == null
                || !encontrado.getSenha().matches("\\{pbkdf2-v1\\}[0-9a-fA-F]{96}")) {
            throw new UsernameNotFoundException("Credenciais inválidas.");
        }
        return User.withUsername(encontrado.getUsuario())
                .password(encontrado.getSenha())
                .roles("USER")
                .build();
    }

    @Transactional(readOnly = true)
    public String buscarNomeCompleto(String usuario) {
        return usuarioRepository.findByUsuario(usuario)
                .map(Usuario::getNomeCompleto)
                .orElse(usuario);
    }
}
