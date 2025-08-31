<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*"%>
<%@ page import="br.com.monesol.dao.MedicaoDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%
    HttpSession sessaoDetalhesUnidade = request.getSession(false);
    Usuario usuarioDetalhesUnidade = (sessaoDetalhesUnidade != null) ? (Usuario) sessaoDetalhesUnidade.getAttribute("usuarioLogado") : null;
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
        || (unidade.getCpfCnpjUsuario() != null && unidade.getCpfCnpjUsuario().equals(usuarioDetalhesUnidade.getCpfCnpj()));

  
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
	flex-direction: column;
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
	width: 100%;
	justify-content: center;
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

.btn-contract {
	background-color: #f7c600;
	color: #212121;
	font-size: 1.25rem;
	padding: 14px 30px;
	max-width: 320px;
	margin: 0 auto;
	display: block;
	border: 3px solid #212121;
	font-weight: 900;
	transition: background-color 0.3s ease, color 0.3s ease;
}

.btn-contract:hover {
	background-color: #e0b500;
	color: #000;
}

.btn-back {
	background: transparent;
	color: #212121;
	border: 2px solid #212121;
	border-radius: 30px;
	padding: 8px 18px;
	text-decoration: none;
	font-weight: 700;
	transition: background-color 0.25s ease, color 0.25s ease;
	display: inline-block;
	margin-bottom: 20px;
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

.small {
	font-size: 0.85rem;
	color: #666;
}

.badge {
	background: #ffd600;
	padding: 4px 12px;
	border-radius: 50px;
	font-weight: 700;
	font-size: 0.75rem;
	display: inline-block;
	margin-right: 6px;
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

@media ( max-width : 900px) {
	.flex {
		flex-direction: column;
	}
	.actions {
		flex-direction: column;
	}
}
</style>
</head>
<body>

	<jsp:include page="/pages/usuario/header.jsp" />

	<main aria-label="Detalhes da unidade geradora">
		<a
			href="<%= request.getContextPath() %>/pages/unidadeGeradora/listaUnidadesDisponiveis.jsp"
			class="btn btn-back">&larr; Voltar ao Marketplace</a>

		<h1>
			Unidade Geradora #<%= unidade.getId() %></h1>
		<div class="sub">Detalhes da unidade e medições recentes</div>

		<div class="card">
			<div class="flex">
				<div class="info">
					<div class="info-label">Localização</div>
					<div class="info-value"><%= unidade.getLocalizacao() %></div>

					<div class="info-label">Potência Instalada (kW)</div>
					<div class="info-value"><%= String.format("%.2f", unidade.getPotenciaInstalada()) %></div>

					<div class="info-label">Eficiência Média (%)</div>
					<div class="info-value"><%= String.format("%.1f", unidade.getEficienciaMedia() * 100) %></div>

					<div class="info-label">Preço por kWh (R$)</div>
					<div class="info-value"><%= String.format("%.2f", unidade.getPrecoPorKWh()) %></div>

					<div class="info-label">Quantidade Mínima Aceita (kWh)</div>
					<div class="info-value">
						<%= unidade.getQuantidadeMinimaAceita() > 0 ? String.format("%.2f", unidade.getQuantidadeMinimaAceita()) : "-" %>
					</div>
					<div class="info-label">Regra de Exceções</div>
					<div class="info-value">
						<%= (unidade.getRegraDeExcecoes() != null && !unidade.getRegraDeExcecoes().isBlank())
         ? unidade.getRegraDeExcecoes()
         : "Não definida" %>
					</div>

				</div>
				<div class="info">

					<div class="info-label">Total de Medições</div>
					<div class="info-value"><%= (medições != null ? medições.size() : 0) %></div>
				</div>
				<div class="info" style="flex: 0 0 200px;">
					<% if (podeEditar) { %>
					<div class="actions">
						<form
							action="<%= request.getContextPath() %>/pages/unidadeGeradora/editarUnidade.jsp"
							method="get" style="width: 100%;">
							<input type="hidden" name="id" value="<%= unidade.getId() %>" />
							<button type="submit" class="btn btn-edit">Editar
								Unidade</button>
						</form>

						<form
							action="<%= request.getContextPath() %>/UnidadeGeradoraController"
							method="post" style="width: 100%;"
							onsubmit="return confirm('Confirma exclusão desta unidade?');">
							<input type="hidden" name="action" value="deletar" /> <input
								type="hidden" name="id" value="<%= unidade.getId() %>" />
							<button type="submit" class="btn btn-delete">Excluir</button>
						</form>
					</div>
					<% } %>
				</div>
			</div>
		</div>

		<% if (podeEditar) { %>
		<button id="btnToggleForm" class="btn btn-edit"
			style="margin-bottom: 20px;">+ Adicionar Medição</button>

		<div id="formMedicao" class="card"
			style="display: none; max-width: 480px; margin-bottom: 30px;">
			<h2>Adicionar Nova Medição</h2>
			<form action="<%= request.getContextPath() %>/MedicaoController"
				method="post">
				<input type="hidden" name="action" value="adicionar" /> <input
					type="hidden" name="unidadeGeradoraId"
					value="<%= unidade.getId() %>" /> <label for="dataMedicao">Data
					e Hora da Medição:</label><br /> <input type="datetime-local"
					id="dataMedicao" name="dataMedicao" required
					style="width: 100%; margin-bottom: 15px; padding: 8px;" /> <label
					for="energiaGerada">Energia Gerada (kWh):</label><br /> <input
					type="number" step="0.01" min="0" id="energiaGerada"
					name="energiaGerada" required
					style="width: 100%; margin-bottom: 15px; padding: 8px;" /> <label
					for="energiaConsumidaLocalmente">Energia Consumida
					Localmente (kWh):</label><br /> <input type="number" step="0.01" min="0"
					id="energiaConsumidaLocalmente" name="energiaConsumidaLocalmente"
					required style="width: 100%; margin-bottom: 15px; padding: 8px;" />

				<label for="energiaInjetadaNaRede">Energia Injetada na Rede
					(kWh):</label><br /> <input type="number" step="0.01" min="0"
					id="energiaInjetadaNaRede" name="energiaInjetadaNaRede" required
					style="width: 100%; margin-bottom: 15px; padding: 8px;" />

				<button type="submit" class="btn btn-edit" style="width: 100%;">Adicionar
					Medição</button>
			</form>
		</div>

		<script>
        document.getElementById('btnToggleForm').addEventListener('click', function() {
            const form = document.getElementById('formMedicao');
            if (form.style.display === 'none' || form.style.display === '') {
                form.style.display = 'block';
                this.textContent = '− Fechar Formulário';
            } else {
                form.style.display = 'none';
                this.textContent = '+ Adicionar Medição';
            }
        });
    </script>
		<% } %>

		<div class="card" aria-labelledby="medicoes-title">
			<h2 id="medicoes-title">Medições Recentes</h2>
			<% if (medições == null || medições.isEmpty()) { %>
			<p>Não há medições registradas para esta unidade.</p>
			<% } else { 
            double totalGerada = 0;
            double totalConsumidaLocal = 0;
            double totalInjetada = 0;
            for (Medicao m : medições) {
                totalGerada += m.getEnergiaGerada();
                totalConsumidaLocal += m.getEnergiaConsumidaLocalmente();
                totalInjetada += m.getEnergiaInjetadaNaRede();
            }
        %>
			<div class="summary" aria-label="Resumo das medições">
				<div class="summary-item">
					Total Gerado: <strong><%= String.format("%.2f", totalGerada) %>
						kWh</strong>
				</div>
				<div class="summary-item">
					Consumido Localmente: <strong><%= String.format("%.2f", totalConsumidaLocal) %>
						kWh</strong>
				</div>
				<div class="summary-item">
					Injetado na Rede: <strong><%= String.format("%.2f", totalInjetada) %>
						kWh</strong>
				</div>
			</div>

			<div class="table-wrapper">
				<table aria-label="Tabela de medições da unidade">
					<thead>
						<tr>
							<th>Data / Hora</th>
							<th>Energia Gerada (kWh)</th>
							<th>Consumida Localmente (kWh)</th>
							<th>Injetada na Rede (kWh)</th>
						</tr>
					</thead>
					<tbody>
						<% for (Medicao m : medições) { %>
						<tr>
							<td><%= m.getDataMedicao().format(dtf) %></td>
							<td><%= String.format("%.2f", m.getEnergiaGerada()) %></td>
							<td><%= String.format("%.2f", m.getEnergiaConsumidaLocalmente()) %></td>
							<td><%= String.format("%.2f", m.getEnergiaInjetadaNaRede()) %></td>
						</tr>
						<% } %>
					</tbody>
				</table>
			</div>
			<% } %>
		</div>

		<% if (!unidade.getCpfCnpjUsuario().equals(usuarioDetalhesUnidade.getCpfCnpj())) { %>
		<form
			action="<%= request.getContextPath() %>/pages/contrato/cadastrarContrato.jsp"
			method="get" style="text-align: center; margin-top: 30px;">
			<input type="hidden" name="unidadeGeradoraId"
				value="<%= unidade.getId() %>" />
			<button type="submit" class="btn btn-contract">Firmar
				Contrato</button>
		</form>
		<% } %>

	</main>

</body>
</html>
