package barix.com.br.controller;

import barix.com.br.service.UsuarioService;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;

@Controller
public class LoginViewController {

    private final UsuarioService usuarioService;

    public LoginViewController(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    @GetMapping("/login")
    public String exibirLogin(
            @RequestParam(name = "erro", defaultValue = "false") boolean erro,
            @RequestParam(name = "logout", defaultValue = "false") boolean logout,
            Principal principal, Model model) {
        if (principal != null) {
            return "redirect:/";
        }
        model.addAttribute("cadastroHabilitado", usuarioService.isCadastroHabilitado());
        if (erro) {
            model.addAttribute("erroLogin", "Usuário ou senha inválidos.");
        }
        if (logout) {
            model.addAttribute("sucessoCadastro", "Sessão encerrada com sucesso.");
        }
        return "login";
    }

    // POST /login e POST /logout são processados pelos filtros do Spring Security.
    @PostMapping("/cadastro")
    public String processarCadastro(
            @RequestParam String nomeCompleto,
            @RequestParam String usuario,
            @RequestParam String senha,
            Principal principal,
            Model model,
            RedirectAttributes redirectAttributes) {
        if (principal != null || !usuarioService.isCadastroHabilitado()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Cadastro indisponível.");
        }
        try {
            usuarioService.cadastrar(nomeCompleto, usuario, senha);
            redirectAttributes.addFlashAttribute("sucessoCadastro", "Conta criada com sucesso! Faça seu login.");
            return "redirect:/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("erroCadastro", e.getMessage());
        } catch (DataIntegrityViolationException e) {
            // Não retorna mensagens SQL ou detalhes internos.
            model.addAttribute("erroCadastro", "Não foi possível cadastrar o usuário. Verifique os dados.");
        }
        model.addAttribute("cadastroHabilitado", true);
        model.addAttribute("abrirCadastro", true);
        return "login";
    }
}
