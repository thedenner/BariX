<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="pt_BR"/>

<!DOCTYPE html>
<html lang="pt-BR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>BariX - Financeiro</title>

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
            background-color: rgba(255, 255, 255, 0.08);
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

        @media (max-width: 767.98px) {
            .sidebar {
                min-height: auto;
            }

            .dashboard-main {
                padding: 1.5rem !important;
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
                <h2 class="fw-bold mb-0">BARIX</h2>
                <div class="brand-subtitle">GESTÃO DO BAR</div>
            </div>

            <nav class="nav flex-column gap-2">
                <a class="nav-link rounded px-3 py-2"
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

                <a class="nav-link active rounded px-3 py-2"
                   href="${pageContext.request.contextPath}/financeiro">
                    Financeiro
                </a>
            </nav>

            <form class="mt-5" method="post"
                  action="${pageContext.request.contextPath}/logout">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                <button type="submit" class="btn btn-outline-light w-100">Sair</button>
            </form>

        </aside>

        <!-- =====================================
             CONTEÚDO PRINCIPAL — FINANCEIRO
        ====================================== -->
        <main class="col-md-10 dashboard-main p-5">

            <!-- CABEÇALHO -->
            <div class="mb-4">
                <h2 class="fw-bold" style="color: var(--barix-verde);">
                    Financeiro
                </h2>
                <p class="text-secondary mb-0">
                    Valor de consumo das comandas fechadas. Não representa pagamentos recebidos.
                </p>
            </div>

            <!-- BARRA DE FILTROS -->
            <form action="${pageContext.request.contextPath}/financeiro"
                  method="get"
                  class="card card-dashboard shadow-sm mb-4">

                <div class="card-body p-4">
                    <div class="row g-3 align-items-end">

                        <!-- FILTRO PERÍODO -->
                        <div class="col-md-3">
                            <label for="filtroPeriodo" class="form-label fw-bold small">
                                Período
                            </label>
                            <select id="filtroPeriodo" name="periodo" class="form-select">
                                <option value="DIA" ${periodoSelecionado == 'DIA' ? 'selected' : ''}>
                                    Hoje (Dia)
                                </option>
                                <option value="SEMANA" ${periodoSelecionado == 'SEMANA' ? 'selected' : ''}>
                                    Últimos 7 dias (Semana)
                                </option>
                                <option value="MES" ${periodoSelecionado == 'MES' ? 'selected' : ''}>
                                    Este Mês
                                </option>
                            </select>
                        </div>

                        <!-- FILTRO CATEGORIA -->
                        <div class="col-md-4">
                            <label for="filtroCategoria" class="form-label fw-bold small">
                                Categoria
                            </label>
                            <select id="filtroCategoria" name="categoriaId" class="form-select">
                                <option value="">Todas as categorias</option>
                                <c:forEach var="cat" items="${categorias}">
                                    <option value="${cat.id}" ${categoriaSelecionada == cat.id ? 'selected' : ''}>
                                        <c:out value="${cat.nome}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- FILTRO ITEM -->
                        <div class="col-md-3">
                            <label for="filtroItem" class="form-label fw-bold small">
                                Item Específico
                            </label>
                            <select id="filtroItem" name="itemId" class="form-select">
                                <option value="">Todos os itens</option>
                                <c:forEach var="it" items="${itens}">
                                    <option value="${it.id}" ${itemSelecionado == it.id ? 'selected' : ''}>
                                        <c:out value="${it.nome}"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- BOTÕES -->
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit"
                                    class="btn fw-bold w-100"
                                    style="background-color: #f4b23e; color: #000000;">
                                Filtrar
                            </button>
                            <a href="${pageContext.request.contextPath}/financeiro"
                               class="btn btn-outline-secondary">
                                Limpar
                            </a>
                        </div>

                    </div>
                </div>
            </form>

            <!-- CARD SIMPLES DE RECEITA TOTAL -->
            <div class="card card-dashboard shadow-sm mb-4 text-white"
                 style="background-color: var(--barix-verde);">
                <div class="card-body p-4 d-flex flex-wrap justify-content-between align-items-center">
                    <div>
                                <span class="text-uppercase small fw-bold" style="color: #f4b23e; letter-spacing: 0.08rem;">
                                    Faturamento de comandas (${periodoSelecionado == 'DIA' ? 'Hoje' : (periodoSelecionado == 'SEMANA' ? 'Últimos 7 dias' : 'Este Mês')})
                                </span>
                        <h1 class="display-5 fw-bold mb-0 mt-1">
                            <fmt:formatNumber value="${resumo.receitaTotal}" type="currency" currencySymbol="R$ "/>
                        </h1>
                    </div>
                    <div class="text-md-end mt-3 mt-md-0">
                                <span class="badge fs-6 px-3 py-2" style="background-color: rgba(0, 0, 0, 0.35); color: #f4b23e;">
                                    <c:out value="${resumo.totalComandas}"/> comanda(s) fechada(s)
                                </span>
                    </div>
                </div>
            </div>

            <!-- GRÁFICO DE PESOS + RANKING TOP 10 -->
            <div class="row g-4">

                <!-- COLUNA ESQUERDA: GRÁFICO E BARRAS DE PESO -->
                <div class="col-lg-6">
                    <div class="card card-dashboard shadow-sm h-100">
                        <div class="card-body p-4">
                            <h5 class="fw-bold mb-4">
                                <c:out value="${resumo.tituloGrafico}"/>
                            </h5>

                            <c:choose>
                                <c:when test="${empty resumo.itensPeso}">
                                    <div class="text-center text-secondary py-5">
                                        Nenhuma comanda fechada encontrada para este filtro.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex justify-content-center mb-4">
                                        <div id="graficoRoscaOffline"
                                             style="width: 210px; height: 210px; border-radius: 50%; display: flex; align-items: center; justify-content: center; background: #e9ecef;">
                                            <div style="width: 115px; height: 115px; border-radius: 50%; background: #ffffff; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                                                <small class="text-secondary" style="font-size: 0.75rem;">Comandas</small>
                                                <strong class="fs-5" style="color: #163c2e;">
                                                    <c:out value="${resumo.totalComandas}"/>
                                                </strong>
                                            </div>
                                        </div>
                                    </div>

                                    <c:forEach var="peso" items="${resumo.itensPeso}" varStatus="st">
                                        <div class="mb-3 fatia-receita" data-valor="<c:out value='${peso.valorTotal}'/>">
                                            <div class="d-flex justify-content-between small fw-bold mb-1">
                                                        <span>
                                                            <span class="legenda-cor d-inline-block rounded-circle me-1"
                                                                  data-index="${st.index}"
                                                                  style="width: 10px; height: 10px; background-color: #163c2e;"></span>
                                                            <c:out value="${peso.nome}"/>
                                                        </span>
                                                <span>
                                                            <fmt:formatNumber value="${peso.valorTotal}" type="currency" currencySymbol="R$ "/>
                                                            (<c:out value="${peso.percentual}"/>%)
                                                        </span>
                                            </div>
                                            <div class="progress" style="height: 8px; border-radius: 6px;">
                                                <div class="progress-bar barra-peso"
                                                     data-index="${st.index}"
                                                     role="progressbar"
                                                     style="width: ${peso.percentual}%; background-color: var(--barix-verde);">
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- COLUNA DIREITA: TOP 10 ITENS POR RECEITA -->
                <div class="col-lg-6">
                    <div class="card card-dashboard shadow-sm h-100">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-bold mb-0">
                                    Top 10 Itens por Receita
                                </h5>
                                <span class="badge bg-dark">Ranking</span>
                            </div>

                            <c:choose>
                                <c:when test="${empty resumo.top10Itens}">
                                    <div class="text-center text-secondary py-5">
                                        Nenhum item vendido no período selecionado.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="table-light">
                                            <tr>
                                                <th style="width: 50px;">#</th>
                                                <th>Item</th>
                                                <th class="text-center">Qtd.</th>
                                                <th class="text-end">Receita</th>
                                                <th class="text-end">Peso</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="rank" items="${resumo.top10Itens}" varStatus="status">
                                                <tr>
                                                    <td>
                                                                    <span class="badge rounded-pill ${status.index == 0 ? 'text-dark' : 'bg-secondary'}"
                                                                          style="${status.index == 0 ? 'background-color: #f4b23e;' : ''}">
                                                                        ${status.index + 1}º
                                                                    </span>
                                                    </td>
                                                    <td>
                                                        <div class="fw-bold"><c:out value="${rank.nome}"/></div>
                                                        <small class="text-secondary"><c:out value="${rank.categoria}"/></small>
                                                    </td>
                                                    <td class="text-center">
                                                        <c:out value="${rank.quantidadeVendida}"/>
                                                    </td>
                                                    <td class="text-end fw-bold">
                                                        <fmt:formatNumber value="${rank.valorTotal}" type="currency" currencySymbol="R$ "/>
                                                    </td>
                                                    <td class="text-end text-secondary small">
                                                        <c:out value="${rank.percentual}"/>%
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>

        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/bootstrap/js/bootstrap.bundle.min.js"></script>
<script>
    const cores = [
        '#163c2e', '#f4b23e', '#1e1e1e', '#2e7d32',
        '#d9822b', '#4f772d', '#6c757d', '#90a955'
    ];

    // Aplica as mesmas cores nas bolinhas da legenda e nas barras de progresso
    document.querySelectorAll('.legenda-cor, .barra-peso').forEach(function (el) {
        const idx = Number(el.getAttribute('data-index'));
        el.style.backgroundColor = cores[idx % cores.length];
    });

    // Desenha o gráfico de rosca localmente
    const graficoDiv = document.getElementById('graficoRoscaOffline');
    if (graficoDiv) {
        const valores = Array.from(
            document.querySelectorAll('.fatia-receita'),
            el => Number(el.dataset.valor)
        );
        const somaTotal = valores.reduce(function (acc, val) {
            return acc + val;
        }, 0);

        if (somaTotal > 0) {
            let acumulado = 0;
            const fatias = valores.map(function (valor, index) {
                const inicio = (acumulado / somaTotal) * 360;
                acumulado += valor;
                const fim = (acumulado / somaTotal) * 360;
                const cor = cores[index % cores.length];
                return cor + ' ' + inicio.toFixed(6) + 'deg ' + fim.toFixed(6) + 'deg';
            });

            graficoDiv.style.background = 'conic-gradient(' + fatias.join(', ') + ')';
        }
    }
</script>

</body>
</html>