
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>BariX - Movimentações</title>

    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">

    <style>

        body {
            background-color: #f3f4f2;
        }

        .sidebar {
            min-height: 100vh;
            background-color: #163c2e;
        }

        .sidebar .nav-link {
            color: #fff;
        }

        .sidebar .nav-link.active {
            background-color: #fff;
            color: #163c2e;
            font-weight: 600;
        }

        .card-barix {
            border: 0;
            border-radius: 12px;
        }

        @media (max-width: 767.98px) {

            .sidebar {
                min-height: auto;
            }

            .conteudo {
                padding: 1.5rem !important;
            }
        }

    </style>

</head>

<body>

<div class="container-fluid px-0">
    <div class="row g-0">

        <!-- SIDEBAR -->

        <aside class="col-md-2 sidebar p-4">

            <div class="text-white mb-5">
                <h2 class="fw-bold mb-0">BARIX</h2>
                <small>GESTÃO DO BAR</small>
            </div>

            <nav class="nav flex-column gap-2">

                <a class="nav-link rounded"
                   href="${pageContext.request.contextPath}/">
                    Início
                </a>

                <a class="nav-link rounded"
                   href="${pageContext.request.contextPath}/comandas">
                    Comandas
                </a>

                <a class="nav-link active rounded"
                   href="${pageContext.request.contextPath}/estoque">
                    Estoque
                </a>

                <a class="nav-link rounded px-3 py-2"
                   href="${pageContext.request.contextPath}/financeiro">

                    Financeiro

                </a>

            </nav>

        </aside>


        <!-- CONTEÚDO -->

        <main class="col-md-10 p-5 conteudo">

            <div class="d-flex flex-wrap
                        justify-content-between
                        align-items-center mb-4 gap-3">

                <div>

                    <h2 class="fw-bold mb-1">
                        Movimentações de estoque
                    </h2>

                    <p class="text-secondary mb-0">
                        Gerencie entradas e saídas de produtos.
                    </p>

                </div>

                <a
                        class="btn btn-outline-success"
                        href="${pageContext.request.contextPath}/estoque">

                    Voltar ao estoque

                </a>

            </div>


            <!-- MENSAGENS -->

            <c:if test="${not empty mensagemSucesso}">

                <div class="alert alert-success">
                    <c:out value="${mensagemSucesso}"/>
                </div>

            </c:if>

            <c:if test="${not empty mensagemErro}">

                <div class="alert alert-danger">
                    <c:out value="${mensagemErro}"/>
                </div>

            </c:if>


            <!-- FORMULÁRIO -->

            <div class="card card-barix shadow-sm mb-4">

                <div class="card-body p-4">

                    <h5 class="fw-bold mb-4">
                        Nova movimentação
                    </h5>

                    <form
                            method="post"
                            action="${pageContext.request.contextPath}/estoque/movimentacoes"
                            onsubmit="return confirm('Confirma esta movimentação de estoque?');">

                        <c:if test="${not empty _csrf}">

                            <input
                                    type="hidden"
                                    name="${_csrf.parameterName}"
                                    value="${_csrf.token}">

                        </c:if>

                        <div class="row g-3">


                            <!-- PRODUTO -->

                            <div class="col-lg-4 col-md-6">

                                <label for="produtoId"
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

                                        <option
                                                value="${produto.id}"
                                            ${movimentacaoForm.produtoId eq produto.id ? 'selected' : ''}>

                                            <c:out value="${produto.nome}"/>
                                            (<c:out value="${produto.quantidade}"/> un.)

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>


                            <!-- TIPO -->

                            <div class="col-lg-2 col-md-6">

                                <label for="tipo"
                                       class="form-label">
                                    Tipo
                                </label>

                                <select
                                        id="tipo"
                                        name="tipo"
                                        class="form-select"
                                        required>

                                    <option
                                            value="ENTRADA"
                                    ${movimentacaoForm.tipo eq 'ENTRADA' ? 'selected' : ''}>
                                        Entrada
                                    </option>

                                    <option
                                            value="SAÍDA"
                                    ${movimentacaoForm.tipo eq 'SAÍDA' ? 'selected' : ''}>
                                        Saída
                                    </option>

                                </select>

                            </div>


                            <!-- QUANTIDADE -->

                            <div class="col-lg-2 col-md-6">

                                <label for="quantidade"
                                       class="form-label">
                                    Quantidade
                                </label>

                                <input
                                        id="quantidade"
                                        name="quantidade"
                                        type="number"
                                        min="1"
                                        max="2147483647"
                                        class="form-control"
                                        value="<c:out value='${movimentacaoForm.quantidade}'/>"
                                        required>

                            </div>


                            <!-- FUNCIONÁRIO -->

                            <div class="col-lg-4 col-md-6">

                                <label for="funcionarioId"
                                       class="form-label">
                                    Funcionário responsável
                                </label>

                                <select
                                        id="funcionarioId"
                                        name="funcionarioId"
                                        class="form-select"
                                        required>

                                    <option value="">
                                        Selecione
                                    </option>

                                    <c:forEach
                                            var="funcionario"
                                            items="${funcionariosAtivos}">

                                        <option
                                                value="${funcionario.id}"
                                            ${movimentacaoForm.funcionarioId eq funcionario.id ? 'selected' : ''}>

                                            <c:out value="${funcionario.nome}"/>

                                        </option>

                                    </c:forEach>

                                </select>

                            </div>

                        </div>


                        <button
                                type="submit"
                                class="btn btn-success mt-4"
                        ${empty funcionariosAtivos or empty produtos ? 'disabled' : ''}>

                            Registrar movimentação

                        </button>

                    </form>

                </div>

            </div>


            <!-- HISTÓRICO -->

            <div class="card card-barix shadow-sm">

                <div class="card-body p-4">

                    <h5 class="fw-bold mb-2">
                        Histórico de movimentações
                    </h5>

                    <p class="text-secondary mb-4">

                        Total de registros:
                        <c:out value="${totalMovimentacoes}"/>

                    </p>


                    <div class="table-responsive">

                        <table class="table table-hover align-middle">

                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Produto</th>
                                <th>Tipo</th>
                                <th>Quantidade</th>
                                <th>Funcionário</th>
                                <th>Origem</th>
                                <th>Data</th>
                            </tr>
                            </thead>

                            <tbody>

                            <c:forEach
                                    var="mov"
                                    items="${movimentacoes}">

                                <tr>

                                    <td>
                                        #<c:out value="${mov.id}"/>
                                    </td>

                                    <td>
                                        <c:out value="${mov.item.nome}"/>
                                    </td>


                                    <!-- TIPO -->

                                    <td>

                                        <c:choose>

                                            <c:when test="${mov.tipo eq 'ENTRADA'}">

                                                    <span class="badge bg-success">
                                                        Entrada
                                                    </span>

                                            </c:when>

                                            <c:when test="${mov.tipo eq 'SAÍDA'}">

                                                    <span class="badge bg-danger">
                                                        Saída
                                                    </span>

                                            </c:when>

                                            <c:otherwise>

                                                <c:out value="${mov.tipo}"/>

                                            </c:otherwise>

                                        </c:choose>

                                    </td>


                                    <!-- QUANTIDADE -->

                                    <td class="fw-semibold">

                                        <c:choose>

                                            <c:when test="${mov.tipo eq 'ENTRADA'}">

                                                    <span class="text-success">
                                                        +<c:out value="${mov.quantidade}"/>
                                                    </span>

                                            </c:when>

                                            <c:when test="${mov.tipo eq 'SAÍDA'}">

                                                    <span class="text-danger">
                                                        -<c:out value="${mov.quantidade}"/>
                                                    </span>

                                            </c:when>

                                            <c:otherwise>

                                                <c:out value="${mov.quantidade}"/>

                                            </c:otherwise>

                                        </c:choose>

                                    </td>


                                    <!-- FUNCIONÁRIO -->

                                    <td>
                                        <c:out value="${mov.funcionario.nome}"/>
                                    </td>


                                    <!-- ORIGEM -->

                                    <td>

                                        <c:choose>

                                            <c:when test="${not empty mov.comanda}">

                                                Comanda
                                                #<c:out value="${mov.comanda.id}"/>

                                            </c:when>

                                            <c:otherwise>

                                                Sem comanda

                                            </c:otherwise>

                                        </c:choose>

                                    </td>


                                    <td>
                                        <c:out value="${mov.dataHora}"/>
                                    </td>

                                </tr>

                            </c:forEach>


                            <c:if test="${empty movimentacoes}">

                                <tr>

                                    <td
                                            colspan="7"
                                            class="text-center text-secondary py-4">

                                        Nenhuma movimentação registrada.

                                    </td>

                                </tr>

                            </c:if>

                            </tbody>

                        </table>

                    </div>


                    <!-- PAGINAÇÃO -->

                    <c:if test="${totalMovimentacoes gt 0}">

                        <div class="d-flex flex-wrap
                                    justify-content-between
                                    align-items-center gap-3 mt-3">

                            <span class="text-secondary">

                                Página ${paginaAtual + 1}
                                de ${totalPaginas}

                            </span>

                            <div class="d-flex gap-2">

                                <c:if test="${temAnterior}">

                                    <a
                                            class="btn btn-outline-secondary btn-sm"
                                            href="${pageContext.request.contextPath}/estoque/movimentacoes?pagina=${paginaAnterior}">

                                        Anterior

                                    </a>

                                </c:if>

                                <c:if test="${temProxima}">

                                    <a
                                            class="btn btn-outline-success btn-sm"
                                            href="${pageContext.request.contextPath}/estoque/movimentacoes?pagina=${proximaPagina}">

                                        Próxima

                                    </a>

                                </c:if>

                            </div>

                        </div>

                    </c:if>

                </div>

            </div>

        </main>

    </div>
</div>

<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
