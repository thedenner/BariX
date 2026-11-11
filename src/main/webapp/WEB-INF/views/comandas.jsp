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

    <title>BariX - Comandas</title>

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

        .card-comanda {
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
                        class="nav-link active rounded px-3 py-2"
                >
                    Comandas
                </a>


                <a
                        href="${pageContext.request.contextPath}/estoque"
                        class="nav-link rounded px-3 py-2"
                >
                    Estoque
                </a>

            </nav>

        </aside>


        <!-- CONTEÚDO -->

        <main class="col-md-10 p-5">


            <!-- CABEÇALHO -->

            <div
                    class="d-flex justify-content-between align-items-center mb-4"
            >

                <div>

                    <h2 class="fw-bold">
                        Comandas
                    </h2>

                    <p class="text-secondary mb-0">
                        Gerencie as comandas abertas do bar.
                    </p>

                </div>


                <a
                        href="${pageContext.request.contextPath}/comandas/nova"
                        class="btn btn-success"
                >
                    + Nova comanda
                </a>

            </div>


            <!-- MENSAGEM -->

            <c:if test="${not empty mensagemSucesso}">

                <div
                        class="alert alert-success"
                        role="alert"
                >
                        ${mensagemSucesso}
                </div>

            </c:if>


            <!-- INDICADOR -->

            <div class="row mb-4">

                <div class="col-md-4">

                    <div class="card card-comanda shadow-sm">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Comandas abertas
                            </p>

                            <h2 class="fw-bold mb-0">
                                ${quantidadeAbertas}
                            </h2>

                        </div>

                    </div>

                </div>

            </div>


            <!-- LISTA -->

            <div class="row g-4">


                <c:forEach
                        var="comanda"
                        items="${comandasAbertas}"
                >

                    <div class="col-md-6 col-lg-4">

                        <div class="card card-comanda shadow-sm">

                            <div class="card-body p-4">

                                <div
                                        class="d-flex justify-content-between align-items-start mb-3"
                                >

                                    <div>

                                        <h5 class="fw-bold mb-1">
                                                ${comanda.nomeCliente}
                                        </h5>

                                        <span class="text-secondary">
                                            Comanda #${comanda.id}
                                        </span>

                                    </div>


                                    <span class="text-success fw-bold">
                                            ${comanda.status}
                                    </span>

                                </div>


                                <p class="text-secondary mb-0">
                                    Aberta em:
                                        ${comanda.dataAbertura}
                                </p>

                            </div>

                        </div>

                    </div>

                </c:forEach>


                <c:if test="${empty comandasAbertas}">

                    <div class="col-12">

                        <div class="card card-comanda shadow-sm">

                            <div class="card-body p-4 text-center">

                                <p class="text-secondary mb-0">
                                    Nenhuma comanda aberta.
                                </p>

                            </div>

                        </div>

                    </div>

                </c:if>

            </div>

        </main>

    </div>

</div>


<script
        src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js">
</script>


</body>

</html>