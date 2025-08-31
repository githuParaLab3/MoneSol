<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.util.List"%>

<%
    Contrato contrato = (Contrato) request.getAttribute("contrato");
    List<Documento> listaDocumentos = (List<Documento>) request.getAttribute("listaDocumentos");
    List<HistoricoContrato> listaHistoricos = (List<HistoricoContrato>) request.getAttribute("listaHistoricos");
    
    if (contrato == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        return;
    }
    
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dtfHora = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    Usuario usuario = null;
    HttpSession sessao = request.getSession(false);
    if (sessao != null) {
        usuario = (Usuario) sessao.getAttribute("usuarioLogado");
    }
    
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Detalhes do Contrato - MoneSol</title>
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
	max-width: 800px;
	margin: 30px auto;
	padding: 0 20px 60px;
}

h1, h2, h3 {
	color: #212121;
}

h1 {
	font-size: 2.4rem;
	font-weight: 900;
	margin-bottom: 15px;
	text-align: center;
}

h2 {
	font-size: 1.8rem;
	margin-bottom: 20px;
	border-bottom: 2px solid #f7c600;
	padding-bottom: 8px;
}

h3 {
	font-size: 1.4rem;
	margin-top: 30px;
	margin-bottom: 12px;
	color: #555;
}

.card {
	background: #ffffff;
	border-radius: 12px;
	border: 1.5px solid #f7c600;
	padding: 25px 30px;
	margin-bottom: 30px;
	box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25);
}

.info {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 14px;
	gap: 12px;
	flex-wrap: wrap;
}

.info-label {
	font-weight: 700;
	color: #555;
	flex: 0 0 180px;
	min-width: 120px;
}

.info-value {
	background: #f9f6d8;
	padding: 10px 14px;
	border-radius: 8px;
	font-size: 1rem;
	color: #2e2e2e;
	flex: 1 1 auto;
	word-wrap: break-word;
}

@media ( max-width : 520px) {
	.info {
		flex-direction: column;
		align-items: flex-start;
	}
	.info-label {
		flex: none;
		width: 100%;
		margin-bottom: 6px;
	}
	.info-value {
		width: 100%;
	}
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
	color: #212121;
	border: 2px solid #212121;
	background: transparent;
	margin-top: 10px;
	margin-bottom: 30px;
}

.btn:hover {
	background: #212121;
	color: #ffd600;
	border-color: #ffd600;
	text-decoration: none;
}

.btn-delete {
	background: #d32f2f;
	color: #fff;
	border-color: #d32f2f;
}

.btn-delete:hover {
	background: #b71c1c;
	border-color: #b71c1c;
	color: #fff;
}

td .btn {
	padding: 6px 12px;
	font-size: 0.9rem;
	display: inline-block;
	margin: 3px;
	border-radius: 20px;
	border: 1.5px solid #212121;
}

table.documentos {
	width: 100%;
	border-collapse: collapse;
	margin-top: 15px;
}

table.documentos th, table.documentos td {
	border: 1px solid #f7c600;
	padding: 10px 12px;
	text-align: left;
}

table.documentos th {
	background: #f7c600;
	color: #212121;
	font-weight: 700;
}

table.documentos tr:nth-child(even) {
	background: #fff9d1;
}

a.arquivo-link {
	color: #212121;
	text-decoration: none;
	font-weight: 700;
}

a.arquivo-link:hover {
	text-decoration: underline;
	color: #f7c600;
}

