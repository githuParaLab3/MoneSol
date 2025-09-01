<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Contrato contrato = (Contrato) request.getAttribute("contrato");
    
    if (contrato == null) {
        String contratoIdStr = request.getParameter("id");
        if (contratoIdStr != null && !contratoIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ContratoController?action=formEditar&id=" + contratoIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
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
        
        .btn-voltar {
            display: inline-block;
            background: transparent;
            color: #d49f00;
            border: 2px solid #d49f00;
            border-radius: 30px;
            padding: 10px 22px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
            user-select: none;
            margin-bottom: 20px;
        }
        
        .btn-voltar:hover {
            background-color: #d49f00;
            color: #212121;
            text-decoration: none;
        }
        
        h1 { 
            text-align: center; 
            margin-bottom: 25px; 
            font-weight: 900; 
        }
        
        label { 
            font-weight: 700; 
            margin-bottom: 4px; 
            display: block; 
        }
        
        input[type="text"], input[type="number"], input[type="date"], select, textarea {
            width: 100%;
            padding: 10px;
            border: 1.8px solid #f7c600;
            border-radius: 8px;
            margin-bottom: 15px;
            font-family: inherit;
            background-color: #f9f6d8;
            color: #212121;
            transition: border-color 0.3s ease;
        }
        
        input[type="text"]:focus, input[type="number"]:focus, input[type="date"]:focus, textarea:focus {
            outline: none;
            border-color: #d49f00;
            background-color: #fffde7;
        }
        
        input[disabled] {
            background-color: #e0e0e0;
            color: #666;
            cursor: not-allowed;
        }
        
        textarea { 
            min-height: 70px; 
            resize: vertical; 
        }
        
        button[type="submit"] {
            background: #212121;
            color: #ffd600;
            padding: 12px;
            border: none;
            border-radius: 30px;
            font-weight: 700;
            cursor: pointer;
            width: 100%;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }
        
        button[type="submit"]:hover { 
            background: #000; 
        }
        
        @media (max-width: 480px) {
            .container {
                margin: 20px 15px;
                padding: 25px 20px;
            }
        }
    </style>
</head>
<body>
	<jsp:include page="/pages/outros/mensagens.jsp" />

<div class="container">
    <a href="javascript:history.back()" class="btn-voltar" aria-label="Voltar para a página anterior">
            &larr; Voltar
        </a>

    <h1>Editar Contrato - ID: <%= contrato.getId() %></h1>

    <form action="<%= request.getContextPath() %>/ContratoController" method="post">
        <input type="hidden" name="action" value="editar" />
        <input type="hidden" name="id" value="<%= contrato.getId() %>" />

        <label>Usuário:</label>
        <input type="text" value="<%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "-" %>" disabled />
        <input type="hidden" name="usuarioCpfCnpj" value="<%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "" %>" />

        <label>Unidade Geradora:</label>
        <input type="text" value="<%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getLocalizacao() + " (ID: " + contrato.getUnidadeGeradora().getId() + ")" : "-" %>" disabled />
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

        <button type="submit">Salvar Alterações</button>
    </form>
</div>
</body>
</html>