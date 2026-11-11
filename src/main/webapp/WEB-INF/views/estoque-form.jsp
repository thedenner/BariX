<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>

<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1"
    >

    <title>BariX - Novo Produto</title>

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

        .form-card {
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
                        href="${pageContext.request.contextPath}/"
                        class="nav-link rounded px-3 py-2"
                >
                    Início
                </a>


                <a
                        href="${pageContext.request.contextPath}/comandas"
                        class="nav-link rounded px-3 py-2"
                >
                    Comandas
                </a>


                <a
                        href="${pageContext.request.contextPath}/estoque"
                        class="nav-link active rounded px-3 py-2"
                >
                    Estoque
                </a>

            </nav>

        </aside>


        <!-- CONTEÚDO -->

        <main class="col-md-10 p-5">


            <!-- CABEÇALHO -->

            <div class="mb-4">

                <h2 class="fw-bold">

                    <c:choose>

                        <c:when test="${modoEdicao}">
                            Editar produto
                        </c:when>

                        <c:otherwise>
                            Novo produto
                        </c:otherwise>

                    </c:choose>

                </h2>

                <p class="text-secondary">

                    <c:choose>

                        <c:when test="${modoEdicao}">
                            Atualize as informações do produto.
                        </c:when>

                        <c:otherwise>
                            Cadastre um novo item no estoque.
                        </c:otherwise>

                    </c:choose>

                </p>

            </div>


            <!-- FORMULÁRIO -->

            <div class="card form-card shadow-sm">

                <div class="card-body p-4">

                    <c:set
                            var="acaoFormulario"
                            value="${pageContext.request.contextPath}/estoque/novo"
                    />


                    <c:if test="${modoEdicao}">

                        <c:set
                                var="acaoFormulario"
                                value="${pageContext.request.contextPath}/estoque/${itemId}/editar"
                        />

                    </c:if>


                    <form:form

                            method="post"

                            action="${acaoFormulario}"

                            modelAttribute="itemForm"

                    >


                        <!-- NOME -->

                        <div class="mb-3">

                            <label
                                    for="nome"
                                    class="form-label"
                            >
                                Nome do produto
                            </label>

                            <form:input
                                    path="nome"
                                    id="nome"
                                    cssClass="form-control"
                            />

                            <form:errors
                                    path="nome"
                                    cssClass="text-danger"
                            />

                        </div>


                        <!-- PREÇO -->

                        <div class="mb-3">

                            <label
                                    for="preco"
                                    class="form-label"
                            >
                                Preço
                            </label>

                            <form:input
                                    path="preco"
                                    id="preco"
                                    type="number"
                                    step="0.01"
                                    min="0"
                                    cssClass="form-control"
                            />

                            <form:errors
                                    path="preco"
                                    cssClass="text-danger"
                            />

                        </div>


                        <!-- QUANTIDADE -->

                        <div class="mb-3">

                            <label
                                    for="quantidade"
                                    class="form-label"
                            >
                                Quantidade inicial
                            </label>

                            <form:input
                                    path="quantidade"
                                    id="quantidade"
                                    type="number"
                                    min="0"
                                    cssClass="form-control"
                            />

                            <form:errors
                                    path="quantidade"
                                    cssClass="text-danger"
                            />

                        </div>


                        <!-- CATEGORIA -->

                        <div class="mb-4">

                            <label
                                    for="categoriaId"
                                    class="form-label"
                            >
                                Categoria
                            </label>


                            <form:select

                                    path="categoriaId"

                                    id="categoriaId"

                                    cssClass="form-select"

                            >

                                <form:option
                                        value=""
                                        label="Selecione uma categoria"
                                />


                                <form:options

                                        items="${categorias}"

                                        itemValue="id"

                                        itemLabel="nome"

                                />

                            </form:select>


                            <form:errors

                                    path="categoriaId"

                                    cssClass="text-danger"

                            />

                        </div>


                        <!-- BOTÕES -->

                        <div class="d-flex gap-2">

                            <button
                                    type="submit"
                                    class="btn btn-success"
                            >

                                <c:choose>

                                    <c:when test="${modoEdicao}">
                                        Salvar alterações
                                    </c:when>

                                    <c:otherwise>
                                        Cadastrar produto
                                    </c:otherwise>

                                </c:choose>

                            </button>


                            <a
                                    href="${pageContext.request.contextPath}/estoque"
                                    class="btn btn-secondary"
                            >
                                Cancelar
                            </a>

                        </div>


                    </form:form>

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