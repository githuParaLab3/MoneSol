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
<style>
body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #fff8e1; color: #2e2e2e; min-height: 100vh; margin: 0; padding: 0; }
main { max-width: 600px; margin: 40px auto; background: #fff; border: 1.5px solid #f7c600; border-radius: 12px; padding: 30px 25px; box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25); }
h1 { font-size: 2rem; font-weight: 900; color: #212121; margin-bottom: 25px; text-align: center; }
label { display: block; font-weight: 700; margin-bottom: 8px; color: #555; }
input[type="text"], input[type="datetime-local"], select, textarea, input[type="file"] { width: 100%; padding: 10px 14px; margin-bottom: 20px; border-radius: 8px; border: 1px solid #f7c600; background: #f9f6d8; font-size: 1rem; color: #212121; box-sizing: border-box; }
textarea { resize: vertical; height: 100px; }
button, .btn { background: #212121; color: #ffd600; font-weight: 700; border: none; border-radius: 25px; padding: 10px 20px; font-size: 0.95rem; cursor: pointer; user-select: none; display: inline-block; transition: background 0.25s ease, color 0.25s ease; }
button:hover { background: #000; }
.btn-back { background: transparent; color: #212121; border: 2px solid #212121; border-radius: 25px; padding: 8px 20px; font-weight: 700; cursor: pointer; }
.btn-back:hover { background: #212121; color: #ffd600; }
</style>
</head>
<body>

<main aria-label="Editar Documento">

    <button type="button" class="btn-back" aria-label="Voltar" onclick="window.history.back();">&larr; Voltar</button>

    <h1>Editar Documento #<%= documento.getId() %></h1>

    <form action="<%= request.getContextPath() %>/DocumentoController" method="post" enctype="multipart/form-data" novalidate>
        <input type="hidden" name="action" value="editar" />
        <input type="hidden" name="id" value="<%= documento.getId() %>" />
        <input type="hidden" name="contratoId" value="<%= contratoIdParam %>" />

        <label for="tipo">Tipo</label>
        <select id="tipo" name="tipo" required>
            <% for (Documento.TipoDocumento t : Documento.TipoDocumento.values()) { %>
                <option value="<%= t.name() %>" <%= t == documento.getTipo() ? "selected" : "" %>><%= t.name() %></option>
            <% } %>
        </select>

        <label for="descricao">Descrição</label>
        <textarea id="descricao" name="descricao" required><%= documento.getDescricao() %></textarea>

        <label for="arquivo">Substituir Arquivo (opcional)</label>
        <input type="file" id="arquivo" name="arquivo" />

        <label for="dataDocumento">Data e Hora</label>
        <input type="datetime-local" id="dataDocumento" name="dataDocumento" 
               value="<%= documento.getDataDocumento() != null ? documento.getDataDocumento().format(dtf) : LocalDateTime.now().format(dtf) %>" required />

        <button type="submit">Salvar Alterações</button>
    </form>

</main>

</body>
</html>
