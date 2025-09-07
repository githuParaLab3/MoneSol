<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*" %>
<%@ page import="br.com.monesol.dao.DocumentoDAO" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>

<%
    String idParam = request.getParameter("id");
    String contratoIdParam = request.getParameter("contratoId");
    Documento documento = null;

    if (idParam != null) {
        try {
            int id = Integer.parseInt(idParam);
            DocumentoDAO dao = new DocumentoDAO();
            documento = dao.buscarPorId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    if (documento == null) {
        out.println("<p>Documento não encontrado.</p>");
        return;
    }

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Editar Documento - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />

</head>
<body>
    <jsp:include page="/pages/outros/mensagens.jsp" />
    <main aria-label="Editar Documento">
        <a href="javascript:history.back()" class="btn-back" aria-label="Voltar">
            &#8592; Voltar
        </a>

        <h1>Editar Documento #<%= documento.getId() %></h1>

        <form action="<%= request.getContextPath() %>/DocumentoController" method="post" enctype="multipart/form-data" novalidate>
            <input type="hidden" name="action" value="editar" />
            <input type="hidden" name="id" value="<%= documento.getId() %>" />
            <input type="hidden" name="contratoId" value="<%= contratoIdParam %>" />

            <label for="tipo">Tipo de Documento</label>
            <select id="tipo" name="tipo" required>
                <% for (Documento.TipoDocumento t : Documento.TipoDocumento.values()) { %>
                    <option value="<%= t.name() %>" <%= t == documento.getTipo() ? "selected" : "" %>><%= t.name() %></option>
                <% } %>
            </select>

            <label for="descricao">Descrição</label>
            <textarea id="descricao" name="descricao" required><%= documento.getDescricao() %></textarea>

            <label for="arquivo">Substituir Arquivo (opcional)</label>
            <input type="file" id="arquivo" name="arquivo" />

            <label for="dataDocumento">Data e Hora do Documento</label>
            <input type="datetime-local" id="dataDocumento" name="dataDocumento" 
                   value="<%= documento.getDataDocumento() != null ? documento.getDataDocumento().format(dtf) : LocalDateTime.now().format(dtf) %>" required />

            <button type="submit">Salvar Alterações</button>
        </form>
    </main>
</body>
</html>
