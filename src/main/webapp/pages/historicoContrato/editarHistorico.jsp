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
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff8e1;
            color: #2e2e2e;
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }
        main {
            max-width: 600px;
            margin: 40px auto;
            background: #fff;
            border: 1.5px solid #f7c600;
            border-radius: 12px;
            padding: 30px 25px;
            box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25);
            position: relative;
        }
        h1 {
            font-size: 2rem;
            font-weight: 900;
            color: #212121;
            margin-bottom: 25px;
            text-align: center;
        }
        label {
            display: block;
            font-weight: 700;
            margin-bottom: 8px;
            color: #555;
        }
        input[type="text"],
        input[type="datetime-local"],
        select,
        textarea {
            width: 100%;
            padding: 10px 14px;
            margin-bottom: 20px;
            border-radius: 8px;
            border: 1px solid #f7c600;
            background: #f9f6d8;
            font-size: 1rem;
            color: #212121;
            box-sizing: border-box;
        }
        textarea { resize: vertical; height: 100px; }
        button {
            background: #212121;
            color: #ffd600;
            font-weight: 700;
            border: none;
            border-radius: 30px;
            padding: 12px 28px;
            font-size: 1rem;
            cursor: pointer;
            user-select: none;
            width: 100%;
            transition: background 0.25s ease;
        }
        button:hover {
            background: #000;
        }
        .btn-back {
            position: absolute;
            top: 20px;
            left: 25px;
            text-decoration: none;
            color: #212121;
            border: 2px solid #212121;
            border-radius: 30px;
            padding: 10px 26px;
            font-weight: 700;
            transition: background 0.25s ease, color 0.25s ease;
            user-select: none;
            z-index: 10; 
        }
        .btn-back:hover {
            background: #212121;
            color: #ffd600;
        }
    </style>
</head>
<body>

<main aria-label="Editar Histórico de Ocorrência">

	<button type="button" class="btn-voltar" aria-label="Voltar" onclick="window.history.back();">&larr; Voltar</button>

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
