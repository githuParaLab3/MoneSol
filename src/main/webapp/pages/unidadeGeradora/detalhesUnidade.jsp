<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*"%>
<%@ page import="br.com.monesol.dao.MedicaoDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%
HttpSession sessaoDetalhesUnidade = request.getSession(false);
Usuario usuarioDetalhesUnidade = (sessaoDetalhesUnidade != null)
		? (Usuario) sessaoDetalhesUnidade.getAttribute("usuarioLogado")
		: null;
if (usuarioDetalhesUnidade == null) {
	response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
	return;
}

UnidadeGeradora unidade = (UnidadeGeradora) request.getAttribute("unidade");
if (unidade == null) {
	out.println("<p>Unidade não encontrada.</p>");
	return;
}

boolean podeEditar = "ADMIN".equalsIgnoreCase(usuarioDetalhesUnidade.getTipo().name())
		|| (unidade.getCpfCnpjUsuario() != null
		&& unidade.getCpfCnpjUsuario().equals(usuarioDetalhesUnidade.getCpfCnpj()));

MedicaoDAO medicaoDAO = new MedicaoDAO();
List<Medicao> medições = null;
try {
	medições = medicaoDAO.listarPorUnidade(unidade.getId());
} catch (Exception e) {
	e.printStackTrace();
}

DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Detalhes da Unidade Geradora - MoneSol</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	background: #fff8e1;
	color: #2e2e2e;
	min-height: 100vh;
}

main {
	max-width: 1000px;
	margin: 30px auto;
	padding: 0 20px 60px;
}

h1 {
	font-size: 2.4rem;
	font-weight: 900;
	color: #212121;
	margin-bottom: 15px;
	text-align: center;
}

.sub {
	font-size: 0.95rem;
	color: #555;
	margin-bottom: 30px;
	text-align: center;
}

.card {
	background: #ffffff;
	border-radius: 12px;
	border: 1.5px solid #f7c600;
	padding: 25px 30px;
	margin-bottom: 30px;
	box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25);
}

.flex {
	display: flex;
	gap: 30px;
	flex-wrap: wrap;
}

.info {
	flex: 1 1 280px;
}

.info-label {
	font-weight: 700;
	margin-bottom: 5px;
	display: block;
	color: #555;
}

.info-value {
	background: #f9f6d8;
	padding: 12px 14px;
	border-radius: 8px;
	margin-bottom: 12px;
	font-size: 1rem;
}

.actions {
	margin-top: 10px;
	display: flex;
	gap: 12px;
	flex-wrap: wrap;
}

.btn {
	padding: 10px 22px;
	border: none;
	border-radius: 30px;
	font-weight: 700;
	cursor: pointer;
	user-select: none;
	font-size: 0.95rem;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	transition: background 0.25s ease;
	text-decoration: none;
	text-align: center;
	
}

.btn-edit {
	background: #212121;
	color: #ffd600;
}

.btn-edit:hover {
	background: #000;
}

.btn-delete {
	background: #d32f2f;
	color: #fff;
}

.btn-delete:hover {
	background: #b71c1c;
}

.btn-back {
	background: transparent;
	color: #212121;
	border: 2px solid #212121;
	border-radius: 30px;
}

.btn-back:hover {
	background: #212121;
	color: #ffd600;
}

.table-wrapper {
	overflow-x: auto;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 15px;
	font-size: 0.95rem;
}

thead {
	background: #f7c600;
}

th, td {
	padding: 12px 14px;
	text-align: left;
	border-bottom: 1px solid #f0e38f;
}

th {
	font-weight: 700;
	color: #212121;
}

tbody tr:hover {
	background: #fff8c4;
}

.summary {
	display: flex;
	gap: 20px;
	flex-wrap: wrap;
	margin-top: 10px;
}

