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

                    <div
                            class="d-flex justify-content-between align-items-center mb-4"
                    >

                        <h5 class="fw-bold mb-0">
                            Produtos
                        </h5>
                        <a
                                href="${pageContext.request.contextPath}/estoque/novo"
                                class="btn btn-success"
                        >
                            Novo produto
                        </a>

                    </div>


                    <div class="table-responsive">

                        <table class="table align-middle">

                            <thead>

                            <tr>

                                <th>
                                    Produto
                                </th>

                                <th>
                                    Categoria
                                </th>

                                <th>
                                    Estoque atual
                                </th>

                                <th>
                                    Preço
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Ações
                                </th>

                            </tr>

                            </thead>


                            <tbody>

                            <c:forEach
                                    var="item"
                                    items="${itens}"
                            >

                                <tr>

                                    <td>

                                        <div class="d-flex gap-2">

                                            <!-- EDITAR -->

                                            <a
                                                    href="${pageContext.request.contextPath}/estoque/${item.id}/editar"
                                                    class="btn btn-success"
                                            >
                                                Editar
                                            </a>


                                            <!-- EXCLUIR -->

                                            <form
                                                    method="post"
                                                    action="${pageContext.request.contextPath}/estoque/${item.id}/excluir"
                                                    onsubmit="return confirm('Deseja realmente excluir este produto?');"
                                            >

                                                <button
                                                        type="submit"
                                                        class="btn btn-danger"
                                                >
                                                    Excluir
                                                </button>

                                            </form>

                                        </div>

                                    </td>

                                    <td>
                                            ${item.nome}
                                    </td>


                                    <td>

                                        <c:choose>

                                            <c:when test="${item.category != null}">
                                                ${item.category.nome}
                                            </c:when>

                                            <c:otherwise>
                                                Sem categoria
                                            </c:otherwise>

                                        </c:choose>

                                    </td>


                                    <td>
                                            ${item.quantidade} un. - mínimo ${estoqueMinimo}
                                    </td>


                                    <td>
                                        R$ ${item.preco}
                                    </td>


                                    <td>

                                        <c:choose>

                                            <c:when test="${item.quantidade < estoqueMinimo}">

                                                <span class="text-danger fw-bold">
                                                    Alerta
                                                </span>

                                            </c:when>

                                            <c:otherwise>

                                                <span class="text-success fw-bold">
                                                    Normal
                                                </span>

                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                </tr>

                            </c:forEach>


                            <c:if test="${empty itens}">

                                <tr>

                                    <td>

                                        <a
                                                href="${pageContext.request.contextPath}/estoque/${item.id}/editar"
                                                class="btn btn-success"
                                        >
                                            Editar
                                        </a>

                                    </td>

                                    <td
                                            colspan="5"
                                            class="text-center text-secondary py-4"
                                    >
                                        Nenhum produto cadastrado.
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