body.pagina-detalhes-contrato header, body.pagina-detalhes-contrato #header,
	body.pagina-detalhes-contrato .header {
	padding-top: 8px !important;
	padding-bottom: 8px !important;
	margin-bottom: 20px !important;
	height: auto !important;
	line-height: normal !important;
}
</style>
</head>
<body class="pagina-detalhes-contrato">
	<jsp:include page="/pages/outros/mensagens.jsp" />

	<jsp:include page="/pages/usuario/header.jsp" />

	<main aria-label="Detalhes do contrato">
		<a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp"
			class="btn">&larr; Voltar</a>
		<h1>Detalhes do Contrato</h1>

		<form action="<%= request.getContextPath() %>/ContratoController"
			method="post"
			onsubmit="return confirm('Deseja realmente cancelar este contrato? Esta ação não pode ser desfeita.');"
			style="margin-bottom: 20px;">
			<input type="hidden" name="action" value="deletar" /> <input
				type="hidden" name="id" value="<%= contrato.getId() %>" />
			<button type="submit" class="btn btn-delete">Cancelar
				Contrato</button>
		</form>

		<% if (usuario.getTipo() == Usuario.TipoUsuario.DONO_GERADORA) { %>
		<a href="<%= request.getContextPath() %>/ContratoController?action=formEditar&id=<%= contrato.getId() %>"
			class="btn">Editar Contrato</a>
		<% } %>

		<div class="card">
			<div class="info">
				<span class="info-label">ID do Contrato:</span><span
					class="info-value"><%= contrato.getId() %></span>
			</div>
			<div class="info">
				<span class="info-label">Vigência:</span><span class="info-value"><%= contrato.getVigenciaInicio() != null ? dtf.format(contrato.getVigenciaInicio()) : "-" %>
					até <%= contrato.getVigenciaFim() != null ? dtf.format(contrato.getVigenciaFim()) : "-" %></span>
			</div>
			<div class="info">
				<span class="info-label">Reajuste a cada:</span><span
					class="info-value"><%= contrato.getReajustePeriodico() %>
					meses</span>
			</div>
			<div class="info">
				<span class="info-label">Quantidade contratada:</span><span
					class="info-value"><%= contrato.getQuantidadeContratada() + " kWh" %></span>
			</div>
			<div class="info">
				<span class="info-label">CPF/CNPJ Usuário:</span><span
					class="info-value"><%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "-" %></span>
			</div>
			<div class="info">
				<span class="info-label">ID Unidade Geradora:</span><span
					class="info-value"><%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getId() : "-" %></span>
			</div>
			<div class="info">
				<span class="info-label">Localização Unidade:</span><span
					class="info-value"><%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getLocalizacao() : "-" %></span>
			</div>
		</div>

		<h2>Documentos Associados</h2>
		<% if (usuario != null && usuario.getTipo() == Usuario.TipoUsuario.DONO_GERADORA) { %>
		<form
			action="<%= request.getContextPath() %>/pages/documento/cadastrarDocumento.jsp"
			method="get" style="margin-bottom: 15px;">
			<input type="hidden" name="contratoId"
				value="<%= contrato.getId() %>" />
			<button type="submit" class="btn">+ Novo Documento</button>
		</form>
		<% } %>
		<div class="card">
			<% if (listaDocumentos != null && !listaDocumentos.isEmpty()) { %>
			<table class="documentos">
				<thead>
					<tr>
						<th>ID</th>
						<th>Tipo</th>
						<th>Descrição</th>
						<th>Data</th>
						<th>Arquivo</th>
						<th>Ações</th>
					</tr>
				</thead>
				<tbody>
					<% for (Documento doc : listaDocumentos) { %>
					<tr>
						<td><%= doc.getId() %></td>
						<td><%= doc.getTipo().name() %></td>
						<td><%= doc.getDescricao() %></td>
						<td><%= dtfHora.format(doc.getDataDocumento()) %></td>
						<td>
							<% if (doc.getArquivo() != null && !doc.getArquivo().isEmpty()) { %>
							<a
							href="<%= request.getContextPath() + "/" + doc.getArquivo() %>"
							target="_blank" class="btn">Abrir</a> <% } else { %> - <% } %>
						</td>
						<td>
							<% if (usuario != null && usuario.getTipo() == Usuario.TipoUsuario.DONO_GERADORA) { %>
							<form
								action="<%= request.getContextPath() %>/pages/documento/editarDocumento.jsp"
								method="get" style="margin: 0; display: inline;">
								<input type="hidden" name="id" value="<%= doc.getId() %>" /> <input
									type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
								<button type="submit" class="btn">Editar</button>
							</form>
							<form
								action="<%= request.getContextPath() %>/DocumentoController"
								method="post" style="margin: 0; display: inline;">
								<input type="hidden" name="action" value="deletar" /> <input
									type="hidden" name="id" value="<%= doc.getId() %>" />
								<button type="submit" class="btn"
									onclick="return confirm('Deseja realmente deletar este documento?');">Deletar</button>
							</form> <% } %>
						</td>
					</tr>
					<% } %>
				</tbody>
			</table>
			<% } else { %>
			<p>Não há documentos associados a este contrato.</p>
			<% } %>
		</div>

		<h2>Histórico de Ocorrências</h2>
		<% if (usuario != null && usuario.getTipo() == Usuario.TipoUsuario.DONO_GERADORA) { %>
		<form
			action="<%= request.getContextPath() %>/pages/historicoContrato/cadastrarHistorico.jsp"
			method="get" style="margin-bottom: 15px;">
			<input type="hidden" name="contratoId"
				value="<%= contrato.getId() %>" />
			<button type="submit" class="btn">+ Nova Ocorrência</button>
		</form>
		<% } %>
		<div class="card">
			<% if (listaHistoricos != null && !listaHistoricos.isEmpty()) { %>
			<table class="documentos">
				<thead>
					<tr>
						<th>ID</th>
						<th>Data</th>
						<th>Título</th>
						<th>Tipo</th>
						<th>Descrição</th>
						<th>Ações</th>
					</tr>
				</thead>
				<tbody>
					<% for (HistoricoContrato hist : listaHistoricos) { %>
					<tr>
						<td><%= hist.getId() %></td>
						<td><%= dtfHora.format(hist.getDataHistorico()) %></td>
						<td><%= hist.getTitulo() %></td>
						<td><%= hist.getTipo().name() %></td>
						<td><%= hist.getDescricao() %></td>
						<td>
							<% if (usuario != null && usuario.getTipo() == Usuario.TipoUsuario.DONO_GERADORA) { %>
							<form
								action="<%= request.getContextPath() %>/pages/historicoContrato/editarHistorico.jsp"
								method="get" style="margin: 0; display: inline;">
								<input type="hidden" name="id" value="<%= hist.getId() %>" /> <input
									type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
								<button type="submit" class="btn">Editar</button>
							</form>
							<form
								action="<%= request.getContextPath() %>/HistoricoContratoController"
								method="post" style="margin: 0; display: inline;">
								<input type="hidden" name="action" value="deletar" /> <input
									type="hidden" name="id" value="<%= hist.getId() %>" /> <input
									type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
								<button type="submit" class="btn"
									onclick="return confirm('Deseja realmente deletar esta ocorrência?');">Deletar</button>
							</form> <% } %>
						</td>
					</tr>
					<% } %>
				</tbody>
			</table>
			<% } else { %>
			<p>Não há ocorrências registradas para este contrato.</p>
			<% } %>
		</div>

	</main>
</body>
</html>