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
<style>
body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background: #fff8e1;
	color: #212121;
	margin: 0;
	padding: 0;
}

.container {
	max-width: 1000px;
	margin: 40px auto;
	padding: 0 20px;
}

h1 {
	text-align: center;
	font-size: 2.4rem;
	font-weight: 900;
	margin-bottom: 30px;
	color: #212121;
}

table {
	width: 100%;
	border-collapse: collapse;
	background: #fff;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 5px 20px rgba(247, 198, 0, 0.2);
}

th, td {
	padding: 12px 15px;
	text-align: left;
	border-bottom: 1px solid #ffd600;
}

th {
	background: #ffd600;
	color: #212121;
	font-weight: 700;
}

tr:nth-child(even) {
	background: #fff9d1;
}

tr:hover {
	background: #fff3a0;
}

.btn {
	padding: 6px 12px;
	font-size: 0.9rem;
	border-radius: 20px;
	border: 1.5px solid #212121;
	font-weight: 700;
	cursor: pointer;
	background: transparent;
	margin: 2px;
	transition: all 0.2s ease;
}

.btn:hover {
	background: #212121;
	color: #ffd600;
	border-color: #ffd600;
}

.top-actions {
	display: flex;
	justify-content: flex-end;
	margin-bottom: 15px;
	gap: 10px;
}
</style>
</head>
<body>

<jsp:include page="/pages/outros/mensagens.jsp" />

	<jsp:include page="/pages/usuario/header.jsp" />

	<div class="container">
		<h1>Gerenciar Unidades Geradoras</h1>



		<% if (unidades != null && !unidades.isEmpty()) { %>
		<table>
			<thead>
				<tr>
					<th>ID</th>
					<th>Localização</th>
					<th>Potência Instalada (kW)</th>
					<th>Preço por kWh (R$)</th>
					<th>Dono (CPF/CNPJ)</th>
					<th>Regra de Exceções</th>
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
					<td><%= u.getCpfCnpjUsuario() != null ? u.getCpfCnpjUsuario() : "-" %></td>
					<td><%= u.getRegraDeExcecoes() != null ? u.getRegraDeExcecoes() : "Não definida" %></td>
					<td>
						<form
							action="<%= request.getContextPath() %>/pages/unidadeGeradora/editarUnidade.jsp"
							method="get" style="display: inline;">
							<input type="hidden" name="id" value="<%= u.getId() %>" />
							<button type="submit" class="btn">Editar</button>
						</form>
						<form
							action="<%= request.getContextPath() %>/UnidadeGeradoraController"
							method="post" style="display: inline;">
							<input type="hidden" name="action" value="deletar" /> <input
								type="hidden" name="id" value="<%= u.getId() %>" />
							<button type="submit" class="btn"
								onclick="return confirm('Deseja realmente deletar esta unidade?');">Deletar</button>
						</form>
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
