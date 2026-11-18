<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1"
    >

    <title>BariX - Estoque</title>

    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css"
    >

    <style>

        body {
            background-color: #f3f4f2;
        }

        .sidebar {
            min-height: 100vh;
            background-color: #163c2e;
        }

        .sidebar .nav-link {
            color: #ffffff;
        }

        .sidebar .nav-link:hover {
            background-color: rgba(255,255,255,0.08);
        }

        .sidebar .nav-link.active {
            background-color: #ffffff;
            color: #163c2e;
        }

        .brand-subtitle {
            font-size: 0.75rem;
            letter-spacing: 0.15rem;
        }

        .card-estoque {
            border: 0;
            border-radius: 12px;
        }

    </style>

</head>

<body>

<div class="container-fluid">

    <div class="row">


        <!-- SIDEBAR -->

        <aside class="col-md-2 sidebar p-4">

            <div class="text-white mb-5">

                <h2 class="fw-bold mb-0">
                    BARIX
                </h2>

                <div class="brand-subtitle">
                    GESTÃO DO BAR
                </div>

            </div>


            <nav class="nav flex-column gap-2">

                <a
                        class="nav-link rounded px-3 py-2"
                        href="${pageContext.request.contextPath}/"
                >
                    Início
                </a>

                <a
                        class="nav-link rounded px-3 py-2"
                        href="${pageContext.request.contextPath}/comandas"
                >
                    Comandas
                </a>

                <a
                        class="nav-link active rounded px-3 py-2"
                        href="${pageContext.request.contextPath}/estoque"
                >
                    Estoque
                </a>

                <a class="nav-link rounded px-3 py-2"
                   href="${pageContext.request.contextPath}/financeiro">

                    Financeiro

                </a>

            </nav>


            <div class="mt-5">

                <a
                        class="nav-link rounded px-3 py-2 text-white"
                        href="#"
                >
                    Sair
                </a>

            </div>

        </aside>


        <!-- CONTEÚDO -->

        <main class="col-md-10 p-5">


            <!-- CABEÇALHO -->

            <div class="mb-4">

                <h2 class="fw-bold">
                    Estoque
                </h2>

                <p class="text-secondary">
                    Consulte e acompanhe os produtos disponíveis no bar.
                </p>

            </div>

            <c:if test="${not empty mensagemSucesso}">

                <div
                        class="alert alert-success"
                        role="alert"
                >
                        ${mensagemSucesso}
                </div>

            </c:if>


            <!-- INDICADORES -->

            <div class="row g-4 mb-4">

                <div class="col-md-6">

                    <div class="card card-estoque shadow-sm">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Total de produtos
                            </p>

                            <h2 class="fw-bold mb-0">
                                ${totalItens}
                            </h2>

                        </div>

                    </div>

                </div>


                <div class="col-md-6">

                    <div class="card card-estoque shadow-sm">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Itens em alerta
                            </p>

                            <h2 class="fw-bold mb-0">
                                ${alertasEstoque}
                            </h2>

                        </div>

                    </div>

                </div>

            </div>


            <!-- TABELA -->

            <!-- ======================================
     FILTROS
