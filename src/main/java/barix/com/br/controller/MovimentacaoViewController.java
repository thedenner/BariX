
package barix.com.br.controller;

import barix.com.br.dto.MovimentacaoFormDTO;
import barix.com.br.entity.Movimentacao;

import barix.com.br.service.ItemService;
import barix.com.br.service.FuncionarioService;
import barix.com.br.service.MovimentacaoService;

import jakarta.validation.Valid;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/estoque/movimentacoes")
public class MovimentacaoViewController {

    private final MovimentacaoService movimentacaoService;
    private final ItemService itemService;
    private final FuncionarioService funcionarioService;


    public MovimentacaoViewController(
            MovimentacaoService movimentacaoService,
            ItemService itemService,
            FuncionarioService funcionarioService
    ) {

        this.movimentacaoService = movimentacaoService;
        this.itemService = itemService;
        this.funcionarioService = funcionarioService;
    }


    /*
     * EXIBIÇÃO DA PÁGINA
     */
    @GetMapping
    public String movimentacoes(

            @RequestParam(
                    name = "pagina",
                    defaultValue = "0"
            )
            int pagina,

            Model model
    ) {

        model.addAttribute(
                "movimentacaoForm",
                new MovimentacaoFormDTO()
        );

        carregarTela(model, pagina);

        return "movimentacoes";
    }


    /*
     * REGISTRO DA MOVIMENTAÇÃO
     */
    @PostMapping
    public String registrar(

            @Valid
            @ModelAttribute("movimentacaoForm")
            MovimentacaoFormDTO dados,

            BindingResult bindingResult,

            Model model,

            RedirectAttributes redirectAttributes
    ) {

        // 1. Valida os dados do formulário.

        if (bindingResult.hasErrors()) {

            String mensagem = bindingResult
                    .getFieldErrors()
                    .stream()
                    .findFirst()
                    .map(erro -> erro.getDefaultMessage())
                    .orElse("Dados inválidos.");

            model.addAttribute(
                    "mensagemErro",
                    mensagem
            );

            carregarTela(model, 0);

            return "movimentacoes";
        }


        // 2. Executa a movimentação.

        try {

            movimentacaoService.registrarMovimentacao(
                    dados
            );

            redirectAttributes.addFlashAttribute(
                    "mensagemSucesso",
                    "Movimentação registrada com sucesso."
            );

        } catch (IllegalArgumentException
                 | IllegalStateException exception) {

            model.addAttribute(
                    "mensagemErro",
                    exception.getMessage()
            );

            carregarTela(model, 0);

            return "movimentacoes";
        }


        // 3. Redireciona após a gravação.

        return "redirect:/estoque/movimentacoes";
    }


    /*
     * PREPARA OS ATRIBUTOS DA INTERFACE.
     */
    private void carregarTela(
            Model model,
            int pagina
    ) {

        Page<Movimentacao> historico =
                movimentacaoService
                        .listarMovimentacoes(pagina);


        model.addAttribute(
                "produtos",
                itemService.listarTodos()
        );

        model.addAttribute(
                "funcionariosAtivos",
                funcionarioService.listarAtivos()
        );

        model.addAttribute(
                "movimentacoes",
                historico.getContent()
        );

        model.addAttribute(
                "totalMovimentacoes",
                historico.getTotalElements()
        );

        model.addAttribute(
                "paginaAtual",
                historico.getNumber()
        );

        model.addAttribute(
                "totalPaginas",
                historico.getTotalPages()
        );

        model.addAttribute(
                "paginaAnterior",
                historico.getNumber() - 1
        );

        model.addAttribute(
                "proximaPagina",
                historico.getNumber() + 1
        );

        model.addAttribute(
                "temAnterior",
                historico.hasPrevious()
        );

        model.addAttribute(
                "temProxima",
                historico.hasNext()
        );
    }
}
