package barix.com.br.controller;

import barix.com.br.dto.AdicionaProdutoComandaDTO;
import barix.com.br.dto.ComandaFormDTO;
import barix.com.br.entity.Comanda;
import barix.com.br.service.ComandaService;

import barix.com.br.service.FuncionarioService;
import barix.com.br.service.ItemService;
import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class ComandaViewController {

    private final ComandaService comandaService;
    private final ItemService itemService;
    private final FuncionarioService funcionarioService;


    public ComandaViewController(ComandaService comandaService,ItemService itemService, FuncionarioService funcionarioService) {

        this.comandaService = comandaService;
        this.itemService = itemService;
        this.funcionarioService = funcionarioService;
    }


    /*
     * Lista as comandas.
     */
    @GetMapping("/comandas")
    public String comandas(Model model) {

        List<Comanda> comandasAbertas = comandaService.listarAbertas();

        model.addAttribute("comandasAbertas", comandasAbertas);

        model.addAttribute("quantidadeAbertas", comandaService.contarAbertas());

        return "comandas";
    }


    /*
     * Abre o formulário de criação.
     */
    @GetMapping("/comandas/nova")
    public String novaComanda(Model model) {

        model.addAttribute("comandaForm", new ComandaFormDTO());

        return "nova-comanda";
    }


    /*
     * Recebe o formulário.
     */
    @PostMapping("/comandas/nova")
    public String criarComanda(@RequestParam String nomeCliente, RedirectAttributes redirectAttributes) {

        try {

            Comanda comanda = comandaService.abrirComanda(nomeCliente);

            redirectAttributes.addFlashAttribute("mensagemSucesso","Comanda #" + comanda.getId() + " aberta com sucesso.");

        } catch (IllegalArgumentException exception) {

            redirectAttributes.addFlashAttribute("mensagemErro", exception.getMessage());
        }

        return "redirect:/";
    }

    @GetMapping("/comandas/{id}/detalhes")
    public String detalhesComanda(@PathVariable Integer id, Model model) {

        Comanda comanda = comandaService.buscarPorId(id).orElseThrow(() -> new ResponseStatusException(
                HttpStatus.NOT_FOUND, "Comanda não encontrada."));

        model.addAttribute("comanda", comanda);

        model.addAttribute("itensComanda", comandaService.listarItens(id));

        model.addAttribute("totalComanda", comandaService.calcularTotal(id));

        // Produtos para o campo SELECT do formulário.
        model.addAttribute("produtos", itemService.listarTodos());

        model.addAttribute("funcionariosAtivos", funcionarioService.listarAtivos());

        return "comanda-detalhes-fragmento";
    }


    @PostMapping("/comandas/{id}/itens")
    public String adicionarProdutoComanda(@PathVariable Integer id,
                                          @Valid @ModelAttribute AdicionaProdutoComandaDTO dados,
                                          BindingResult bindingResult,
                                          RedirectAttributes redirectAttributes
    ) {

        // 1. Verifica as validações do DTO.

        if (bindingResult.hasErrors()) {

            String mensagem = bindingResult
                    .getFieldErrors()
                    .stream()
                    .findFirst()
                    .map(erro -> erro.getDefaultMessage())
                    .orElse("Dados inválidos.");

            redirectAttributes.addFlashAttribute("mensagemErroDetalhes", mensagem);

            return "redirect:/comandas/" + id + "/detalhes";
        }

        // 2. Encaminha a operação ao Service.

        try {

            comandaService.adicionarProduto(id, dados.getProdutoId(), dados.getQuantidade());

            redirectAttributes.addFlashAttribute("mensagemSucessoDetalhes","Produto adicionado à comanda.");

        } catch (IllegalArgumentException | IllegalStateException exception) {

            redirectAttributes.addFlashAttribute("mensagemErroDetalhes", exception.getMessage());
        }

        // 3. Retorna os detalhes atualizados.
        // O JavaScript seguirá esse redirecionamento
        // sem atualizar o Dashboard inteiro.

        return "redirect:/comandas/" + id + "/detalhes";
    }


    /*
     * Remove um produto de uma comanda aberta.
     */
    @PostMapping("/comandas/{id}/itens/{linhaId}/remover")
    public String removerProdutoComanda(@PathVariable Integer id, @PathVariable Integer linhaId, RedirectAttributes redirectAttributes) {

        try {

            comandaService.removerProduto(id,linhaId);

            redirectAttributes.addFlashAttribute("mensagemSucessoDetalhes","Produto removido da comanda.");

        } catch (IllegalArgumentException | IllegalStateException exception) {

            redirectAttributes.addFlashAttribute("mensagemErroDetalhes", exception.getMessage());
        }

        return "redirect:/comandas/" + id + "/detalhes";
    }


    @PostMapping("/comandas/{id}/fechar")
    public String fecharComanda(

            @PathVariable Integer id,

            @RequestParam(
                    required = false
            )
            Integer funcionarioId,

            RedirectAttributes redirectAttributes
    ) {

        try {

            comandaService.fecharComanda(
                    id,
                    funcionarioId
            );

            redirectAttributes.addFlashAttribute(
                    "mensagemSucesso",
                    "Comanda #" + id
                            + " fechada com sucesso."
            );

        } catch (IllegalArgumentException
                 | IllegalStateException exception) {

            redirectAttributes.addFlashAttribute(
                    "mensagemErro",
                    exception.getMessage()
            );
        }

        return "redirect:/";
    }



}