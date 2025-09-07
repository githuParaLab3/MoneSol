<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*"%>
<%@ page import="br.com.monesol.dao.*"%>
<%@ page import="java.util.List"%>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null || !"ADMIN".equalsIgnoreCase(usuarioLogado.getTipo().name())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
    List<UnidadeGeradora> unidades = unidadeDAO.listarTodas(); 

%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Gerenciar Unidades - MoneSol</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/adminGerenciamento.css" />
</head>
<body>

<jsp:include page="/pages/outros/mensagens.jsp" />

	<jsp:include page="/pages/usuario/header.jsp" />

	<div class="container">
		<div class="top-actions">
        <h1>Gerenciar Unidades Geradoras</h1>
        <a href="<%= request.getContextPath() %>/pages/admin/criarUnidade.jsp" class="btn btn-create">+ Nova Unidade</a>
    </div>

		<% if (unidades != null && !unidades.isEmpty()) { %>
		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>Localização</th>
					<th>Potência (kW)</th>
					<th>Preço (R$/kWh)</th>
					<th>Qtd. Máx. (kWh)</th>
					<th>Dono (CPF/CNPJ)</th>
					<th>Ações</th>
				</tr>
			</thead>
			<tbody>
				<% for (UnidadeGeradora u : unidades) { %>
				<tr>
					<td><%= u.getId() %></td>
                    <td><%= u.getLocalizacao() %></td>
					<td><%= String.format("%.2f", u.getPotenciaInstalada()) %></td>
					<td><%= String.format("%.4f", u.getPrecoPorKWh()) %></td>
					<td><%= String.format("%.2f", u.getQuantidadeMaximaComerciavel()) %></td>
					<td><%= u.getCpfCnpjUsuario() != null ? u.getCpfCnpjUsuario() : "-" %></td>
					<td>
                        <div class="actions">
                             <!-- Botão Detalhes -->
                             <form action="<%= request.getContextPath() %>/UnidadeGeradoraController" method="get" style="display: inline;">
                                 <input type="hidden" name="action" value="buscarPorId" />
                                 <input type="hidden" name="id" value="<%= u.getId() %>" />
                                 <button type="submit" class="btn">Detalhes</button>
                             </form>

                             <!-- Botão Editar -->
                             <form action="<%= request.getContextPath() %>/pages/unidadeGeradora/editarUnidade.jsp" method="get" style="display: inline;">
                                  <input type="hidden" name="id" value="<%= u.getId() %>" />
                                  <button type="submit" class="btn">Editar</button>
                             </form>

                            <!-- Botão Deletar -->
                            <form action="<%= request.getContextPath() %>/UnidadeGeradoraController" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="deletar" /> <input
                                    type="hidden" name="id" value="<%= u.getId() %>" />
                                <button type="submit" class="btn"
                                    onclick="return confirm('Deseja realmente deletar esta unidade?');">Deletar</button>
                            </form>
                        </div>
					</td>
				</tr>
				<% } %>
			</tbody>

		</table>
		<% } else { %>
		<p>Nenhuma unidade geradora cadastrada.</p>
		<% } %>
	</div>

</body>
</html>