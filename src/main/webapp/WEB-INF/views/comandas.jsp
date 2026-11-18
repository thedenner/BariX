
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>BariX - Histórico de Comandas</title>

    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/bootstrap/css/bootstrap.min.css">

    <style>
        :root {
            --barix-verde: #163c2e;
            --barix-fundo: #f3f4f2;
        }

        body {
            background-color: var(--barix-fundo);
        }

        .sidebar {
            min-height: 100vh;
            background-color: var(--barix-verde);
        }

        .sidebar .nav-link {
            color: #fff;
        }

        .sidebar .nav-link:hover {
            background-color: rgba(255,255,255,0.08);
        }

        .sidebar .nav-link.active {
            background-color: #fff;
            color: var(--barix-verde);
            font-weight: 600;
        }

        .brand-subtitle {
            font-size: 0.75rem;
            letter-spacing: 0.15rem;
        }

        .card-barix {
            border: 0;
            border-radius: 12px;
        }

        .comanda-card {
            height: 100%;
        }

        .comanda-card .card-body {
            display: flex;
            flex-direction: column;
        }

        .comanda-card .btn {
            margin-top: auto;
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

                <div class="brand-subtitle">
                    GESTÃO DO BAR
                </div>
            </div>

            <nav class="nav flex-column gap-2">

                <a
                        class="nav-link rounded px-3 py-2"
                        href="${pageContext.request.contextPath}/">
                    Início
                </a>

                <a
                        class="nav-link active rounded px-3 py-2"
                        href="${pageContext.request.contextPath}/comandas">
                    Comandas
                </a>

                <a
                        class="nav-link rounded px-3 py-2"
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

            <!-- CABEÇALHO -->

            <div class="d-flex flex-wrap justify-content-between
                        align-items-center gap-3 mb-4">

                <div>
                    <h2 class="fw-bold mb-1">Comandas</h2>

                    <p class="text-secondary mb-0">
                        Acompanhe comandas abertas e consulte
                        o histórico de fechamentos.
                    </p>
                </div>

                <a
                        href="${pageContext.request.contextPath}/"
                        class="btn btn-outline-success">
                    Voltar ao Dashboard
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


            <!-- ===================================
                 FILTROS DINÂMICOS
            ==================================== -->

            <div class="card card-barix shadow-sm mb-4">

                <div class="card-body p-4">

                    <h5 class="fw-bold mb-1">
                        Filtros de pesquisa
                    </h5>

                    <p class="text-secondary mb-4">
                        Localize comandas por cliente, período ou status.
                    </p>


                    <form
                            method="get"
                            action="${pageContext.request.contextPath}/comandas">

                        <div class="row g-3">

                            <!-- CLIENTE -->

                            <div class="col-lg-4 col-md-6">

                                <label
                                        for="cliente"
                                        class="form-label">

                                    Nome do cliente

                                </label>

                                <input
                                        type="text"
                                        id="cliente"
                                        name="cliente"
                                        class="form-control"
                                        maxlength="100"
                                        placeholder="Pesquisar cliente..."
                                        value="<c:out value='${filtro.cliente}'/>">

                            </div>


                            <!-- DATA INICIAL -->

                            <div class="col-lg-2 col-md-6">

                                <label
                                        for="dataInicial"
                                        class="form-label">

                                    Data inicial

                                </label>

                                <input
                                        type="date"
                                        id="dataInicial"
                                        name="dataInicial"
                                        class="form-control"
                                        value="<c:out value='${filtro.dataInicial}'/>">

                            </div>


                            <!-- DATA FINAL -->

                            <div class="col-lg-2 col-md-6">

                                <label
                                        for="dataFinal"
                                        class="form-label">

                                    Data final

                                </label>

                                <input
                                        type="date"
                                        id="dataFinal"
                                        name="dataFinal"
                                        class="form-control"
                                        value="<c:out value='${filtro.dataFinal}'/>">

                            </div>


                            <!-- STATUS -->

                            <div class="col-lg-2 col-md-6">

                                <label
                                        for="status"
                                        class="form-label">

                                    Status

                                </label>

                                <select
                                        id="status"
                                        name="status"
                                        class="form-select">

                                    <option
                                            value="TODAS"
                                    ${filtro.status eq 'TODAS' ? 'selected' : ''}>
                                        Todas
                                    </option>

                                    <option
                                            value="ABERTA"
                                    ${filtro.status eq 'ABERTA' ? 'selected' : ''}>
                                        Abertas
                                    </option>

                                    <option
                                            value="FECHADA"
                                    ${filtro.status eq 'FECHADA' ? 'selected' : ''}>
                                        Fechadas
                                    </option>

                                </select>

                            </div>


                            <!-- BOTÃO PESQUISAR -->

                            <div class="col-lg-2 d-flex align-items-end">

                                <button
                                        type="submit"
                                        class="btn btn-success w-100">

                                    Pesquisar

                                </button>

                            </div>

                        </div>


                        <div class="d-flex flex-wrap
                        align-items-center
                        justify-content-between
                        gap-3 mt-3">

                            <small class="text-secondary">
                                O período considera a abertura das comandas
                                abertas e o fechamento das encerradas.
                            </small>

                            <a
                                    href="${pageContext.request.contextPath}/comandas"
                                    class="btn btn-outline-secondary btn-sm">

                                Limpar filtros

                            </a>

                        </div>

                    </form>

                </div>

            </div>


            <!-- ERRO DE VALIDAÇÃO -->

            <c:if test="${not empty erroFiltro}">

                <div class="alert alert-danger" role="alert">

                    <c:out value="${erroFiltro}"/>

                </div>

            </c:if>

            <c:if test="${empty erroFiltro}">

            <!-- INDICADORES -->

            <div class="row g-4 mb-5">

                <div class="col-md-6">

                    <div class="card card-barix shadow-sm h-100">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Comandas abertas
                            </p>

                            <h2 class="fw-bold mb-0 text-success">
                                <c:out value="${quantidadeAbertas}"/>
                            </h2>

                        </div>

                    </div>

                </div>


                <div class="col-md-6">

                    <div class="card card-barix shadow-sm h-100">

                        <div class="card-body p-4">

                            <p class="text-secondary mb-2">
                                Comandas fechadas
                            </p>

                            <h2 class="fw-bold mb-0">
                                <c:out value="${quantidadeFechadas}"/>
                            </h2>

                        </div>

                    </div>

                </div>

            </div>


            <!-- COMANDAS ABERTAS -->
                <c:if test="${filtro.status ne 'FECHADA'}">

            <section class="mb-5">

                <h4 class="fw-bold mb-3">
                    Em andamento
                </h4>

                <div class="row g-4">

                    <c:forEach
                            var="comanda"
                            items="${comandasAbertas}">

                        <div class="col-md-6 col-xl-4">

                            <div class="card card-barix
                                        comanda-card shadow-sm">

                                <div class="card-body p-4">

                                    <div class="d-flex justify-content-between
                                                align-items-start gap-2 mb-3">

                                        <div>
                                            <h5 class="fw-bold mb-1">
                                                <c:out value="${comanda.nomeCliente}"/>
                                            </h5>

                                            <small class="text-secondary">
                                                Comanda #<c:out value="${comanda.id}"/>
                                            </small>
                                        </div>

                                        <span class="badge bg-success">
                                            Aberta
                                        </span>

                                    </div>

                                    <p class="text-secondary mb-2">
                                        Abertura:
                                        <c:out value="${comanda.dataAbertura}"/>
                                    </p>

                                    <p class="fw-semibold mb-4">
                                        Total: R$
                                        <c:out value="${totaisPorComanda[comanda.id]}"/>
                                    </p>

                                    <button
                                            type="button"
                                            class="btn btn-outline-success"
                                            data-bs-toggle="modal"
                                            data-bs-target="#modalDetalhesComanda"
                                            data-comanda-id="${comanda.id}">

                                        Ver detalhes

                                    </button>

                                </div>

                            </div>

                        </div>

                    </c:forEach>


                    <c:if test="${empty comandasAbertas}">

                        <div class="col-12">

                            <div class="card card-barix shadow-sm">

                                <div class="card-body p-4 text-secondary">
                                    Nenhuma comanda aberta no momento.
                                </div>

                            </div>

                        </div>

                    </c:if>

                </div>

            </section>
                </c:if>

                <c:if test="${filtro.status ne 'ABERTA'}">
            <!-- HISTÓRICO DE COMANDAS -->

            <section>

                <div class="mb-3">

                    <h4 class="fw-bold mb-1">
                        Histórico de fechamentos
                    </h4>

                    <p class="text-secondary mb-0">
                        Consulte as comandas já encerradas.
                    </p>

                </div>

                <div class="card card-barix shadow-sm">

                    <div class="card-body p-4">

                        <div class="table-responsive">

                            <table class="table table-hover align-middle">

                                <thead>
                                <tr>
                                    <th>Comanda</th>
                                    <th>Cliente</th>
                                    <th>Fechamento</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Ações</th>
                                </tr>
                                </thead>

                                <tbody>

                                <c:forEach
                                        var="comanda"
                                        items="${comandasFechadas}">

                                    <tr>

                                        <td>
                                            #<c:out value="${comanda.id}"/>
                                        </td>

                                        <td>
                                            <c:out value="${comanda.nomeCliente}"/>
                                        </td>

                                        <td>
                                            <c:out value="${comanda.dataFechamento}"/>
                                        </td>

                                        <td>
                                            R$
                                            <c:out value="${totaisPorComanda[comanda.id]}"/>
                                        </td>

                                        <td>
                                                <span class="badge bg-secondary">
                                                    Fechada
                                                </span>
                                        </td>

                                        <td>

                                            <button
                                                    type="button"
                                                    class="btn btn-sm btn-outline-success"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#modalDetalhesComanda"
                                                    data-comanda-id="${comanda.id}">

                                                Ver detalhes

                                            </button>

                                        </td>

                                    </tr>

                                </c:forEach>


                                <c:if test="${empty comandasFechadas}">

                                    <tr>
                                        <td
                                                colspan="6"
                                                class="text-center text-secondary py-4">

                                            Nenhuma comanda fechada
                                            nesta página.

                                        </td>
                                    </tr>

                                </c:if>

                                </tbody>

                            </table>

                        </div>


                        <!-- PAGINAÇÃO -->


                        <!-- PAGINAÇÃO COM FILTROS -->

                        <c:if test="${quantidadeFechadas gt 0}">

                            <c:url var="urlAnterior" value="/comandas">

                                <c:param name="pagina" value="${paginaAnterior}"/>
                                <c:param name="cliente" value="${filtro.cliente}"/>
                                <c:param name="status" value="${filtro.status}"/>
                                <c:param name="dataInicial" value="${filtro.dataInicial}"/>
                                <c:param name="dataFinal" value="${filtro.dataFinal}"/>

                            </c:url>


                            <c:url var="urlProxima" value="/comandas">

                                <c:param name="pagina" value="${proximaPagina}"/>
                                <c:param name="cliente" value="${filtro.cliente}"/>
                                <c:param name="status" value="${filtro.status}"/>
                                <c:param name="dataInicial" value="${filtro.dataInicial}"/>
                                <c:param name="dataFinal" value="${filtro.dataFinal}"/>

                            </c:url>


                            <div class="d-flex flex-wrap
                justify-content-between
                align-items-center gap-3 mt-4">

        <span class="text-secondary">

            Página ${paginaAtual + 1} de ${totalPaginas}

        </span>


                                <div class="d-flex gap-2">

                                    <c:if test="${temAnterior}">

                                        <a
                                                class="btn btn-outline-secondary btn-sm"
                                                href="<c:out value='${urlAnterior}'/>">

                                            Anterior

                                        </a>

                                    </c:if>


                                    <c:if test="${temProxima}">

                                        <a
                                                class="btn btn-outline-success btn-sm"
                                                href="<c:out value='${urlProxima}'/>">

                                            Próxima

                                        </a>

                                    </c:if>

                                </div>

                            </div>

                        </c:if>


                    </div>

                </div>
                </c:if>

            </section>

            </c:if>

        </main>

    </div>
</div>


<!-- MODAL DE DETALHES -->

<div
        class="modal fade"
        id="modalDetalhesComanda"
        tabindex="-1"
        aria-hidden="true">

    <div class="modal-dialog modal-lg
                modal-dialog-centered
                modal-dialog-scrollable">

        <div
                class="modal-content"
                id="conteudoDetalhesComanda">

            <div class="modal-body p-4">
                Carregando detalhes...
            </div>

        </div>

    </div>

</div>


<!-- BOOTSTRAP -->

<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>


<!-- CONSULTA DE DETALHES -->

<script>
    document.addEventListener("DOMContentLoaded", function () {

        const modal = document.getElementById(
            "modalDetalhesComanda"
        );

        const conteudo = document.getElementById(
            "conteudoDetalhesComanda"
        );

        let requisicaoAtual = 0;

        modal.addEventListener(
            "show.bs.modal",
            async function (event) {

                const botao = event.relatedTarget;

                const id = botao?.getAttribute(
                    "data-comanda-id"
                );

                const sequencia = ++requisicaoAtual;

                conteudo.textContent = "Carregando detalhes...";

                if (!id || !/^\d+$/.test(id)) {
                    conteudo.textContent = "Comanda inválida.";
                    return;
                }

                try {

                    const url =
                        "${pageContext.request.contextPath}/comandas/"
                        + encodeURIComponent(id)
                        + "/detalhes?somenteLeitura=true";

                    const resposta = await fetch(url, {
                        headers: {
                            "Accept": "text/html"
                        }
                    });

                    if (!resposta.ok) {
                        throw new Error(
                            "Erro HTTP " + resposta.status
                        );
                    }

                    const html = await resposta.text();

                    if (sequencia === requisicaoAtual) {
                        conteudo.innerHTML = html;
                    }

                } catch (erro) {

                    console.error(erro);

                    if (sequencia === requisicaoAtual) {
                        conteudo.textContent =
                            "Não foi possível carregar a comanda.";
                    }
                }

            }
        );

        modal.addEventListener("hidden.bs.modal", function () {
            requisicaoAtual++;
        });

    });
</script>

</body>
</html>
