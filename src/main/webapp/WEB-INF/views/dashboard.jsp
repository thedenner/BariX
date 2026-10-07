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

    <title>BariX - Dashboard</title>

    <!-- BOOTSTRAP LOCAL -->
    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css"
    >

    <style>

        body {
            background-color: #f3f4f2;
        }

        /* =========================
           SIDEBAR
        ========================= */

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

        /* =========================
           CARDS
        ========================= */

        .card-dashboard {
            border: 0;
            border-radius: 12px;
        }

    </style>

</head>

<body>

<div class="container-fluid">

    <div class="row">

        <!-- ==========================================
             SIDEBAR
        =========================================== -->

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
                        class="nav-link active rounded px-3 py-2"
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
                        class="nav-link rounded px-3 py-2"
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


        <!-- ==========================================
             CONTEÚDO PRINCIPAL
        =========================================== -->

        <main class="col-md-10 p-5">


            <!-- ======================================
                 CABEÇALHO
            ======================================= -->

            <div class="mb-4">

                <h2 class="fw-bold">
                    Olá, ${nomeFuncionario}!
                </h2>

                <p class="text-secondary">
                    Resumo do movimento do bar hoje.
                </p>

            </div>


            <!-- ======================================
                 INDICADORES
            ======================================= -->

            <div class="row g-4 mb-4">


                <!-- COMANDAS ABERTAS -->

                <div class="col-md-4">

                    <div class="card card-dashboard shadow-sm">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Comandas abertas
                            </p>

                            <h2 class="fw-bold mb-0">
                                ${comandasAbertas}
                            </h2>

                        </div>

                    </div>

                </div>


                <!-- TOTAL DE PRODUTOS -->

                <div class="col-md-4">

                    <div class="card card-dashboard shadow-sm">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Total de produtos
                            </p>

                            <h2 class="fw-bold mb-0">
                                ${totalDeItens}
                            </h2>

                        </div>

                    </div>

                </div>


                <!-- ALERTAS DE ESTOQUE -->

                <div class="col-md-4">

                    <div class="card card-dashboard shadow-sm">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Alertas de estoque
                            </p>

                            <h2 class="fw-bold mb-0">
                                ${alertaEstoque}
                            </h2>

                        </div>

                    </div>

                </div>

            </div>


            <!-- ======================================
                 PARTE INFERIOR
            ======================================= -->

            <div class="row g-4">


                <!-- ==================================
                     ÚLTIMAS COMANDAS
                =================================== -->

                <div class="col-lg-8">

                    <div class="card card-dashboard shadow-sm">

                        <div class="card-body p-4">


                            <!-- CABEÇALHO -->

                            <div
                                    class="d-flex justify-content-between align-items-center mb-4"
                            >

                                <h5 class="fw-bold mb-0">
                                    Últimas comandas
                                </h5>

                                <button
                                        type="button"
                                        class="btn btn-success"
                                >
                                    + Nova comanda
                                </button>

                            </div>


                            <!-- COMANDAS -->

                            <div class="row g-3">


                                <!-- COMANDA EXEMPLO 1 -->

                                <div class="col-md-6">

                                    <div class="border rounded p-3">

                                        <h6 class="fw-bold">
                                            Flora Antunes
                                        </h6>

                                        <p class="mb-1">
                                            Comanda #026
                                        </p>

                                        <small class="text-secondary">
                                            Aberta há 02:08
                                        </small>

                                        <div class="mt-3">

                                            <strong>
                                                R$ 164,90
                                            </strong>

                                        </div>

                                    </div>

                                </div>


                                <!-- COMANDA EXEMPLO 2 -->

                                <div class="col-md-6">

                                    <div class="border rounded p-3">

                                        <h6 class="fw-bold">
                                            Felipe Macedo
                                        </h6>

                                        <p class="mb-1">
                                            Comanda #029
                                        </p>

                                        <small class="text-secondary">
                                            Aberta há 00:20
                                        </small>

                                        <div class="mt-3">

                                            <strong>
                                                R$ 41,00
                                            </strong>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </div>


                <!-- ==================================
                     COLUNA DIREITA
                =================================== -->

                <div class="col-lg-4">


                    <!-- ==============================
                         ESTOQUE EM ALERTA
                    =============================== -->

                    <div class="card card-dashboard shadow-sm mb-4">

                        <div class="card-body p-4">

                            <h5 class="fw-bold mb-4">
                                Estoque em alerta
                            </h5>


                            <!--
                                Percorre a List<Item>
                                enviada pelo DashboardViewController
                            -->

                            <c:forEach
                                    var="item"
                                    items="${itensEmAlerta}"
                            >

                                <div class="mb-3">

                                    <strong>
                                            ${item.nome}
                                    </strong>

                                    <div class="text-danger">
                                            ${item.quantidade} un. - mínimo 10
                                    </div>

                                </div>

                            </c:forEach>


                            <!--
                                Caso não exista nenhum produto
                                abaixo do estoque mínimo.
                            -->

                            <c:if test="${empty itensEmAlerta}">

                                <p class="text-secondary mb-0">
                                    Nenhum produto em alerta.
                                </p>

                            </c:if>

                        </div>

                    </div>


                    <!-- ==============================
                         ÚLTIMAS MOVIMENTAÇÕES
                    =============================== -->

                    <div class="card card-dashboard shadow-sm">

                        <div class="card-body p-4">

                            <h5 class="fw-bold">
                                Últimas movimentações
                            </h5>

                            <hr>

                            <p>
                                Comanda #027
                            </p>

                            <p>
                                Comanda #026
                            </p>

                            <p class="mb-0">
                                Comanda #025
                            </p>

                        </div>

                    </div>

                </div>

            </div>

        </main>

    </div>

</div>


<!-- BOOTSTRAP JAVASCRIPT LOCAL -->
<script
        src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js">
</script>

</body>

</html>