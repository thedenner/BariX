package barix.com.br.repository;

import barix.com.br.entity.Item;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ItemRepository extends JpaRepository<Item, Integer> {

    long countByQuantidadeLessThan(Integer quantidade); //conta a quantidade de itens menor que a quantidade definida

    //Busque os itens cuja quantidade
    //seja menor que determinado número e
    //ordene pela quantidade do menor para o maior
    List<Item> findByQuantidadeLessThanOrderByQuantidadeAsc(Integer quantidade);

}
