<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.Usuario" %>
<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Cadastrar Unidade Geradora - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />

</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main aria-label="Formulário de cadastro de unidade geradora">
    <a href="javascript:history.back();" class="btn-back" aria-label="Voltar para a página anterior">&larr; Voltar</a>

    <h1>Cadastrar Unidade Geradora</h1>

    <form action="<%= request.getContextPath() %>/UnidadeGeradoraController" method="post" aria-label="Formulário de nova unidade">
        <input type="hidden" name="action" value="adicionar" />

        <label for="localizacao">Localização</label>
        <input type="text" id="localizacao" name="localizacao" required placeholder="Ex: Fazenda Solar, São Paulo" />

        <label for="potenciaInstalada">Potência Instalada (kW)</label>
        <input type="number" step="0.01" id="potenciaInstalada" name="potenciaInstalada" required placeholder="Ex: 12.50" />

        <label for="eficienciaMedia">Eficiência Média (%)</label>
        <input type="number" step="0.01" id="eficienciaMedia" name="eficienciaMedia" required placeholder="Ex: 85.5" />
        <div class="note">Informe em porcentagem; será convertido automaticamente.</div>

        <label for="precoPorKWh">Preço por kWh (R$)</label>
        <input type="number" step="0.01" id="precoPorKWh" name="precoPorKWh" required placeholder="Ex: 0.50" />

        <label for="quantidadeMinimaAceita">Quantidade Mínima Aceita (kWh)</label>
        <input type="number" step="0.01" id="quantidadeMinimaAceita" name="quantidadeMinimaAceita" placeholder="Ex: 100.00" />
        <div class="note">Opcional; deixe em branco se não houver mínimo.</div>

        <label for="regraDeExcecoes">Regra de Exceções</label>
        <input type="text" id="regraDeExcecoes" name="regraDeExcecoes" placeholder="Ex: Se meta não batida, desconto de 10%" />
        <div class="note">Descreva o que será feito caso a meta não seja atingida.</div>

        <label for="quantidadeMaximaComerciavel">Quantidade Máxima Comerciável (kWh)</label>
        <input type="number" step="0.01" id="quantidadeMaximaComerciavel" name="quantidadeMaximaComerciavel" placeholder="Ex: 200.00" />

        <button type="submit">Cadastrar Unidade</button>
    </form>
</main>

</body>
</html>
