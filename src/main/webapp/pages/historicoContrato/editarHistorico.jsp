<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*" %>
<%@ page import="br.com.monesol.dao.HistoricoContratoDAO" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    String idParam = request.getParameter("id");
    String contratoIdParam = request.getParameter("contratoId");
    HistoricoContrato historico = null;
    if (idParam != null) {
        try {
            int id = Integer.parseInt(idParam);
            HistoricoContratoDAO dao = new HistoricoContratoDAO();
            historico = dao.buscarPorId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (historico == null) {
        out.println("<p>Histórico não encontrado.</p>");
        return;
    }

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Editar Histórico - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />

</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />


<main aria-label="Editar Histórico de Ocorrência">
    <a href="javascript:history.back()" class="btn-back" aria-label="Voltar">&#8592; Voltar</a>

    <h1>Editar Histórico #<%= historico.getId() %></h1>

    <form action="<%= request.getContextPath() %>/HistoricoContratoController" method="post" novalidate>
        <input type="hidden" name="action" value="editar" />
        <input type="hidden" name="id" value="<%= historico.getId() %>" />
        <input type="hidden" name="contratoId" value="<%= contratoIdParam %>" />

        <label for="titulo">Título</label>
        <input type="text" id="titulo" name="titulo" value="<%= historico.getTitulo() %>" required />

        <label for="tipo">Tipo</label>
        <select id="tipo" name="tipo" required>
            <% for (HistoricoContrato.TipoHistorico t : HistoricoContrato.TipoHistorico.values()) { %>
                <option value="<%= t.name() %>" <%= t == historico.getTipo() ? "selected" : "" %>><%= t.name() %></option>
            <% } %>
        </select>

        <label for="descricao">Descrição</label>
        <textarea id="descricao" name="descricao" required><%= historico.getDescricao() %></textarea>

        <label for="dataHistorico">Data e Hora</label>
        <input type="datetime-local" id="dataHistorico" name="dataHistorico" 
               value="<%= historico.getDataHistorico() != null ? historico.getDataHistorico().format(dtf) : LocalDateTime.now().format(dtf) %>" required />

        <button type="submit">Salvar Alterações</button>
    </form>
</main>

</body>
</html>
