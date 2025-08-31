<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="br.com.monesol.model.UnidadeGeradora"%>
<%@ page import="br.com.monesol.model.Usuario"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<%
    HttpSession sessionCadastrarContrato = request.getSession(false);
    Usuario usuarioLogado = (sessionCadastrarContrato != null) ? (Usuario) sessionCadastrarContrato.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String cpfCnpj = usuarioLogado.getCpfCnpj();

    if (cpfCnpj == null) {
        response.sendRedirect("../login.jsp"); 
        return;
    }

    UnidadeGeradora unidade = (UnidadeGeradora) request.getAttribute("unidade");
    LocalDate dataInicio = (LocalDate) request.getAttribute("dataInicio");
    LocalDate dataFim = (LocalDate) request.getAttribute("dataFim");
    
    if (unidade == null) {
        String unidadeIdStr = request.getParameter("unidadeGeradoraId");
        if (unidadeIdStr != null && !unidadeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ContratoController?action=formCadastrar&unidadeGeradoraId=" + unidadeIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
        return;
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<title>Fechar Contrato - MoneSol</title>
<link rel="stylesheet" href="../../assets/css/monesol.css" />
<style>
.container {
	max-width: 600px;
	margin: 40px auto 60px;
	background: #fff;
	border-radius: 12px;
	padding: 30px 35px;
	box-shadow: 0 10px 25px rgba(247, 198, 0, 0.25);
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	color: #212121;
}

h1 {
	font-size: 2rem;
	font-weight: 900;
	margin-bottom: 30px;
	text-align: center;
	color: #212121;
}

form {
	display: flex;
	flex-direction: column;
	gap: 18px;
}

label {
	font-weight: 700;
	color: #555;
	margin-bottom: 6px;
	user-select: none;
}

input[type="text"], input[type="number"], input[type="date"], textarea {
	border: 1.8px solid #f7c600;
	border-radius: 8px;
	padding: 10px 14px;
	font-size: 1rem;
	color: #212121;
	background-color: #f9f6d8;
	transition: border-color 0.3s ease;
	resize: vertical;
	font-family: inherit;
}

input[type="text"]:focus, input[type="number"]:focus, input[type="date"]:focus,
	textarea:focus {
	outline: none;
	border-color: #d49f00;
	background-color: #fffde7;
}

textarea {
	min-height: 70px;
	max-height: 140px;
}

input[type="number"] {
	-moz-appearance: textfield;
}

input[type=number]::-webkit-inner-spin-button, input[type=number]::-webkit-outer-spin-button
	{
	-webkit-appearance: none;
	margin: 0;
}

button[type="submit"] {
	background-color: #212121;
	color: #ffd600;
	font-weight: 700;
	font-size: 1.1rem;
	padding: 14px 0;
	border: none;
	border-radius: 30px;
	cursor: pointer;
	transition: background-color 0.3s ease;
	user-select: none;
	margin-top: 15px;
}

button[type="submit"]:hover {
	background-color: #000;
}

@media ( max-width : 480px) {
	.container {
		margin: 20px 15px 40px;
		padding: 25px 20px;
	}
}
</style>
</head>

<body>
	<div style="max-width: 800px; margin: 30px auto 10px; padding: 0 20px;">
		<a
			href="<%=request.getContextPath()%>/pages/unidadeGeradora/listaUnidadesDisponiveis.jsp"
			style="display: inline-block; background: transparent; color: #d49f00; border: 2px solid #d49f00; border-radius: 30px; padding: 10px 22px; font-weight: 700; text-decoration: none; cursor: pointer; transition: background-color 0.3s ease; user-select: none;"
			onmouseover="this.style.backgroundColor='#d49f00'; this.style.color='#212121';"
			onmouseout="this.style.backgroundColor='transparent'; this.style.color='#d49f00';"
			aria-label="Voltar para Marketplace"> ← Desistir da
			Contratação </a>
	</div>

	<div class="container">
		<h1>
			Fechar Contrato - Unidade:
			<%= unidade.getLocalizacao() %>
			(ID:
			<%= unidade.getId() %>)
		</h1>

		<form action="<%=request.getContextPath()%>/ContratoController"
			method="post">
			<input type="hidden" name="action" value="adicionar" /> 
			<input type="hidden" name="unidadeGeradoraId" value="<%= unidade.getId() %>" /> 
			<input type="hidden" name="usuarioCpfCnpj" value="<%= cpfCnpj %>" /> 
			
			<label for="vigenciaInicio">Vigência Início:</label> 
			<input type="date" id="vigenciaInicio" name="vigenciaInicio" 
			       value="<%= formatter.format(dataInicio) %>" required /> 
			
			<label for="vigenciaFim">Vigência Fim:</label> 
			<input type="date" id="vigenciaFim" name="vigenciaFim"
				   value="<%= formatter.format(dataFim) %>" required /> 
			
			<label for="reajustePeriodico">Reajuste Periódico (meses):</label> 
			<input type="number" id="reajustePeriodico" name="reajustePeriodico" 
			       min="1" value="12" required /> 
			
			<label for="quantidadeContratada">Quantidade Contratada (kWh):</label> 
			<input type="number" id="quantidadeContratada" name="quantidadeContratada"
				   step="0.01" min="<%= unidade.getQuantidadeMinimaAceita() %>" required /> 
			
			<small style="color: #555; font-size: 0.9rem;">
				Mínimo aceito: <%= unidade.getQuantidadeMinimaAceita() %> kWh
			</small>

			<button type="submit">Fechar Contrato</button>
		</form>
	</div>
</body>
</html>