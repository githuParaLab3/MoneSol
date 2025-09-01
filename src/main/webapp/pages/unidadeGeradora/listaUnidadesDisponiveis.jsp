<%-- MUDANÇA: Adicionado imports para Usuario, Contrato e DAOs necessários --%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Collections"%>
<%@ page import="java.util.stream.Collectors"%>
<%@ page import="br.com.monesol.dao.UnidadeGeradoraDAO"%>
<%@ page import="br.com.monesol.model.UnidadeGeradora"%>
<%@ page import="br.com.monesol.model.Usuario"%>
<%@ page import="br.com.monesol.dao.ContratoDAO"%>
<%@ page import="br.com.monesol.model.Contrato"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>MoneSol - Marketplace de Unidades Geradoras</title>
<link rel="stylesheet" href="../../assets/css/monesol.css" />
<style>
.container {
	max-width: 1100px;
	margin: 40px auto;
	padding: 0 20px;
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	color: #333;
}

h1 {
	text-align: center;
	color: #212121;
	font-weight: 900;
	font-size: 2.4rem;
	margin-bottom: 30px;
}

/* --- PAINEL DE FILTROS --- */
.filter-panel {
    background-color: #fff;
    border: 2px solid #ffd600;
    border-radius: 12px;
    padding: 20px 25px;
    margin-bottom: 40px;
    box-shadow: 0 6px 15px rgba(255, 214, 0, 0.2);
}

.filter-panel summary {
    font-size: 1.2rem;
    font-weight: 700;
    color: #212121;
    cursor: pointer;
    list-style: none; /* Remove a seta padrão */
}

.filter-panel summary::-webkit-details-marker {
    display: none; /* Remove a seta no Chrome/Safari */
}

.filter-panel summary::before {
    content: '▶'; /* Seta customizada */
    margin-right: 10px;
    display: inline-block;
    transition: transform 0.2s;
}

.filter-panel[open] > summary::before {
    transform: rotate(90deg);
}

.search-form {
    margin-top: 20px;
}

.search-input {
    width: 100%;
    padding: 12px 20px;
    border: 2px solid #ffd600;
    border-radius: 30px;
    font-size: 1rem;
    outline: none;
    box-sizing: border-box;
    transition: all 0.3s ease;
    margin-bottom: 20px;
}
.search-input:focus {
    border-color: #ffb300;
    box-shadow: 0 0 10px rgba(255, 214, 0, 0.5);
}

.advanced-filters {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 20px;
}

.filter-group label {
    display: block;
    font-weight: 600;
    margin-bottom: 8px;
    color: #555;
}
.filter-group input[type="number"] {
    width: 100%;
    padding: 10px 14px;
    border-radius: 8px;
    border: 1px solid #ccc;
    font-size: 1rem;
    box-sizing: border-box;
}

.filter-actions {
    display: flex;
    gap: 15px;
    justify-content: flex-start;
    align-items: center;
}

.search-button {
    padding: 12px 28px;
    border: none;
    border-radius: 30px;
    background-color: #212121;
    color: #ffd600;
    font-weight: bold;
    cursor: pointer;
    transition: all 0.3s ease;
}
.search-button:hover {
    background-color: #000;
}

.clear-button {
    padding: 10px 24px;
    border: 2px solid #ccc;
    border-radius: 30px;
    background-color: transparent;
    color: #555;
    font-weight: bold;
    cursor: pointer;
    text-decoration: none;
    transition: all 0.3s ease;
}
.clear-button:hover {
    background-color: #f0f0f0;
    border-color: #aaa;
}


