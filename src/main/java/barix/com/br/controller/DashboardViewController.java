package barix.com.br.controller;

import barix.com.br.entity.Item;
import barix.com.br.service.ItemService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class DashboardViewController {

    private final ItemService itemService;

    public DashboardViewController(ItemService itemService) {
        this.itemService = itemService;
    }

    @GetMapping("/")
    public String dashboard(Model model) { //Model é uma classe/interface do Spring MVC usada para transportar dados para a View

        long alertasEstoque = itemService.contarItensEmAlerta();

        List<Item> itensEmAlerta = itemService.listarItensEmAlerta();

        long totalItens = itemService.contarTotalItens();

        model.addAttribute("nomeFuncionario", "Pedro");
        model.addAttribute("comandasAbertas", 8);
        model.addAttribute("alertaEstoque", alertasEstoque);
        model.addAttribute("itensEmAlerta", itensEmAlerta);
        model.addAttribute("totalDeItens", totalItens);

        return "dashboard";
        }
    }

