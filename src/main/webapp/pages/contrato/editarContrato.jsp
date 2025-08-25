<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*" %>
<%@ page import="br.com.monesol.dao.ContratoDAO" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%@ page import="br.com.monesol.model.*" %>
<%@ page import="br.com.monesol.dao.ContratoDAO" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String contratoIdStr = request.getParameter("id");
    if (contratoIdStr == null || contratoIdStr.isEmpty()) {
        out.println("<p>Contrato não encontrado.</p>");
        return;
    }

    int contratoId = Integer.parseInt(contratoIdStr);
    ContratoDAO contratoDAO = new ContratoDAO();
    Contrato contrato = contratoDAO.buscarPorId(contratoId);

    if (contrato == null) {
        out.println("<p>Contrato não encontrado.</p>");
        return;
    }
    

	DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
%>


<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Editar Contrato - MoneSol</title>
    <link rel="stylesheet" href="../../assets/css/monesol.css" />
    <style>
        .container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(247,198,0,0.25);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #212121;
        }
        h1 { text-align:center; margin-bottom: 25px; font-weight:900; }
        label { font-weight:700; margin-bottom:4px; display:block; }
        input[type="text"], input[type="number"], input[type="date"], select, textarea {
            width: 100%;
            padding: 10px;
            border: 1.8px solid #f7c600;
            border-radius:8px;
            margin-bottom:15px;
            font-family:inherit;
        }
        textarea { min-height:70px; resize: vertical; }
        button[type="submit"] {
            background:#212121;
            color:#ffd600;
            padding:12px;
            border:none;
            border-radius:30px;
            font-weight:700;
            cursor:pointer;
            width:100%;
            font-size:1rem;
        }
        button[type="submit"]:hover { background:#000; }
    </style>
</head>
<body>
<div class="container">
	<button type="button" class="btn-voltar" aria-label="Voltar" onclick="window.history.back();">&larr; Voltar</button>

    <h1>Editar Contrato - ID: <%= contrato.getId() %></h1>

    <form action="<%= request.getContextPath() %>/ContratoController" method="post">
        <input type="hidden" name="action" value="editar" />
        <input type="hidden" name="id" value="<%= contrato.getId() %>" />

        <!-- Usuário e Unidade Geradora (hidden para envio) -->
        <label>Usuário:</label>
        <input type="text" value="<%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "-" %>" disabled />
        <input type="hidden" name="usuarioCpfCnpj" value="<%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "" %>" />

        <label>Unidade Geradora:</label>
        <input type="text" value="<%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getLocalizacao() : "-" %>" disabled />
        <input type="hidden" name="unidadeGeradoraId" value="<%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getId() : "" %>" />

        <label for="vigenciaInicio">Vigência Início:</label>
        <input type="date" id="vigenciaInicio" name="vigenciaInicio"
               value="<%= contrato.getVigenciaInicio() != null ? dtf.format(contrato.getVigenciaInicio()) : "" %>" required />

        <label for="vigenciaFim">Vigência Fim:</label>
        <input type="date" id="vigenciaFim" name="vigenciaFim"
               value="<%= contrato.getVigenciaFim() != null ? dtf.format(contrato.getVigenciaFim()) : "" %>" required />

        <label for="reajustePeriodico">Reajuste Periódico (meses):</label>
        <input type="number" id="reajustePeriodico" name="reajustePeriodico"
               value="<%= contrato.getReajustePeriodico() %>" min="1" required />

        <label for="quantidadeContratada">Quantidade Contratada (kWh):</label>
        <input type="number" id="quantidadeContratada" name="quantidadeContratada"
               step="0.01" min="0.01" value="<%= contrato.getQuantidadeContratada() %>" required />

        <label for="regrasExcecoes">Regras e Exceções:</label>
        <textarea id="regrasExcecoes" name="regrasExcecoes" maxlength="500"><%= contrato.getRegrasExcecoes() != null ? contrato.getRegrasExcecoes() : "" %></textarea>

        <label for="observacoes">Observações:</label>
        <textarea id="observacoes" name="observacoes" maxlength="500"><%= contrato.getObservacoes() != null ? contrato.getObservacoes() : "" %></textarea>

        <button type="submit">Salvar Alterações</button>
    </form>
</div>
</body>
</html>