/* --- ESTILOS DOS CARDS (sem alteração) --- */
.units-list { list-style: none; padding: 0; margin: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
.unit-card { background: #fff; border: 2px solid #ffd600; border-radius: 12px; padding: 20px 25px; box-shadow: 0 6px 15px rgba(255, 214, 0, 0.2); transition: transform 0.2s ease, box-shadow 0.2s ease; display: flex; flex-direction: column; justify-content: flex-start; color: #212121; }
.unit-card:hover { transform: translateY(-5px); box-shadow: 0 10px 30px rgba(255, 214, 0, 0.4); border-color: #ffeb3b; }
.unit-title { font-weight: 700; font-size: 1.25rem; margin-bottom: 12px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
.unit-info { font-size: 0.95rem; margin-bottom: 8px; color: #555; }
.unit-info strong { color: #212121; }
.btn-contratar { margin-top: auto; background-color: #212121; color: #ffd600; border: none; padding: 10px 16px; border-radius: 30px; font-weight: 700; cursor: pointer; align-self: flex-start; transition: background-color 0.3s ease; text-align: center; text-decoration: none; display: inline-block; }
.btn-contratar:hover { background-color: #000; color: #fff700; }
.link-detalhes { color: inherit; text-decoration: none; cursor: pointer; }
.link-detalhes:hover { text-decoration: underline; }

</style>
</head>
<body>
    <% request.setCharacterEncoding("UTF-8"); %>

	<jsp:include page="/pages/outros/mensagens.jsp" />
	<jsp:include page="/pages/usuario/header.jsp" />

	<div class="container">
		<h1>Marketplace - Unidades Geradoras Disponíveis</h1>

        <details class="filter-panel" open>
            <summary>Filtros de Pesquisa</summary>
            <form method="get" class="search-form">
                <input type="text" name="q" class="search-input"
                    placeholder="Pesquisar por localização, regras..."
                    value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>" />
                
                <div class="advanced-filters">
                    <div class="filter-group">
                        <label for="potenciaMin">Potência Mínima (kW)</label>
                        <input type="number" id="potenciaMin" name="potenciaMin" min="0" step="0.1"
                               value="<%= request.getParameter("potenciaMin") != null ? request.getParameter("potenciaMin") : "" %>" />
                    </div>
                    <div class="filter-group">
                        <label for="precoMax">Preço Máximo (R$/kWh)</label>
                        <input type="number" id="precoMax" name="precoMax" min="0" step="0.01"
                               value="<%= request.getParameter("precoMax") != null ? request.getParameter("precoMax") : "" %>" />
                    </div>
                    <div class="filter-group">
                        <label for="eficienciaMin">Eficiência Mínima (%)</label>
                        <input type="number" id="eficienciaMin" name="eficienciaMin" min="0" max="100" step="0.1"
                               value="<%= request.getParameter("eficienciaMin") != null ? request.getParameter("eficienciaMin") : "" %>" />
                    </div>
                     <div class="filter-group">
                        <label for="quantidadeMin">Quantidade Mínima (kWh)</label>
                        <input type="number" id="quantidadeMin" name="quantidadeMin" min="0" step="1"
                               value="<%= request.getParameter("quantidadeMin") != null ? request.getParameter("quantidadeMin") : "" %>" />
                    </div>
                </div>

                <div class="filter-actions">
                    <button type="submit" class="search-button">Filtrar</button>
                    <a href="listaUnidadesDisponiveis.jsp" class="clear-button">Limpar Filtros</a>
                </div>
            </form>
        </details>

		<%
            UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
            List<UnidadeGeradora> listaUnidades = null;

            try {
                // Pega o usuário logado da sessão
                HttpSession sessao = request.getSession(false);
                Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;

                // Se houver um usuário logado, busca os IDs das unidades que ele já contratou
                Set<Integer> idsUnidadesContratadas = Collections.emptySet();
                if (usuarioLogado != null) {
                    ContratoDAO contratoDAO = new ContratoDAO();
                    List<Contrato> contratosDoUsuario = contratoDAO.listarPorUsuario(usuarioLogado.getCpfCnpj());
                    idsUnidadesContratadas = contratosDoUsuario.stream()
                                               .map(contrato -> contrato.getUnidadeGeradora().getId())
                                               .collect(Collectors.toSet());
                }

                // 1. Pega todas as unidades do banco
                listaUnidades = unidadeDAO.listarTodas();

                // 2. Aplica o filtro para remover unidades já contratadas (se aplicável)
                if (!idsUnidadesContratadas.isEmpty()) {
                    final Set<Integer> finalIds = idsUnidadesContratadas;
                    listaUnidades.removeIf(unidade -> finalIds.contains(unidade.getId()));
                }

                // 3. Aplica os outros filtros de pesquisa
                
                String q = request.getParameter("q");
                if (q != null && !q.trim().isEmpty()) {
                    String termo = q.toLowerCase();
                    listaUnidades.removeIf(unidade ->
                        !((unidade.getLocalizacao() != null && unidade.getLocalizacao().toLowerCase().contains(termo)) ||
                          (unidade.getRegraDeExcecoes() != null && unidade.getRegraDeExcecoes().toLowerCase().contains(termo)))
                    );
                }

                String potenciaMinStr = request.getParameter("potenciaMin");
                if (potenciaMinStr != null && !potenciaMinStr.trim().isEmpty()) {
                    try {
                        double potenciaMin = Double.parseDouble(potenciaMinStr);
                        listaUnidades.removeIf(unidade -> unidade.getPotenciaInstalada() < potenciaMin);
                    } catch (NumberFormatException e) { /* Ignora valor inválido */ }
                }

                String precoMaxStr = request.getParameter("precoMax");
                if (precoMaxStr != null && !precoMaxStr.trim().isEmpty()) {
                    try {
                        double precoMax = Double.parseDouble(precoMaxStr);
                        listaUnidades.removeIf(unidade -> unidade.getPrecoPorKWh() > precoMax);
                    } catch (NumberFormatException e) { /* Ignora valor inválido */ }
                }

                String eficienciaMinStr = request.getParameter("eficienciaMin");
                if (eficienciaMinStr != null && !eficienciaMinStr.trim().isEmpty()) {
                    try {
                        double eficienciaMin = Double.parseDouble(eficienciaMinStr);
                        // A eficiência é armazenada como decimal (ex: 0.9), então dividimos por 100
                        listaUnidades.removeIf(unidade -> (unidade.getEficienciaMedia() * 100) < eficienciaMin);
                    } catch (NumberFormatException e) { /* Ignora valor inválido */ }
                }

                String quantidadeMinStr = request.getParameter("quantidadeMin");
                if (quantidadeMinStr != null && !quantidadeMinStr.trim().isEmpty()) {
                    try {
                        double quantidadeMin = Double.parseDouble(quantidadeMinStr);
                        listaUnidades.removeIf(unidade -> unidade.getQuantidadeMaximaComerciavel() < quantidadeMin);
                    } catch (NumberFormatException e) { /* Ignora valor inválido */ }
                }


            } catch (Exception e) {
                out.println("<p style='color:red; text-align:center;'>Erro ao carregar unidades geradoras: " + e.getMessage() + "</p>");
            }
        %>

		<% if (listaUnidades != null && !listaUnidades.isEmpty()) { %>
		<ul class="units-list" role="list">
			<% for (UnidadeGeradora unidade : listaUnidades) { %>
			<li>
				<div class="unit-card" role="listitem"
					aria-label="Unidade geradora localizada em <%= unidade.getLocalizacao() %>">
					<a
						href="<%= request.getContextPath() %>/UnidadeGeradoraController?action=detalhesPublicos&id=<%= unidade.getId() %>"
						class="link-detalhes">
						<div class="unit-title"><%= unidade.getLocalizacao() %></div>
						<div class="unit-info">
							<strong>Potência Instalada:</strong>
							<%= String.format("%.2f", unidade.getPotenciaInstalada()) %>
							kW
						</div>
						<div class="unit-info">
							<strong>Eficiência Média:</strong>
							<%= String.format("%.1f", unidade.getEficienciaMedia() * 100) %> %
						</div>
						<div class="unit-info">
							<strong>Preço por kWh:</strong> R$
							<%= String.format("%.2f", unidade.getPrecoPorKWh()) %>
						</div>
						<div class="unit-info">
							<strong>Quantidade mínima aceita:</strong>
							<%= (unidade.getQuantidadeMinimaAceita() > 0) ? String.format("%.2f", unidade.getQuantidadeMinimaAceita()) + " kWh" : "Não definido" %>
						</div>
                        <div class="unit-info">
                            <strong>Quantidade Máxima Comerciável:</strong>
                            <%= (unidade.getQuantidadeMaximaComerciavel() > 0) ? String.format("%.2f", unidade.getQuantidadeMaximaComerciavel()) + " kWh" : "Não definido" %>
                        </div>
						<div class="unit-info">
							<strong>Regra de Exceções:</strong>
							<%= (unidade.getRegraDeExcecoes() != null && !unidade.getRegraDeExcecoes().isEmpty())
        ? unidade.getRegraDeExcecoes()
        : "Não definida" %>
						</div>
					</a>
					<form
						action="<%= request.getContextPath() %>/pages/contrato/cadastrarContrato.jsp"
						method="get" style="margin-top: 12px;">
						<input type="hidden" name="unidadeGeradoraId"
							value="<%= unidade.getId() %>" />
						<button type="submit" class="btn-contratar">Contratar</button>
					</form>
				</div>
			</li>
			<% } %>
		</ul>
		<% } else { %>
		<p style="text-align: center; color: #777; margin-top: 40px; font-size: 1.1rem;">Nenhuma unidade encontrada com os filtros aplicados.</p>
		<% } %>
	</div>
</body>
</html>