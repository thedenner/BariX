<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>

<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <meta
            name="viewport"
            content="width=device-width, initial-scale=1"
    >

    <title>BariX - Nova Comanda</title>

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

        .sidebar .nav-link.active {
            background-color: #ffffff;
            color: #163c2e;
        }

        .form-card {
            border: 0;
            border-radius: 12px;
        }

        .brand-subtitle {
            font-size: 0.75rem;
            letter-spacing: 0.15rem;
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

            <div class="mb-4">

                <h2 class="fw-bold">
                    Nova comanda
                </h2>

                <p class="text-secondary">
                    Informe o cliente para abrir uma nova comanda.
                </p>

            </div>


            <div class="card form-card shadow-sm">

                <div class="card-body p-4">


                    <form:form

                            method="post"

                            action="${pageContext.request.contextPath}/comandas/nova"

                            modelAttribute="comandaForm"

                    >


                        <div class="mb-4">

                            <label
                                    for="nomeCliente"
                                    class="form-label"
                            >
                                Nome do cliente
                            </label>


                            <form:input
                                    path="nomeCliente"
                                    id="nomeCliente"
                                    cssClass="form-control"
                                    placeholder="Ex.: Felipe"
                            />


                            <form:errors
                                    path="nomeCliente"
                                    cssClass="text-danger"
                            />

                        </div>


                        <div class="d-flex gap-2">

                            <button
                                    type="submit"
                                    class="btn btn-success"
                            >
                                Abrir comanda
                            </button>


                            <a
                                    href="${pageContext.request.contextPath}/comandas"
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