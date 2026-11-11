package barix.com.br.controller;

import barix.com.br.dto.ComandaFormDTO;
import barix.com.br.entity.Comanda;
import barix.com.br.service.ComandaService;

import jakarta.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class ComandaViewController {

    private final ComandaService comandaService;


    public ComandaViewController(
            ComandaService comandaService
    ) {

        this.comandaService = comandaService;
    }


    /*
     * Lista as comandas.
     */
    @GetMapping("/comandas")
    public String comandas(Model model) {

        List<Comanda> comandasAbertas =
                comandaService.listarAbertas();

        model.addAttribute(
                "comandasAbertas",
                comandasAbertas
        );

        model.addAttribute(
                "quantidadeAbertas",
                comandaService.contarAbertas()
        );


        return "comandas";
    }


    /*
     * Abre o formulário de criação.
     */
    @GetMapping("/comandas/nova")
    public String novaComanda(Model model) {

        model.addAttribute(
                "comandaForm",
                new ComandaFormDTO()
        );

        return "nova-comanda";
    }


    /*
     * Recebe o formulário.
     */
    @PostMapping("/comandas/nova")
    public String criarComanda(

            @RequestParam String nomeCliente,

            RedirectAttributes redirectAttributes

    ) {

        try {

            Comanda comanda =
                    comandaService.abrirComanda(
                            nomeCliente
                    );


            redirectAttributes.addFlashAttribute(
                    "mensagemSucesso",
                    "Comanda #" + comanda.getId()
                            + " aberta com sucesso."
            );


        } catch (IllegalArgumentException exception) {

            redirectAttributes.addFlashAttribute(
                    "mensagemErro",
                    exception.getMessage()
            );
        }


        return "redirect:/";
    }
}