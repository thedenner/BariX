package barix.com.br.controller;

import barix.com.br.dto.ResumoFinanceiroDTO;
import barix.com.br.service.CategoryService;
import barix.com.br.service.ItemService;
import barix.com.br.service.FinanceiroService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class FinanceiroViewController {

    private final FinanceiroService financeiroService;
    private final CategoryService categoryService;
    private final ItemService itemService;

    public FinanceiroViewController(
            FinanceiroService financeiroService,
            CategoryService categoryService,
            ItemService itemService
    ) {
        this.financeiroService = financeiroService;
        this.categoryService = categoryService;
        this.itemService = itemService;
    }

    @GetMapping("/financeiro")
    public String exibirFinanceiro(
            @RequestParam(defaultValue = "DIA") String periodo,
            @RequestParam(required = false) Integer categoriaId,
            @RequestParam(required = false) Integer itemId,
            Model model
    ) {
        String periodoNormalizado = financeiroService.normalizarPeriodo(periodo);
        ResumoFinanceiroDTO resumo = financeiroService.gerarResumo(periodoNormalizado, categoriaId, itemId);

        model.addAttribute("resumo", resumo);
        model.addAttribute("categorias", categoryService.listarTodas());
        model.addAttribute("itens", itemService.listarTodos());
        model.addAttribute("periodoSelecionado", periodoNormalizado);
        model.addAttribute("categoriaSelecionada", categoriaId);
        model.addAttribute("itemSelecionado", itemId);

        return "financeiro";
    }
}
