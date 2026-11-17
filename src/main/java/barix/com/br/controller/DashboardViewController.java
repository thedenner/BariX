package barix.com.br.controller;

import barix.com.br.dto.ComandaFormDTO;
import barix.com.br.entity.Comanda;
import barix.com.br.entity.Item;
import barix.com.br.service.ComandaService;
import barix.com.br.service.ItemService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class DashboardViewController {

    private final ItemService itemService;
    private final ComandaService comandaService;

    public DashboardViewController(ItemService itemService, ComandaService comandaService) {

        this.itemService = itemService;
        this.comandaService = comandaService;
    }

    @GetMapping("/")
    public String dashboard(Model model) { //Model é uma classe/interface do Spring MVC usada para transportar dados para a View

        long alertasEstoque = itemService.contarItensEmAlerta();

        List<Item> itensEmAlerta = itemService.listarItensEmAlerta();

        long totalItens = itemService.contarTotalItens();

        long comandasAbertas = comandaService.contarAbertas();

        List<Comanda> comandasRecentes = comandaService.listarRecentesAbertas();

        model.addAttribute("nomeFuncionario","Pedro");

        model.addAttribute("totalItens",totalItens);

        model.addAttribute("alertasEstoque", alertasEstoque);

        model.addAttribute("itensEmAlerta", itensEmAlerta);

        model.addAttribute("comandasAbertas", comandasAbertas);

        model.addAttribute("comandasRecentes",comandasRecentes);

        model.addAttribute("comandaForm", new ComandaFormDTO());

        return "dashboard";
        }


    }

