<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String unidadeId = request.getParameter("unidadeId");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Adicionar Medição - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
	<link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<main aria-label="Adicionar nova medição">
    <a href="javascript:history.back()" class="btn-back" aria-label="Voltar para a página anterior">&larr; Voltar</a>

    <h1>Adicionar Medição</h1>

    <form action="<%= request.getContextPath() %>/MedicaoController" method="post">
        <input type="hidden" name="action" value="adicionar"/>
        <input type="hidden" name="unidadeGeradoraId" value="<%= unidadeId %>"/>

        <label for="dataMedicao">Data e Hora da Medição:</label>
        <input type="datetime-local" id="dataMedicao" name="dataMedicao"
               value="<%= java.time.LocalDateTime.now().withSecond(0).withNano(0).toString() %>" required/>

        <label for="energiaGerada">Energia Gerada (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaGerada" name="energiaGerada" required/>

        <label for="energiaConsumidaLocalmente">Energia Consumida Localmente (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaConsumidaLocalmente" name="energiaConsumidaLocalmente" required/>

        <label for="energiaInjetadaNaRede">Energia Injetada na Rede (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaInjetadaNaRede" name="energiaInjetadaNaRede" required/>

        <button type="submit">Salvar Medição</button>
    </form>
</main>

</body>
</html>
