package barix.com.br.service;

import barix.com.br.entity.Category;
import barix.com.br.repository.CategoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoriaRepository) {
        this.categoryRepository = categoriaRepository;
    }

    public List<Category> listarTodas() {
        return categoryRepository.findAll();
    }

    public Category salvar(Category category) {
        return categoryRepository.save(category);
    }

//    O Service diz:
//
//    encontrei ou não encontrei uma categoria.
//
//    O Controller decide:
//
//    qual resposta HTTP devo devolver?
    public Optional<Category> buscarPorId(Integer id) {
        return categoryRepository.findById(id);
    }


//    O Controller vai dizer:
//
//    Quero atualizar a categoria 8 com estes dados.
//
//    Mas alguém precisa decidir:
//
//    a categoria 8 existe?
//    se existir, qual objeto deve ser alterado?
//    quais campos serão modificados?
//    qual objeto deve ser salvo?

    public Optional<Category> atualizar (Integer Id, Category dadosAtualizados) {

        //Perguntamos ao banco: Existe uma categoria com esse ID?
        Optional<Category> categoriaExistente = categoryRepository.findById(Id);

        if (categoriaExistente.isEmpty()) {

            //Se não existir valor e se estiver vazio,
            //o Service retorna que está vazio

            return Optional.empty();
        }

        //Se existir, cai nessa linha.
        //E temos o registro do objeto qeu ele resgatou.
        Category category = categoriaExistente.get();

        //Ele atribui um novo nome com o metodo SetNome
        category.setNome(dadosAtualizados.getNome());

        //Aqui a biblioteca JPA entende que,
        //por ser um objeto já existente
        //ele apenas faz um UPDATE com o save().
        Category categorySalva = categoryRepository.save(category);

        //O Optional.of significa "crie um Optional contendo este objeto."
        return Optional.of(categorySalva);

    }

    public boolean excluir(Integer id) {

        if (!categoryRepository.existsById(id)) {
            return false;
        }

        categoryRepository.deleteById(id);

        return true;
    }
}

