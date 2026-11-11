
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>BariX - Dashboard</title>

    <!-- BOOTSTRAP LOCAL -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">

    <style>
        :root {
            --barix-verde: #163c2e;
            --barix-fundo: #f3f4f2;
        }

        body {
            background-color: var(--barix-fundo);
        }

        /* SIDEBAR */

        .sidebar {
            min-height: 100vh;
            background-color: var(--barix-verde);
        }

        .sidebar .nav-link {
            color: #ffffff;
            transition: background-color 0.2s;
        }

        .sidebar .nav-link:hover {
            background-color: rgba(255,255,255,0.08);
        }

        .sidebar .nav-link.active {
            background-color: #ffffff;
            color: var(--barix-verde);
            font-weight: 600;
        }

        .brand-subtitle {
            font-size: 0.75rem;
            letter-spacing: 0.15rem;
        }

        /* CONTEÚDO */

        .dashboard-main {
            min-width: 0;
        }

        .card-dashboard {
            border: 0;
            border-radius: 12px;
        }

        .card-dashboard .card-body {
            min-width: 0;
        }

        .indicador-numero {
            font-size: 2rem;
            font-weight: 700;
        }

        /* MODAL */

        .modal-content {
            border: 0;
            border-radius: 14px;
            overflow: hidden;
        }

        .modal-header {
            background-color: var(--barix-verde);
            color: white;
        }

        .modal-header .btn-close {
            filter: invert(1) grayscale(100%) brightness(200%);
        }

        .modal-footer {
            border-top: 1px solid #eeeeee;
        }

        /* RESPONSIVIDADE */

        @media (max-width: 767.98px) {
            .sidebar {
                min-height: auto;
            }

            .dashboard-main {
                padding: 1.5rem !important;
            }

            .dashboard-section-header {
                align-items: flex-start !important;
                flex-direction: column;
                gap: 1rem;
            }
        }
    </style>
</head>

<body>

<div class="container-fluid px-0">

    <div class="row g-0">

        <!-- =====================================
             SIDEBAR
        ====================================== -->

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

                <a class="nav-link active rounded px-3 py-2"
                   href="${pageContext.request.contextPath}/">
                    Início
                </a>

                <a class="nav-link rounded px-3 py-2"
                   href="${pageContext.request.contextPath}/comandas">
                    Comandas
                </a>

                <a class="nav-link rounded px-3 py-2"
                   href="${pageContext.request.contextPath}/estoque">
                    Estoque
                </a>

            </nav>

            <div class="mt-5">

                <a class="nav-link rounded px-3 py-2 text-white"
                   href="#">
                    Sair
                </a>

            </div>

        </aside>


        <!-- =====================================
             CONTEÚDO PRINCIPAL
        ====================================== -->

        <main class="col-md-10 dashboard-main p-5">

            <!-- CABEÇALHO -->

            <div class="mb-4">

                <h2 class="fw-bold">
                    Olá, <c:out value="${nomeFuncionario}"/>!
                </h2>

                <p class="text-secondary">
                    Resumo do movimento do bar hoje.
                </p>

            </div>


            <!-- =================================
                 MENSAGENS DO BACKEND
            ================================== -->

            <c:if test="${not empty mensagemSucesso}">

                <div class="alert alert-success"
                     role="alert">
                    <c:out value="${mensagemSucesso}"/>
                </div>

            </c:if>

            <c:if test="${not empty mensagemErro}">

                <div class="alert alert-danger"
                     role="alert">
                    <c:out value="${mensagemErro}"/>
                </div>

            </c:if>


            <!-- =================================
                 INDICADORES
            ================================== -->

            <div class="row g-4 mb-4">

                <!-- COMANDAS ABERTAS -->

                <div class="col-md-4">

                    <div class="card card-dashboard shadow-sm h-100">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Comandas abertas
                            </p>

                            <div class="indicador-numero">
                                <c:out value="${comandasAbertas}"/>
                            </div>

                        </div>

                    </div>

                </div>


                <!-- TOTAL DE PRODUTOS -->

                <div class="col-md-4">

                    <div class="card card-dashboard shadow-sm h-100">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Total de produtos
                            </p>

                            <div class="indicador-numero">
                                <c:out value="${totalItens}"/>
                            </div>

                        </div>

                    </div>

                </div>


                <!-- ALERTAS DE ESTOQUE -->

                <div class="col-md-4">

                    <div class="card card-dashboard shadow-sm h-100">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Alertas de estoque
                            </p>

                            <div class="indicador-numero text-danger">
                                <c:out value="${alertasEstoque}"/>
                            </div>

                        </div>

                    </div>

                </div>

            </div>


            <!-- =================================
                 PARTE INFERIOR
            ================================== -->

            <div class="row g-4">


                <!-- =============================
                     ÚLTIMAS COMANDAS
                ============================== -->

                <div class="col-lg-8">

                    <div class="card card-dashboard shadow-sm">

                        <div class="card-body p-4">

                            <div class="d-flex justify-content-between align-items-center mb-4 dashboard-section-header">

                                <div>
                                    <h5 class="fw-bold mb-1">
                                        Últimas comandas
                                    </h5>

                                    <small class="text-secondary">
                                        Prévia visual — integração em andamento
                                    </small>
                                </div>

                                <!-- BOTÃO QUE ABRE O MODAL -->

                                <button
                                        type="button"
                                        class="btn btn-success"
                                        data-bs-toggle="modal"
                                        data-bs-target="#modalNovaComanda">

                                    + Nova comanda

                                </button>

                            </div>


                            <!-- EXEMPLOS VISUAIS TEMPORÁRIOS -->

                            <div class="row g-3">

                                <div class="col-md-6">

                                    <div class="border rounded p-3 h-100">

                                        <h6 class="fw-bold">
                                            Flora Antunes
                                        </h6>

                                        <p class="mb-1">
                                            Comanda #026
                                        </p>

                                        <small class="text-secondary">
                                            Exemplo visual
                                        </small>

                                        <div class="mt-3">
                                            <strong>
                                                R$ 164,90
                                            </strong>
                                        </div>

                                    </div>

                                </div>


                                <div class="col-md-6">

                                    <div class="border rounded p-3 h-100">

                                        <h6 class="fw-bold">
                                            Felipe Macedo
                                        </h6>

                                        <p class="mb-1">
                                            Comanda #029
                                        </p>

                                        <small class="text-secondary">
                                            Exemplo visual
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


                <!-- =============================
                     COLUNA DIREITA
                ============================== -->

                <div class="col-lg-4">

                    <!-- ESTOQUE EM ALERTA -->

                    <div class="card card-dashboard shadow-sm mb-4">

                        <div class="card-body p-4">

                            <h5 class="fw-bold mb-4">
                                Estoque em alerta
                            </h5>

                            <c:forEach
                                    var="item"
                                    items="${itensEmAlerta}">

                                <div class="mb-3">

                                    <strong>
                                        <c:out value="${item.nome}"/>
                                    </strong>

                                    <div class="text-danger">

                                        <c:out value="${item.quantidade}"/>
                                        un. - mínimo 10

                                    </div>

                                </div>

                            </c:forEach>


                            <c:if test="${empty itensEmAlerta}">

                                <p class="text-secondary mb-0">
                                    Nenhum produto em alerta.
                                </p>

                            </c:if>

                        </div>

                    </div>


                    <!-- ÚLTIMAS MOVIMENTAÇÕES -->

                    <div class="card card-dashboard shadow-sm">

                        <div class="card-body p-4">

                            <h5 class="fw-bold">
                                Últimas movimentações
                            </h5>

                            <small class="text-secondary">
                                Exemplos visuais
                            </small>

                            <hr>

                            <p>Comanda #027</p>
                            <p>Comanda #026</p>
                            <p class="mb-0">Comanda #025</p>

                        </div>

                    </div>

                </div>

            </div>

        </main>

    </div>

