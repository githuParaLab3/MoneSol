<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*" %>
<%@ page import="br.com.monesol.dao.MedicaoDAO" %>
<%
    String medicaoIdStr = request.getParameter("medicaoId");
    if (medicaoIdStr == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        return;
    }

    int medicaoId = Integer.parseInt(medicaoIdStr);
    MedicaoDAO medicaoDAO = new MedicaoDAO();
    Medicao medicao = medicaoDAO.buscarPorId(medicaoId);

    if (medicao == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        return;
    }

    UnidadeGeradora unidade = medicao.getUnidadeGeradora();
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Editar Medição - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />

</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main aria-label="Editar Medição">
    <a href="javascript:history.back();" class="btn-back" aria-label="Voltar para a página anterior">&larr; Voltar</a>

    <h1>Editar Medição</h1>
    <form action="<%= request.getContextPath() %>/MedicaoController" method="post">
        <input type="hidden" name="action" value="editar"/>
        <input type="hidden" name="id" value="<%= medicao.getId() %>"/>
        <input type="hidden" name="unidadeGeradoraId" value="<%= unidade.getId() %>"/>

        <label for="dataMedicao">Data e Hora da Medição:</label>
        <input type="datetime-local" id="dataMedicao" name="dataMedicao" 
               value="<%= medicao.getDataMedicao().toString() %>" required/>

        <label for="energiaGerada">Energia Gerada (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaGerada" name="energiaGerada" value="<%= medicao.getEnergiaGerada() %>" required/>

        <label for="energiaConsumidaLocalmente">Energia Consumida Localmente (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaConsumidaLocalmente" name="energiaConsumidaLocalmente" value="<%= medicao.getEnergiaConsumidaLocalmente() %>" required/>

        <label for="energiaInjetadaNaRede">Energia Injetada na Rede (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaInjetadaNaRede" name="energiaInjetadaNaRede" value="<%= medicao.getEnergiaInjetadaNaRede() %>" required/>

        <button type="submit">Salvar Alterações</button>
    </form>
</main>

</body>
</html>
