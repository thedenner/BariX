package barix.com.br.repository;

import barix.com.br.entity.ComandaItem;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ComandaItemRepository
        extends JpaRepository<ComandaItem, Integer> {

    List<ComandaItem> findByComandaId(
            Integer comandaId
    );

}