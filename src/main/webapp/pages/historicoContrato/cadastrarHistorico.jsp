<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.Contrato" %>
<%
    String contratoIdStr = request.getParameter("contratoId");
    if (contratoIdStr == null || contratoIdStr.isEmpty()) {
        out.println("<script>alert('Contrato não informado!'); window.history.back();</script>");
        return;
    }
    int contratoId = Integer.parseInt(contratoIdStr);
    Contrato contrato = new Contrato();
    contrato.setId(contratoId);
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Nova Ocorrência - Contrato</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />
</head>
<body>
    <jsp:include page="/pages/outros/mensagens.jsp" />

    <main aria-label="Formulário de nova ocorrência do contrato">
        <a href="javascript:history.back()" class="btn-back" aria-label="Voltar">
            &#8592; Voltar
        </a>

        <h1>Nova Ocorrência - Contrato #<%= contrato.getId() %></h1>

        <form action="<%= request.getContextPath() %>/HistoricoContratoController" method="post" aria-label="Formulário de nova ocorrência">
            <input type="hidden" name="action" value="adicionar" />
            <input type="hidden" name="contratoId" value="<%= contrato.getId() %>" />

            <label for="dataHistorico">Data e Hora:</label>
            <%
                java.time.LocalDateTime now = java.time.LocalDateTime.now().withSecond(0).withNano(0);
                String nowStr = now.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            %>
            <input type="datetime-local" id="dataHistorico" name="dataHistorico" value="<%= nowStr %>" required />

            <label for="titulo">Título da ocorrência:</label>
            <input type="text" id="titulo" name="titulo" required />

            <label for="descricao">Descrição da ocorrência:</label>
            <textarea id="descricao" name="descricao" required></textarea>

            <label for="tipo">Tipo de ocorrência:</label>
            <select id="tipo" name="tipo" required>
                <option value="" disabled selected>-- Selecione --</option>
                <option value="ALOCACAO">Alocação</option>
                <option value="MANUTENCAO">Manutenção</option>
                <option value="RELATORIO">Relatório</option>
                <option value="ALTERACAO_CONTRATUAL">Alteração Contratual</option>
                <option value="OUTRO">Outro</option>
            </select>

            <button type="submit">Salvar Ocorrência</button>
        </form>
    </main>
</body>
</html>
