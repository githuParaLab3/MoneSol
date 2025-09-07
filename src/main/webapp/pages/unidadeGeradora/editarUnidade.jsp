<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.dao.UnidadeGeradoraDAO" %>
<%@ page import="br.com.monesol.model.UnidadeGeradora" %>
<%
    String idParam = request.getParameter("id");
    UnidadeGeradora unidade = null;
    if (idParam != null) {
        try {
            int id = Integer.parseInt(idParam);
            UnidadeGeradoraDAO dao = new UnidadeGeradoraDAO();
            unidade = dao.buscarPorId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (unidade == null) {
        out.println("<p>Unidade não encontrada.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Editar Unidade Geradora - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
   	<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />
   
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main aria-label="Editar Unidade Geradora">
    <a href="javascript:history.back()" class="btn-back" aria-label="Voltar para a página anterior">&larr; Voltar</a>

    <h1>Editar Unidade Geradora #<%= unidade.getId() %></h1>

    <form action="<%= request.getContextPath() %>/UnidadeGeradoraController" method="post" aria-label="Formulário de edição de unidade">
        <input type="hidden" name="action" value="editar" />
        <input type="hidden" name="id" value="<%= unidade.getId() %>" />

        <label for="localizacao">Localização</label>
        <input type="text" id="localizacao" name="localizacao" value="<%= unidade.getLocalizacao() %>" required />

        <label for="potenciaInstalada">Potência Instalada (kW)</label>
        <input type="number" id="potenciaInstalada" name="potenciaInstalada" step="0.01" min="0" value="<%= unidade.getPotenciaInstalada() %>" required />

        <label for="eficienciaMedia">Eficiência Média (%)</label>
        <input type="number" id="eficienciaMedia" name="eficienciaMedia" step="0.01" min="0" max="100" value="<%= unidade.getEficienciaMedia() %>" required />

        <label for="precoPorKWh">Preço por kWh (R$)</label>
        <input type="number" id="precoPorKWh" name="precoPorKWh" step="0.01" min="0" value="<%= unidade.getPrecoPorKWh() %>" required />

        <label for="quantidadeMinimaAceita">Quantidade Mínima Aceita (kWh)</label>
        <input type="number" id="quantidadeMinimaAceita" name="quantidadeMinimaAceita" step="0.01" min="0" value="<%= unidade.getQuantidadeMinimaAceita() %>" />

        <label for="regraDeExcecoes">Regra de Exceções</label>
        <input type="text" id="regraDeExcecoes" name="regraDeExcecoes" value="<%= unidade.getRegraDeExcecoes() != null ? unidade.getRegraDeExcecoes() : "" %>" placeholder="Ex: Se meta não batida, enviar alerta" />

        <label for="quantidadeMaximaComerciavel">Quantidade Máxima Comerciável (kWh)</label>
        <input type="number" step="0.01" id="quantidadeMaximaComerciavel" name="quantidadeMaximaComerciavel" value="<%= unidade.getQuantidadeMaximaComerciavel() %>" placeholder="Ex: 200.00" />

        <button type="submit">Salvar Alterações</button>
    </form>
</main>

</body>
</html>
