package barix.com.br.controller;

import barix.com.br.dto.ItemFormDTO;
import barix.com.br.entity.Category;
import barix.com.br.entity.Item;
import barix.com.br.exception.ItemEmUsoException;
import barix.com.br.service.CategoryService;
import barix.com.br.service.ItemService;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
public class EstoqueViewController {

    private final ItemService itemService;
    private final CategoryService categoryService;


    public EstoqueViewController(ItemService itemService, CategoryService categoryService) {

        this.itemService = itemService;
        this.categoryService = categoryService;
    }


    @GetMapping("/estoque")
    public String estoque(

            @RequestParam(
                    required = false
            )
            String busca,

            @RequestParam(
                    required = false
            )
            Integer categoria,

            @RequestParam(
                    required = false
            )
            String status,

            Model model

    ) {

        List<Item> itens = itemService.filtrarItens(busca, categoria, status);

        List<Category> categorias = categoryService.listarTodas();


        model.addAttribute("itens", itens);

        model.addAttribute("categorias", categorias);

        model.addAttribute("totalItens", itemService.contarTotalItens());

        model.addAttribute("alertasEstoque", itemService.contarItensEmAlerta());

        model.addAttribute("estoqueMinimo", itemService.getEstoqueMinimo());

        /*
         * Mantém os filtros preenchidos
         * depois da consulta.
         */
        model.addAttribute("busca", busca);

        model.addAttribute("categoriaSelecionada", categoria);

        model.addAttribute("statusSelecionado", status);

        return "estoque";
    }

    @GetMapping("/estoque/novo")
    public String novoProduto(Model model) {

        model.addAttribute("itemForm", new ItemFormDTO());

        model.addAttribute("categorias", categoryService.listarTodas());

        model.addAttribute("modoEdicao", false);

        return "estoque-form";
    }

    @GetMapping("/estoque/{id}/editar")
    public String editarProduto(

            @PathVariable Integer id,

            Model model,

            RedirectAttributes redirectAttributes

    ) {

        Optional<ItemFormDTO> itemForm =
                itemService.buscarParaEdicao(id);


        if (itemForm.isEmpty()) {

            redirectAttributes.addFlashAttribute(
                    "mensagemErro",
                    "Produto não encontrado."
            );

            return "redirect:/estoque";
        }


        model.addAttribute(
                "itemForm",
                itemForm.get()
        );

        model.addAttribute(
                "categorias",
                categoryService.listarTodas()
        );

        model.addAttribute(
                "modoEdicao",
                true
        );

        model.addAttribute(
                "itemId",
                id
        );


        return "estoque-form";
    }

    @PostMapping("/estoque/{id}/editar")
    public String atualizarProduto(

            @PathVariable Integer id,

            @Valid
            @ModelAttribute("itemForm")
            ItemFormDTO itemForm,

            BindingResult bindingResult,

            Model model,

            RedirectAttributes redirectAttributes

    ) {


        /*
         * Verifica se existe OUTRO produto
         * usando o mesmo nome.
         */
        if (itemService.existePorNomeEmOutroItem(itemForm.getNome(), id)) {

            bindingResult.rejectValue("nome","nome.duplicado","Já existe outro produto com esse nome.");
        }


        /*
         * Retorna ao formulário
         * caso existam erros.
         */
        if (bindingResult.hasErrors()) {

            model.addAttribute("categorias", categoryService.listarTodas());

            model.addAttribute("modoEdicao", true);

            model.addAttribute("itemId", id);

            return "estoque-form";
        }


        boolean atualizado =  itemService.atualizar(id, itemForm);


        if (!atualizado) {

            redirectAttributes.addFlashAttribute("mensagemErro", "Produto não encontrado.");

            return "redirect:/estoque";
        }


        redirectAttributes.addFlashAttribute("mensagemSucesso","Produto atualizado com sucesso."
        );


        return "redirect:/estoque";
    }

    @PostMapping("/estoque/novo")
    public String cadastrarProduto(

            @Valid
            @ModelAttribute("itemForm")
            ItemFormDTO itemForm,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes

    ) {
        /*
         * Verifica nome duplicado.
         */
        if (itemService.existePorNome(itemForm.getNome())) {

            bindingResult.rejectValue("nome","nome.duplicado","Já existe um produto com esse nome.");
        }

        /*
         * Se houver qualquer erro,
         * retorna ao formulário.
         */
        if (bindingResult.hasErrors()) {

            model.addAttribute("categorias", categoryService.listarTodas());

            return "estoque-form";
        }
        /*
         * Grava o produto.
         */
        itemService.cadastrar(itemForm);

        /*
         * Mensagem para a próxima página.
         */
        redirectAttributes.addFlashAttribute("mensagemSucesso","Produto cadastrado com sucesso.");

        return "redirect:/estoque";
    }

    @PostMapping("/estoque/{id}/excluir")
    public String excluirProduto(@PathVariable Integer id, RedirectAttributes redirectAttributes) {

        try {

            boolean excluido = itemService.excluir(id);


            if (!excluido) {

                redirectAttributes.addFlashAttribute("mensagemErro","Produto não encontrado.");

                return "redirect:/estoque";
            }


            redirectAttributes.addFlashAttribute("mensagemSucesso","Produto excluído com sucesso.");


        } catch (ItemEmUsoException exception) {

            redirectAttributes.addFlashAttribute("mensagemErro", exception.getMessage());
        }


        return "redirect:/estoque";
    }
}