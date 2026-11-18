
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- CABEÇALHO DO MODAL -->

<div class="modal-header">

    <div>
        <h5 class="modal-title fw-bold mb-1">
            Comanda #<c:out value="${comanda.id}"/>
        </h5>

        <small>
            <c:out value="${comanda.nomeCliente}"/>
        </small>
    </div>

    <button
            type="button"
            class="btn-close"
            data-bs-dismiss="modal"
            aria-label="Fechar">
    </button>

</div>


<div class="modal-body">

    <!-- STATUS -->

    <div class="mb-4">

        <span class="badge bg-success">
            <c:out value="${comanda.status}"/>
        </span>

        <p class="text-secondary mt-2 mb-0">
            Abertura:
            <c:out value="${comanda.dataAbertura}"/>
        </p>

    </div>


    <!-- MENSAGENS -->

    <c:if test="${not empty mensagemSucessoDetalhes}">

        <div class="alert alert-success" role="alert">
            <c:out value="${mensagemSucessoDetalhes}"/>
        </div>

    </c:if>

    <c:if test="${not empty mensagemErroDetalhes}">

        <div class="alert alert-danger" role="alert">
            <c:out value="${mensagemErroDetalhes}"/>
        </div>

    </c:if>


    <!-- ADICIONAR PRODUTO -->

    <c:if test="${comanda.status eq 'ABERTA'}">

        <div class="border rounded p-3 mb-4">

            <h6 class="fw-bold mb-3">
                Adicionar produto
            </h6>

            <form
                    id="formAdicionarProdutoComanda"
                    method="post"
                    action="${pageContext.request.contextPath}/comandas/${comanda.id}/itens">

                <c:if test="${not empty _csrf}">
                    <input
                            type="hidden"
                            name="${_csrf.parameterName}"
                            value="${_csrf.token}">
                </c:if>

                <div class="row g-3">

                    <!-- PRODUTO -->

                    <div class="col-md-7">

                        <label
                                for="produtoId"
                                class="form-label">
                            Produto
                        </label>

                        <select
                                id="produtoId"
                                name="produtoId"
                                class="form-select"
                                required>

                            <option value="">
                                Selecione um produto
                            </option>

                            <c:forEach
                                    var="produto"
                                    items="${produtos}">

                                <option value="${produto.id}">
                                    <c:out value="${produto.nome}"/>
                                    — R$ <c:out value="${produto.preco}"/>
                                    — <c:out value="${produto.quantidade}"/> un.
                                </option>

                            </c:forEach>

                        </select>

                    </div>


                    <!-- QUANTIDADE -->

                    <div class="col-md-5">

                        <label
                                for="quantidade"
                                class="form-label">
                            Quantidade
                        </label>

                        <input
                                type="number"
                                id="quantidade"
                                name="quantidade"
                                class="form-control"
                                min="1"
                                value="1"
                                required>

                    </div>

                </div>


                <button
                        type="submit"
                        class="btn btn-success mt-3">

                    + Adicionar à comanda

                </button>

            </form>

        </div>

    </c:if>




    <!-- PRODUTOS CONSUMIDOS -->

    <h6 class="fw-bold mb-3">
        Produtos consumidos
    </h6>

    <div class="table-responsive">

        <table class="table table-hover align-middle">

            <thead>
            <tr>
                <th>Produto</th>
                <th>Qtd.</th>
                <th>Preço un.</th>
                <th>Subtotal</th>

                <c:if test="${comanda.status eq 'ABERTA'}">
                    <th>Ações</th>
                </c:if>
            </tr>
            </thead>

            <tbody>

            <c:forEach
                    var="linha"
                    items="${itensComanda}">

                <tr>

                    <td>
                        <c:out value="${linha.item.nome}"/>
                    </td>

                    <td>
                        <c:out value="${linha.quantidade}"/>
                    </td>

                    <td>
                        R$ <c:out value="${linha.precoUnitario}"/>
                    </td>

                    <td>
                        R$
                        <c:out value="${linha.precoUnitario * linha.quantidade}"/>
                    </td>

                    <!-- REMOVER -->

                    <c:if test="${comanda.status eq 'ABERTA'}">

                        <td>

                            <form
                                    method="post"
                                    class="form-remover-produto-comanda"
                                    action="${pageContext.request.contextPath}/comandas/${comanda.id}/itens/${linha.id}/remover">

                                <c:if test="${not empty _csrf}">
                                    <input
                                            type="hidden"
                                            name="${_csrf.parameterName}"
                                            value="${_csrf.token}">
                                </c:if>

                                <button
                                        type="submit"
                                        class="btn btn-sm btn-outline-danger">

                                    Remover

                                </button>

                            </form>

                        </td>

                    </c:if>

                </tr>

            </c:forEach>


            <!-- LISTA VAZIA -->

            <c:if test="${empty itensComanda}">

                <tr>
                    <td
                            colspan="${comanda.status eq 'ABERTA' and not somenteLeitura ? 5 : 4}"
                            class="text-center text-secondary py-4">

                        Nenhum produto adicionado.

                    </td>
                </tr>

            </c:if>

            </tbody>

        </table>

    </div>




    <!-- TOTAL -->

    <div class="border-top pt-3 text-end">

        <p class="text-secondary mb-1">
            Total da comanda
        </p>

        <h3 class="fw-bold text-success mb-0">
            R$ <c:out value="${totalComanda}"/>
        </h3>

    </div>

</div>



<!-- RODAPÉ DO MODAL -->

<div class="modal-footer d-flex flex-column align-items-stretch">

    <!-- FECHAMENTO DISPONÍVEL SOMENTE PARA ABERTAS -->

    <c:if test="${comanda.status eq 'ABERTA' and not somenteLeitura}">

        <form
                method="post"
                action="${pageContext.request.contextPath}/comandas/${comanda.id}/fechar"
                onsubmit="return confirm('Confirma o fechamento desta comanda e a baixa dos produtos no estoque?');">

            <c:if test="${not empty _csrf}">
                <input
                        type="hidden"
                        name="${_csrf.parameterName}"
                        value="${_csrf.token}">
            </c:if>

            <div class="mb-3">

                <label
                        for="funcionarioId"
                        class="form-label fw-semibold">

                    Funcionário responsável

                </label>

                <select
                        id="funcionarioId"
                        name="funcionarioId"
                        class="form-select"
                        required>

                    <option value="">
                        Selecione o funcionário
                    </option>

                    <c:forEach
                            var="funcionario"
                            items="${funcionariosAtivos}">

                        <option value="${funcionario.id}">
                            <c:out value="${funcionario.nome}"/>
                        </option>

                    </c:forEach>

                </select>

            </div>

            <c:if test="${empty funcionariosAtivos}">
                <p class="text-danger">
                    Nenhum funcionário ativo disponível
                    para registrar o fechamento.
                </p>
            </c:if>

            <button
                    type="submit"
                    class="btn btn-success w-100"
                ${empty funcionariosAtivos ? 'disabled' : ''}>

                Fechar comanda e baixar estoque

            </button>

        </form>

    </c:if>


    <c:if test="${comanda.status eq 'FECHADA'}">

        <p class="text-success fw-bold mb-0">
            Comanda finalizada.
        </p>

    </c:if>


    <button
            type="button"
            class="btn btn-outline-secondary"
            data-bs-dismiss="modal">

        Voltar ao Dashboard

    </button>

</div>

