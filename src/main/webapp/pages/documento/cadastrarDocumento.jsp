<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Documento.TipoDocumento"%>

<%
    String contratoId = request.getParameter("contratoId");
    if (contratoId == null || contratoId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        return;
    }

    java.time.LocalDateTime agora = java.time.LocalDateTime.now();
    String dataHoraFormatada = agora.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Cadastrar Documento - MoneSol</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="../../assets/css/monesol.css" />
<style>
main {
	max-width: 600px;
	margin: 40px auto;
	background: #fff8e1;
	padding: 30px;
	border-radius: 12px;
	box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25);
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

h1 {
	text-align: center;
	margin-bottom: 25px;
	color: #212121;
	font-weight: 900;
}

label {
	display: block;
	margin: 15px 0 6px;
	font-weight: 700;
	color: #555;
}

input[type="text"], select, input[type="datetime-local"], textarea {
	width: 100%;
	padding: 10px 12px;
	border: 1.5px solid #f7c600;
	border-radius: 8px;
	font-size: 1rem;
	color: #2e2e2e;
	background: #f9f6d8;
	resize: vertical;
}

textarea {
	min-height: 80px;
}

button {
	margin-top: 25px;
	width: 100%;
	padding: 12px 0;
	border: none;
	border-radius: 30px;
	background: #f7c600;
	color: #212121;
	font-weight: 700;
	font-size: 1.1rem;
	cursor: pointer;
	transition: background 0.25s ease;
}

button:hover {
	background: #d4af00;
}

.btn-voltar {
	display: inline-block;
	margin-bottom: 25px;
	font-weight: 700;
	color: #212121;
	border: 2px solid #212121;
	padding: 8px 20px;
	border-radius: 30px;
	text-decoration: none;
	transition: background 0.25s ease;
	cursor: pointer;
	background: transparent;
}

.btn-voltar:hover {
	background: #212121;
	color: #ffd600;
	border-color: #ffd600;
	text-decoration: none;
}
</style>
</head>
<body>
	<jsp:include page="/pages/outros/mensagens.jsp" />

	<jsp:include page="/pages/usuario/header.jsp" />

	<main aria-label="Cadastrar novo documento">

		<button type="button" class="btn-voltar"
			aria-label="Voltar para a página anterior"
			onclick="window.history.back();">&larr; Voltar</button>

		<h1>Cadastrar Documento</h1>

		<form action="<%= request.getContextPath() %>/DocumentoController"
			method="post" enctype="multipart/form-data">
			<input type="hidden" name="action" value="adicionar" /> <input
				type="hidden" name="contratoId" value="<%= contratoId %>" /> <label
				for="tipo">Tipo de Documento:</label> <select id="tipo" name="tipo"
				required>
				<option value="" disabled selected>Selecione o tipo</option>
				<option value="MANUTENCAO">Manutenção</option>
				<option value="RELATORIO">Relatório</option>
			</select> <label for="descricao">Descrição:</label> <input type="text"
				id="descricao" name="descricao" maxlength="255" required /> <label
				for="dataDocumento">Data e Hora do Documento:</label> <input
				type="datetime-local" id="dataDocumento" name="dataDocumento"
				required value="<%= dataHoraFormatada %>" /> <label for="arquivo">Selecione
				o arquivo:</label> <input type="file" id="arquivo" name="arquivo" required />

			<button type="submit">Salvar Documento</button>
		</form>



	</main>

</body>
</html>
