
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

                <a class="nav-link rounded px-3 py-2"
                   href="${pageContext.request.contextPath}/financeiro">

                    Financeiro

                </a>

            </nav>

            <!-- LOGOUT -->

            <form
                    method="post"
                    action="${pageContext.request.contextPath}/logout"
                    class="mt-4">

                <input
                        type="hidden"
                        name="${_csrf.parameterName}"
                        value="${_csrf.token}">

                <button
                        type="submit"
                        class="btn btn-outline-light w-100">

                    Sair

                </button>

            </form>

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


                <!-- ======================================
                     INDICADORES DO DASHBOARD
                ======================================= -->

                <div class="row g-4 mb-4">

                    <!-- COMANDAS ABERTAS -->
                    <div class="col-md-4">
                        <div class="card card-dashboard shadow-sm h-100">
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
                        <div class="card card-dashboard shadow-sm h-100">
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

                    <!-- ALERTAS DE ESTOQUE -->
                    <div class="col-md-4">
                        <div class="card card-dashboard shadow-sm h-100">
                            <div class="card-body p-4">

                                <p class="text-secondary mb-2">
                                    Alertas de estoque
                                </p>

                                <h2 class="fw-bold mb-0 text-danger">
                                    ${alertasEstoque}
                                </h2>

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

                                    Nova comanda

                                </button>

                            </div>


                            <!-- EXEMPLOS VISUAIS TEMPORÁRIOS -->


                            <!-- COMANDAS REAIS DO BANCO -->

                            <div class="row g-3">

                                <c:forEach
                                        var="comanda"
                                        items="${comandasRecentes}">

                                    <div class="col-md-6">

                                        <div class="border rounded p-3 h-100">

                                            <div class="d-flex justify-content-between
                            align-items-start mb-2">

                                                <h6 class="fw-bold mb-0">
                                                    <c:out value="${comanda.nomeCliente}"/>
                                                </h6>

                                                <span class="badge bg-success">
                        ABERTA
                    </span>

                                            </div>

                                            <p class="text-secondary mb-2">
                                                Comanda #<c:out value="${comanda.id}"/>
                                            </p>

                                            <small class="text-secondary">
                                                Aberta em:
                                                <c:out value="${comanda.dataAbertura}"/>
                                            </small>

                                            <div class="mt-3">

                                                <button
                                                        type="button"
                                                        class="btn btn-outline-success btn-sm"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#modalDetalhesComanda"
                                                        data-comanda-id="${comanda.id}">

                                                    Ver detalhes

                                                </button>

                                            </div>

                                        </div>

                                    </div>

                                </c:forEach>

                                <c:if test="${empty comandasRecentes}">

                                    <div class="col-12">

                                        <p class="text-secondary mb-0">
                                            Nenhuma comanda aberta no momento.
                                        </p>

                                    </div>

                                </c:if>

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

<!-- MODAL - DETALHES DA COMANDA -->

<div
        class="modal fade"
        id="modalDetalhesComanda"
        tabindex="-1"
        aria-hidden="true">

    <div class="modal-dialog
                modal-lg
                modal-dialog-centered
                modal-dialog-scrollable">

        <div
                class="modal-content"
                id="conteudoDetalhesComanda">

            <div class="modal-body p-4">
                Carregando...
            </div>

        </div>

    </div>

</div>


<!-- ==========================================
     BOOTSTRAP JAVASCRIPT OFICIAL
=========================================== -->

<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>



<script>
    document.addEventListener("DOMContentLoaded", function () {

        const modal = document.getElementById(
            "modalDetalhesComanda"
        );

        const conteudo = document.getElementById(
            "conteudoDetalhesComanda"
        );

        if (!modal || !conteudo) {
            return;
        }

        /*
         * Executa uma requisição HTTP e retorna
         * o fragmento HTML gerado pelo Spring MVC.
         */
        async function carregarFragmento(url, opcoes = {}) {

            const resposta = await fetch(url, {
                ...opcoes,
                headers: {
                    "Accept": "text/html",
                    ...(opcoes.headers || {})
                }
            });

            if (!resposta.ok) {
                throw new Error(
                    "Erro HTTP " + resposta.status
                );
            }

            return resposta.text();
        }


        /*
         * 1. ABRIR DETALHES
         */
        modal.addEventListener(
            "show.bs.modal",
            async function (event) {

                const botao = event.relatedTarget;

                const comandaId = botao?.getAttribute(
                    "data-comanda-id"
                );

                conteudo.textContent = "Carregando detalhes...";

                if (!comandaId || !/^\d+$/.test(comandaId)) {
                    conteudo.textContent = "Comanda inválida.";
                    return;
                }

                try {

                    const url =
                        "${pageContext.request.contextPath}/comandas/"
                        + encodeURIComponent(comandaId)
                        + "/detalhes";

                    conteudo.innerHTML =
                        await carregarFragmento(url);

                } catch (erro) {

                    console.error(erro);

                    conteudo.textContent =
                        "Não foi possível carregar a comanda.";
                }
            }
        );


        /*
         * 2. ADICIONAR OU REMOVER PRODUTOS
         *
         * Utilizamos event delegation porque
         * os formulários são recriados quando
         * substituímos o HTML do Modal.
         */
        modal.addEventListener(
            "submit",
            async function (event) {

                const formulario = event.target;

                const ehInclusao = formulario.matches(
                    "#formAdicionarProdutoComanda"
                );

                const ehRemocao = formulario.matches(
                    ".form-remover-produto-comanda"
                );

                if (!ehInclusao && !ehRemocao) {
                    return;
                }

                event.preventDefault();


                // Confirma antes de remover uma linha.

                if (ehRemocao) {

                    const confirmado = confirm(
                        "Deseja remover este produto da comanda?"
                    );

                    if (!confirmado) {
                        return;
                    }
                }


                const botao = formulario.querySelector(
                    'button[type="submit"]'
                );

                if (botao) {
                    botao.disabled = true;
                }


                try {

                    const dados = new URLSearchParams(
                        new FormData(formulario)
                    );

                    const html = await carregarFragmento(
                        formulario.action,
                        {
                            method: "POST",
                            body: dados
                        }
                    );

                    /*
                     * O servidor redireciona para
                     * GET /comandas/{id}/detalhes.
                     *
                     * fetch acompanha o redirecionamento
                     * e recebe o HTML atualizado.
                     */
                    conteudo.innerHTML = html;

                } catch (erro) {

                    console.error(
                        "Erro ao modificar a comanda:",
                        erro
                    );

                    const aviso = document.createElement(
                        "div"
                    );

                    aviso.className = "alert alert-danger mt-3";

                    aviso.textContent =
                        "Não foi possível concluir a operação.";

                    formulario.prepend(aviso);

                } finally {

                    if (botao && botao.isConnected) {
                        botao.disabled = false;
                    }
                }
            }
        );

    });
</script>

</body>
</html>
