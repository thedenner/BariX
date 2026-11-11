package barix.com.br.service;

import barix.com.br.dto.ItemFormDTO;
import barix.com.br.entity.Category;
import barix.com.br.entity.Item;
import barix.com.br.exception.ItemEmUsoException;
import barix.com.br.repository.ItemRepository;
import jakarta.transaction.Transactional;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ItemService {

    private static final int ESTOQUE_MINIMO = 10;

    private final ItemRepository itemRepository;
    private final CategoryService categoryService;

    public ItemService(ItemRepository itemRepository, CategoryService categoryService) {
        this.itemRepository = itemRepository;
        this.categoryService = categoryService;
    }

    public Optional<ItemFormDTO> buscarParaEdicao(Integer id) {

        return itemRepository.findById(id)
                .map(item -> {

                    ItemFormDTO dto =  new ItemFormDTO();

                    dto.setNome(item.getNome());

                    dto.setPreco(item.getPreco());

                    dto.setQuantidade(item.getQuantidade());

                    if (item.getCategory() != null) {

                        dto.setCategoriaId(item.getCategory().getId());
                    }

                    return dto;
                });
    }

    public boolean existePorNomeEmOutroItem(String nome, Integer id) {

        if (nome == null) {
            return false;
        }

        return itemRepository.existsByNomeIgnoreCaseAndIdNot(nome.trim(), id);
    }

    public boolean atualizar(Integer id, ItemFormDTO dados) {

        Optional<Item> itemExistente = itemRepository.findById(id);

        if (itemExistente.isEmpty()) {
            return false;
        }

        Category category = categoryService.buscarPorId(dados.getCategoriaId()).orElseThrow(() -> new IllegalArgumentException("Categoria não encontrada."));

        Item item = itemExistente.get();

        item.setNome(dados.getNome().trim());

        item.setPreco(dados.getPreco());

        item.setQuantidade(dados.getQuantidade());

        item.setCategory(category);

        itemRepository.save(item);

        return true;
    }


    public Item cadastrar(ItemFormDTO dados) {

        Category category = categoryService.buscarPorId(dados.getCategoriaId()).orElseThrow(() -> new IllegalArgumentException("Categoria não encontrada."));

        Item item = new Item();

        item.setNome(dados.getNome().trim());

        item.setPreco(dados.getPreco());

        item.setQuantidade(dados.getQuantidade());

        item.setCategory(category);


        return itemRepository.save(item);
    }

    public boolean existePorNome(String nome) {

        if (nome == null) {
            return false;
        }

        return itemRepository.existsByNomeIgnoreCase(nome.trim());
    }

    public long contarItensEmAlerta(){//Quantos itens estão em alerta de estoque
        return itemRepository.countByQuantidadeLessThan(ESTOQUE_MINIMO);
    }

    public List<Item> listarItensEmAlerta(){//Quais itens estão em alerta
        return itemRepository.findByQuantidadeLessThanOrderByQuantidadeAsc(ESTOQUE_MINIMO);

    }

    public long contarTotalItens(){
        return itemRepository.count();
    }

    public List<Item> listarTodos() {
        return itemRepository.findAll();
    }

    public List<Item> filtrarItens(String nome, Integer categoriaId, String status) {

        if (nome != null) {

            nome = nome.trim();

            if (nome.isEmpty()) {
                nome = null;
            }
        }

        if (status != null) {

            status = status.trim().toUpperCase();

            if (!status.equals("ALERTA") && !status.equals("NORMAL")) {

                status = null;
            }
        }

        return itemRepository.filtrar(nome, categoriaId, status, ESTOQUE_MINIMO);
    }

    public int getEstoqueMinimo() {
        return ESTOQUE_MINIMO;
    }

    @Transactional
    public boolean excluir(Integer id) {

        if (!itemRepository.existsById(id)) {
            return false;
        }

        try {

            itemRepository.deleteById(id);

            itemRepository.flush();

            return true;

        } catch (DataIntegrityViolationException exception) {

            throw new ItemEmUsoException(
                    "O produto não pode ser excluído porque possui registros relacionados."
            );
        }
    }
}



