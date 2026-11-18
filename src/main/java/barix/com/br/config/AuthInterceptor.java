package barix.com.br.config;

import barix.com.br.service.UsuarioService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import java.security.Principal;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    private final UsuarioService usuarioService;

    public AuthInterceptor(UsuarioService usuarioService) {
        this.usuarioService = usuarioService;
    }

    // A autorização é responsabilidade de Spring Security, não deste interceptor.
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response,
                           Object handler, ModelAndView modelAndView) {
        Principal principal = request.getUserPrincipal();
        if (principal == null || modelAndView == null || !"dashboard".equals(modelAndView.getViewName())) {
            return;
        }
        modelAndView.addObject("nomeFuncionario",
                usuarioService.buscarNomeCompleto(principal.getName()));
    }
}
