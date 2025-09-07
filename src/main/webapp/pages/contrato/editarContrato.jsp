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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />
</head>
<body>
    <jsp:include page="/pages/outros/mensagens.jsp" />

    <main>
        <h1>
            <a href="javascript:history.back()" class="btn-back">
                &#8592; Voltar
            </a>
            Editar Contrato - ID: <%= contrato.getId() %>
        </h1>

        <form action="<%= request.getContextPath() %>/ContratoController" method="post">
            <input type="hidden" name="action" value="editar" />
            <input type="hidden" name="id" value="<%= contrato.getId() %>" />

            <label>Usuário</label>
            <input type="text" value="<%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "-" %>" disabled />
            <input type="hidden" name="usuarioCpfCnpj" value="<%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "" %>" />

            <label>Unidade Geradora</label>
            <input type="text" value="<%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getLocalizacao() + " (ID: " + contrato.getUnidadeGeradora().getId() + ")" : "-" %>" disabled />
            <input type="hidden" name="unidadeGeradoraId" value="<%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getId() : "" %>" />

            <label for="vigenciaInicio">Vigência Início</label>
            <input type="date" id="vigenciaInicio" name="vigenciaInicio"
                   value="<%= contrato.getVigenciaInicio() != null ? dtf.format(contrato.getVigenciaInicio()) : "" %>" required />

            <label for="vigenciaFim">Vigência Fim</label>
            <input type="date" id="vigenciaFim" name="vigenciaFim"
                   value="<%= contrato.getVigenciaFim() != null ? dtf.format(contrato.getVigenciaFim()) : "" %>" required />

            <label for="reajustePeriodico">Reajuste Periódico (meses)</label>
            <input type="number" id="reajustePeriodico" name="reajustePeriodico"
                   value="<%= contrato.getReajustePeriodico() %>" min="1" required />

            <label for="quantidadeContratada">Quantidade Contratada (kWh)</label>
            <input type="number" id="quantidadeContratada" name="quantidadeContratada"
                   step="0.01" min="0.01" value="<%= contrato.getQuantidadeContratada() %>" required />

            <button type="submit">Salvar Alterações</button>
        </form>
    </main>
</body>
</html>