======================================= -->

            <div class="card card-estoque shadow-sm mb-4">

                <div class="card-body p-4">

                    <form
                            method="get"
                            action="${pageContext.request.contextPath}/estoque"
                    >

                        <div class="row g-3">


                            <!-- BUSCA -->

                            <div class="col-md-4">

                                <label
                                        for="busca"
                                        class="form-label"
                                >
                                    Produto
                                </label>

                                <input
                                        type="text"
                                        id="busca"
                                        name="busca"
                                        class="form-control"
                                        value="${busca}"
                                        placeholder="Buscar produto"
                                >

                            </div>


                            <!-- CATEGORIA -->

                            <div class="col-md-3">

                                <label
                                        for="categoria"
                                        class="form-label"
                                >
                                    Categoria
                                </label>

                                <select
                                        id="categoria"
                                        name="categoria"
                                        class="form-select"
                                >

                                    <option value="">
                                        Todas
                                    </option>


                                    <c:forEach
                                            var="categoria"
                                            items="${categorias}"
                                    >

                                        <option
                                                value="${categoria.id}"
                                            ${categoriaSelecionada == categoria.id
                                                    ? 'selected'
                                                    : ''}
                                        >
                                                ${categoria.nome}
                                        </option>

                                    </c:forEach>

                                </select>

                            </div>


                            <!-- STATUS -->

                            <div class="col-md-3">

                                <label
                                        for="status"
                                        class="form-label"
                                >
                                    Status
                                </label>

                                <select
                                        id="status"
                                        name="status"
                                        class="form-select"
                                >

                                    <option value="">
                                        Todos
                                    </option>

                                    <option
                                            value="NORMAL"
                                    ${statusSelecionado == 'NORMAL'
                                            ? 'selected'
                                            : ''}
                                    >
                                        Normal
                                    </option>

                                    <option
                                            value="ALERTA"
                                    ${statusSelecionado == 'ALERTA'
                                            ? 'selected'
                                            : ''}
                                    >
                                        Alerta
                                    </option>

                                </select>

                            </div>


                            <!-- BOTÃO -->

                            <div class="col-md-2 d-flex align-items-end">

                                <button
                                        type="submit"
                                        class="btn btn-success w-100"
                                >
                                    Filtrar
                                </button>

                            </div>

                        </div>


                        <div class="mt-3">

                            <a
                                    href="${pageContext.request.contextPath}/estoque"
                                    class="text-secondary"
                            >
                                Limpar filtros
                            </a>

                        </div>

                    </form>

                </div>

            </div>

            <div class="card card-estoque shadow-sm">

                <div class="card-body p-4">

                    <div class="d-flex flex-wrap gap-2">

                        <a
                                href="${pageContext.request.contextPath}/estoque/movimentacoes"
                                class="btn btn-outline-success">

                            Movimentações

                        </a>

                        <a
                                href="${pageContext.request.contextPath}/estoque/novo"
                                class="btn btn-success">

                            Novo produto

                        </a>

                    </div>





                    <div class="table-responsive">

                        <table class="table table-hover align-middle">

                            <!-- CABEÇALHO -->
                            <thead>
                            <tr>
                                <th scope="col">Produto</th>
                                <th scope="col">Categoria</th>
                                <th scope="col">Estoque atual</th>
                                <th scope="col">Preço</th>
                                <th scope="col">Status</th>
                                <th scope="col">Ações</th>
                            </tr>
                            </thead>

                            <!-- DADOS -->
                            <tbody>

                            <c:forEach var="item" items="${itens}">

                                <tr>

                                    <!-- 1. PRODUTO -->
                                    <td class="fw-semibold">
                                        <c:out value="${item.nome}"/>
                                    </td>

                                    <!-- 2. CATEGORIA -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.category != null}">
                                                <c:out value="${item.category.nome}"/>
                                            </c:when>
                                            <c:otherwise>
                                <span class="text-secondary">
                                    Sem categoria
                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- 3. ESTOQUE ATUAL -->
                                    <td>
                                        <c:out value="${item.quantidade}"/> un.
                                    </td>

                                    <!-- 4. PREÇO -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.preco != null}">
                                                R$ <c:out value="${item.preco}"/>
                                            </c:when>
                                            <c:otherwise>
                                <span class="text-secondary">
                                    Não informado
                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- 5. STATUS -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.quantidade lt estoqueMinimo}">
                                <span class="badge bg-danger">
                                    Alerta
                                </span>
                                            </c:when>
                                            <c:otherwise>
                                <span class="badge bg-success">
                                    Normal
                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- 6. AÇÕES -->
                                    <td>
                                        <div class="d-flex gap-2">

                                            <!-- EDITAR -->
                                            <a
                                                    href="${pageContext.request.contextPath}/estoque/${item.id}/editar"
                                                    class="btn btn-sm btn-success">
                                                Editar
                                            </a>

                                            <!-- EXCLUIR -->
                                            <form
                                                    method="post"
                                                    action="${pageContext.request.contextPath}/estoque/${item.id}/excluir"
                                                    onsubmit="return confirm('Deseja realmente excluir este produto?');">

                                                <c:if test="${not empty _csrf}">
                                                    <input
                                                            type="hidden"
                                                            name="${_csrf.parameterName}"
                                                            value="${_csrf.token}">
                                                </c:if>

                                                <button
                                                        type="submit"
                                                        class="btn btn-sm btn-danger">
                                                    Excluir
                                                </button>

                                            </form>

                                        </div>
                                    </td>

                                </tr>

                            </c:forEach>

                            <!-- NENHUM PRODUTO -->
                            <c:if test="${empty itens}">
                                <tr>
                                    <td
                                            colspan="6"
                                            class="text-center text-secondary py-4">
                                        Nenhum produto encontrado.
                                    </td>
                                </tr>
                            </c:if>

                            </tbody>

                        </table>

                    </div>


                </div>

            </div>

        </main>

    </div>

</div>


<script
        src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js">
</script>

</body>

</html>