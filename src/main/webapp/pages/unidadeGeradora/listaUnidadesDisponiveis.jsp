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
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.sql.SQLException"%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>MoneSol - Marketplace de Unidades Geradoras</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/marketplace.css" />

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
                               value="<%= request.getParameter("eficienciaMin") != null ?
 request.getParameter("eficienciaMin") : "" %>" />
                    </div>
                     <div class="filter-group">
                        <label for="quantidadeMin">Quantidade Mínima (kWh)</label>
                        <input type="number" id="quantidadeMin" 
 name="quantidadeMin" min="0" step="1"
                               value="<%= request.getParameter("quantidadeMin") != null ?
 request.getParameter("quantidadeMin") : "" %>" />
                    </div>
                </div>

                <div class="filter-actions">
                    <button type="submit" class="search-button">Filtrar</button>
                    <a 
 href="listaUnidadesDisponiveis.jsp" class="clear-button">Limpar Filtros</a>
                </div>
            </form>
        </details>

		<%
            UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
            ContratoDAO contratoDAO = new ContratoDAO();
            List<UnidadeGeradora> listaUnidades = null;

            try {
                // Pega o usuário logado da sessão
                HttpSession sessao = request.getSession(false);
                Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;

                // Se houver um usuário logado, busca os IDs das unidades que ele já contratou
                Set<Integer> idsUnidadesContratadas = Collections.emptySet();
  
                if (usuarioLogado != null) {
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
                
                // 2.1. FILTRO ADICIONAL: Remove unidades com capacidade esgotada
                listaUnidades.removeIf(unidade -> {
                    try {
                        double capacidadePreenchida = contratoDAO.calcularCapacidadeContratada(unidade.getId());
                        return capacidadePreenchida >= unidade.getQuantidadeMaximaComerciavel();
                    } catch (SQLException e) {
                        // Se houver um erro, remove a unidade para não correr riscos
                        return true;
                    }
                });

                // 3. Aplica os outros filtros de pesquisa
                
                String q = request.getParameter("q");
 if (q != null && !q.trim().isEmpty()) {
                    String termo = q.toLowerCase();
 listaUnidades.removeIf(unidade -> {
        try {
            double capacidadePreenchida = contratoDAO.calcularCapacidadeContratada(unidade.getId());
            double capacidadeDisponivel = unidade.getQuantidadeMaximaComerciavel() - capacidadePreenchida;
            return !(
                (unidade.getLocalizacao() != null && unidade.getLocalizacao().toLowerCase().contains(termo)) ||
                (unidade.getRegraDeExcecoes() != null && unidade.getRegraDeExcecoes().toLowerCase().contains(termo)) ||
                String.format("%.2f", unidade.getPotenciaInstalada()).contains(termo) ||
                String.format("%.1f", unidade.getEficienciaMedia() * 100).contains(termo) ||
                String.format("%.2f", unidade.getPrecoPorKWh()).contains(termo) ||
                String.format("%.2f", unidade.getQuantidadeMinimaAceita()).contains(termo) ||
                String.format("%.2f", unidade.getQuantidadeMaximaComerciavel()).contains(termo) ||
                String.format("%.2f", capacidadeDisponivel).contains(termo)
            );
        } catch (SQLException e) {
            return true; // Em caso de erro, remove a unidade da lista para segurança
        }
    });
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
							<%= String.format("%.1f", unidade.getEficienciaMedia()) %> %
						</div>
						<div class="unit-info">
							<strong>Preço por kWh:</strong> R$
							<%= String.format("%.2f", unidade.getPrecoPorKWh()) %>
						</div>
						<div class="unit-info">
							<strong>Quantidade mínima aceita:</strong>
							<%= (unidade.getQuantidadeMinimaAceita() > 0) ?
 String.format("%.2f", unidade.getQuantidadeMinimaAceita()) + " kWh" : "Não definido" %>
						</div>
                        <div class="unit-info">
                            <strong>Quantidade Máxima Comerciável:</strong>
                            <%= (unidade.getQuantidadeMaximaComerciavel() > 0) ?
 String.format("%.2f", unidade.getQuantidadeMaximaComerciavel()) + " kWh" : "Não definido" %>
                        </div>
                        <%
                            double capacidadePreenchida = 0.0;
                            try {
                                capacidadePreenchida = contratoDAO.calcularCapacidadeContratada(unidade.getId());
                            } catch (Exception e) {
                                // Ignorar erro, capacidadePreenchida permanece 0.0
                            }
                            double capacidadeDisponivel = unidade.getQuantidadeMaximaComerciavel() - capacidadePreenchida;
                            double porcentagem = (unidade.getQuantidadeMaximaComerciavel() > 0) ? (capacidadePreenchida / unidade.getQuantidadeMaximaComerciavel()) * 100 : 0;
                            String porcentagemFormatada = String.format("%.2f", porcentagem).replace(",", ".");
                        %>
                        <div class="progress-container">
                            <div class="progress-label"><strong>Capacidade de Contrato</strong></div>
                            <div class="progress-bar-wrapper">
                                <div class="progress-bar-fill" style="width: <%= porcentagemFormatada %>%;"></div>
                                <span class="progress-bar-text">
                                    <%= String.format("%.2f", capacidadePreenchida) %>/<%= String.format("%.2f", unidade.getQuantidadeMaximaComerciavel()) %> kWh
                                </span>
                            </div>
                            <small style="color: #555; font-size: 0.9rem; margin-top: 5px; display: block;">
                                Disponível: <%= String.format("%.2f", capacidadeDisponivel) %> kWh
                            </small>
                        </div>
						<div class="unit-info">
							<strong>Regra de Exceções:</strong>
							<%= (unidade.getRegraDeExcecoes() != null && !unidade.getRegraDeExcecoes().isEmpty())
        ?
 unidade.getRegraDeExcecoes()
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