</div>


<!-- ==========================================
     MODAL — NOVA COMANDA
=========================================== -->

<div
        class="modal fade"
        id="modalNovaComanda"
        tabindex="-1"
        aria-labelledby="modalNovaComandaTitulo"
        aria-hidden="true">

    <div class="modal-dialog modal-dialog-centered">

        <div class="modal-content">

            <!-- CABEÇALHO -->

            <div class="modal-header">

                <h5 class="modal-title fw-bold"
                    id="modalNovaComandaTitulo">

                    Nova comanda

                </h5>

                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal"
                        aria-label="Fechar">
                </button>

            </div>


            <!-- FORMULÁRIO -->

            <form
                    method="post"
                    action="${pageContext.request.contextPath}/comandas/nova">

                <!-- CSRF: utilizado caso Spring Security esteja ativo -->

                <c:if test="${not empty _csrf}">
                    <input
                            type="hidden"
                            name="${_csrf.parameterName}"
                            value="${_csrf.token}">
                </c:if>


                <div class="modal-body">

                    <p class="text-secondary mb-4">
                        Informe o nome do cliente para abrir
                        uma nova comanda.
                    </p>

                    <div class="mb-3">

                        <label
                                for="nomeCliente"
                                class="form-label">

                            Nome do cliente

                        </label>

                        <input
                                type="text"
                                id="nomeCliente"
                                name="nomeCliente"
                                class="form-control"
                                maxlength="100"
                                required
                                placeholder="Ex.: Felipe">

                        <div class="form-text">
                            O nome será utilizado para identificar
                            a comanda.
                        </div>

                    </div>

                </div>


                <!-- BOTÕES -->

                <div class="modal-footer">

                    <button
                            type="button"
                            class="btn btn-secondary"
                            data-bs-dismiss="modal">

                        Cancelar

                    </button>

                    <button
                            type="submit"
                            class="btn btn-success">

                        Abrir comanda

                    </button>

                </div>

            </form>

        </div>

    </div>

</div>


<!-- ==========================================
     BOOTSTRAP JAVASCRIPT OFICIAL
=========================================== -->

<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>

</body>
</html>
