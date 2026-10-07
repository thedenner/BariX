package barix.com.br.controller;

import barix.com.br.entity.Category;
import barix.com.br.service.CategoryService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/categorias")
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping
    public List<Category> listarTodas() {
        return categoryService.listarTodas();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Category> buscarPorId(@PathVariable Integer id) {

        //Optional com Category ou Optional vazio
        Optional<Category> category = categoryService.buscarPorId(id);
        //Existe uma categoria dentro do Optional
        if (category.isPresent()) {
            //Se existir -> Pega o objeto Category
            return ResponseEntity.ok(category.get());
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping
    public Category criar(@RequestBody Category category) {
        return categoryService.salvar(category);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Category> atualizar(@PathVariable Integer id,
                                              @RequestBody Category category) {

        Optional<Category> categoryAtualizada = categoryService.atualizar(id, category);

        if (categoryAtualizada.isPresent()) {
            return ResponseEntity.ok(categoryAtualizada.get());
        }

        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> excluir(@PathVariable Integer id) {

        boolean excluida = categoryService.excluir(id);

        if (excluida) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.notFound().build();
    }

}

//Optional: imagine uma caixa que pode conter Category ou pode estar vazia.
