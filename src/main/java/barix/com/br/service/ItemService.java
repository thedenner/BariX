package barix.com.br.service;

import barix.com.br.entity.Item;
import barix.com.br.repository.ItemRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ItemService {

    private final ItemRepository itemRepository;

    public ItemService(ItemRepository itemRepository) {
        this.itemRepository = itemRepository;
    }

    public long contarItensEmAlerta(){ //Quantos itens estão em alerta de estoque
        return itemRepository.countByQuantidadeLessThan(10);
    }

    public List<Item> listarItensEmAlerta(){//Quais itens estão em alerta
        return itemRepository.findByQuantidadeLessThanOrderByQuantidadeAsc(10);

    }

    public long contarTotalItens(){
        return itemRepository.count();
    }
}