.summary-item {
	flex: 1 1 180px;
	background: #fffde7;
	border: 1px solid #f7c600;
	border-radius: 10px;
	padding: 12px 16px;
	font-weight: 600;
}
</style>
</head>
<body>
	<jsp:include page="/pages/outros/mensagens.jsp" />
	<jsp:include page="/pages/usuario/header.jsp" />

	<main aria-label="Detalhes da unidade geradora">
		
		<% if (usuarioDetalhesUnidade != null && "ADMIN".equalsIgnoreCase(usuarioDetalhesUnidade.getTipo().name())) { %>
	        <a href="<%= request.getContextPath() %>/pages/admin/gerenciarUnidades.jsp" class="btn btn-back" style="margin-bottom: 20px;">&larr; Voltar</a>
	    <% } else { %>
	        <a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp" class="btn btn-back" style="margin-bottom: 20px;">&larr; Voltar</a>
	    <% } %>

		<h1>
			Unidade Geradora #<%=unidade.getId()%></h1>
		<div class="sub">Detalhes da unidade e medições recentes</div>

		<div class="card">
			<div class="flex">
				<div class="info">
					<div class="info-label">Localização</div>
					<div class="info-value"><%=unidade.getLocalizacao()%></div>
					<div class="info-label">Potência Instalada (kW)</div>
					<div class="info-value"><%=String.format("%.2f", unidade.getPotenciaInstalada())%></div>
					<div class="info-label">Eficiência Média (%)</div>
					<div class="info-value"><%=String.format("%.1f", unidade.getEficienciaMedia() * 100)%></div>
					<div class="info-label">Preço por kWh (R$)</div>
					<div class="info-value"><%=String.format("%.2f", unidade.getPrecoPorKWh())%></div>
					<div class="info-label">Quantidade Mínima Aceita (kWh)</div>
					<div class="info-value"><%=(unidade.getQuantidadeMinimaAceita() > 0) ? String.format("%.2f", unidade.getQuantidadeMinimaAceita())
		: "Não definido"%></div>
					<div class="info-label">Regra de Exceções</div>
					<div class="info-value">
						<%=(unidade.getRegraDeExcecoes() != null && !unidade.getRegraDeExcecoes().isBlank()) ? unidade.getRegraDeExcecoes()
				: "Não definida"%>
					</div>

				</div>
				<div class="info">
					<div class="info-label">Dono da Unidade</div>
					<div class="info-value"><%=unidade.getCpfCnpjUsuario() != null ? unidade.getCpfCnpjUsuario() : "-"%></div>
					<div class="info-label">Total de Medições</div>
					<div class="info-value"><%=(medições != null ? medições.size() : 0)%></div>
				</div>
				<div class="info" style="flex: 0 0 200px;">
					<%
					if (podeEditar) {
					%>
					<div class="actions">
						<form
							action="<%=request.getContextPath()%>/pages/unidadeGeradora/editarUnidade.jsp"
							method="get" style="display: inline;">
							<input type="hidden" name="id" value="<%=unidade.getId()%>" />
							<button type="submit" class="btn btn-edit">Editar
								Unidade</button>
						</form>
						<form
							action="<%=request.getContextPath()%>/UnidadeGeradoraController"
							method="post" style="display: inline;"
							onsubmit="return confirm('Confirma exclusão desta unidade?');">
							<input type="hidden" name="action" value="deletar" /> <input
								type="hidden" name="id" value="<%=unidade.getId()%>" />
							<button type="submit" class="btn btn-delete">Excluir</button>
						</form>
					</div>
					<%
					}
					%>
				</div>
			</div>
		</div>

		<%
		if (podeEditar) {
		%>
		<a
			href="<%=request.getContextPath()%>/pages/medicao/adicionarMedicao.jsp?unidadeId=<%=unidade.getId()%>"
			class="btn btn-edit" style="margin-bottom: 20px;"> + Adicionar
			Medição </a>
		<%
		}
		%>

		<div class="card" aria-labelledby="medicoes-title">
			<h2 id="medicoes-title">Medições Recentes</h2>
			<%
			if (medições == null || medições.isEmpty()) {
			%>
			<p>Não há medições registradas para esta unidade.</p>
			<%
			} else {
			double totalGerada = 0, totalConsumidaLocal = 0, totalInjetada = 0;
			for (Medicao m : medições) {
				totalGerada += m.getEnergiaGerada();
				totalConsumidaLocal += m.getEnergiaConsumidaLocalmente();
				totalInjetada += m.getEnergiaInjetadaNaRede();
			}
			%>
			<div class="summary">
				<div class="summary-item">
					Total Gerado: <strong><%=String.format("%.2f", totalGerada)%>
						kWh</strong>
				</div>
				<div class="summary-item">
					Consumido Localmente: <strong><%=String.format("%.2f", totalConsumidaLocal)%>
						kWh</strong>
				</div>
				<div class="summary-item">
					Injetado na Rede: <strong><%=String.format("%.2f", totalInjetada)%>
						kWh</strong>
				</div>
			</div>

			<div class="table-wrapper">
				<table>
					<thead>
						<tr>
							<th>Data / Hora</th>
							<th>Energia Gerada (kWh)</th>
							<th>Consumida Localmente (kWh)</th>
							<th>Injetada na Rede (kWh)</th>
							<% if (podeEditar) { %>
							<th>Ações</th>
							<% } %>
						</tr>
					</thead>
					<tbody>
						<%
						for (Medicao m : medições) {
						%>
						<tr>
							<td><%=m.getDataMedicao().format(dtf)%></td>
							<td><%=String.format("%.2f", m.getEnergiaGerada())%></td>
							<td><%=String.format("%.2f", m.getEnergiaConsumidaLocalmente())%></td>
							<td><%=String.format("%.2f", m.getEnergiaInjetadaNaRede())%></td>
							<%
							if (podeEditar) {
							%>
							<td><a
								href="<%=request.getContextPath()%>/pages/medicao/editarMedicao.jsp?medicaoId=<%=m.getId()%>"
								class="btn btn-edit"
								style="padding: 5px 10px; font-size: 0.85rem;">Editar</a>
								<form action="<%=request.getContextPath()%>/MedicaoController"
									method="post" style="display: inline;"
									onsubmit="return confirm('Deseja realmente deletar esta medição?');">
									<input type="hidden" name="action" value="deletar" /> <input
										type="hidden" name="id" value="<%=m.getId()%>" /> <input
										type="hidden" name="unidadeGeradoraId"
										value="<%=unidade.getId()%>" />
									<button type="submit" class="btn btn-delete"
										style="padding: 5px 10px; font-size: 0.85rem;">Deletar</button>
								</form></td>
							<%
							}
							%>
						</tr>
						<%
						}
						%>
					</tbody>


				</table>
			</div>
			<%
			}
			%>
		</div>
	</main>
</body>
</html>

