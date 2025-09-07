<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="br.com.monesol.model.UnidadeGeradora"%>
<%@ page import="br.com.monesol.model.Usuario"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<%
    HttpSession sessionCadastrarContrato = request.getSession(false);
    Usuario usuarioLogado = (sessionCadastrarContrato != null) ? (Usuario) sessionCadastrarContrato.getAttribute("usuarioLogado") : null;
    if (usuarioLogado == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String cpfCnpj = usuarioLogado.getCpfCnpj();
    if (cpfCnpj == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    UnidadeGeradora unidade = (UnidadeGeradora) request.getAttribute("unidade");
    LocalDate dataInicio = (LocalDate) request.getAttribute("dataInicio");
    LocalDate dataFim = (LocalDate) request.getAttribute("dataFim");

    if (unidade == null) {
        String unidadeIdStr = request.getParameter("unidadeGeradoraId");
        if (unidadeIdStr != null && !unidadeIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ContratoController?action=formCadastrar&unidadeGeradoraId=" + unidadeIdStr);
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
        return;
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    double capacidadeContratada = (Double) request.getAttribute("capacidadeContratada");
    double capacidadeDisponivel = unidade.getQuantidadeMaximaComerciavel() - capacidadeContratada;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Fechar Contrato - MoneSol</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />

<div style="max-width: 800px; margin: 30px auto 10px; padding: 0 20px;">
    <a href="<%=request.getContextPath()%>/pages/unidadeGeradora/listaUnidadesDisponiveis.jsp"
       class="btn-back">← Desistir da Contratação</a>
</div>

<main>
    <h1>Fechar Contrato - Unidade: <%= unidade.getLocalizacao() %> (ID: <%= unidade.getId() %>)</h1>

    <form action="<%=request.getContextPath()%>/ContratoController" method="post">
        <input type="hidden" name="action" value="adicionar" />
        <input type="hidden" name="unidadeGeradoraId" value="<%= unidade.getId() %>" />
        <input type="hidden" name="usuarioCpfCnpj" value="<%= cpfCnpj %>" />

        <label for="vigenciaInicio">Vigência Início:</label>
        <input type="date" id="vigenciaInicio" name="vigenciaInicio" value="<%= formatter.format(dataInicio) %>" required />

        <label for="vigenciaFim">Vigência Fim:</label>
        <input type="date" id="vigenciaFim" name="vigenciaFim" value="<%= formatter.format(dataFim) %>" required />

        <label for="reajustePeriodico">Reajuste Periódico (meses):</label>
        <input type="number" id="reajustePeriodico" name="reajustePeriodico" min="1" value="12" required />

        <label for="quantidadeContratada">
            Quantidade Contratada (kWh) — Mínimo: <%= String.format("%.2f", unidade.getQuantidadeMinimaAceita()) %> kWh
        </label>
        <input type="number" id="quantidadeContratada" name="quantidadeContratada"
               step="0.01" min="<%= unidade.getQuantidadeMinimaAceita() %>" max="<%= capacidadeDisponivel %>" required />

        <div class="progress-container">
            <span class="progress-label">Disponibilidade de Capacidade</span>
            <div class="progress-bar-wrapper">
                <%
                    double porcentagem = (unidade.getQuantidadeMaximaComerciavel() > 0)
                        ? (capacidadeContratada / unidade.getQuantidadeMaximaComerciavel()) * 100 : 0;
                    String porcentagemFormatada = String.format("%.2f", porcentagem).replace(",", ".");
                %>
                <div class="progress-bar-fill" style="width: <%= porcentagemFormatada %>%"></div>
                <span class="progress-bar-text">
                    <%= String.format("%.2f", capacidadeContratada) %>/<%= String.format("%.2f", unidade.getQuantidadeMaximaComerciavel()) %> kWh
                </span>
            </div>
            <small style="color: #555; font-size: 0.9rem;">
                Disponível: <%= String.format("%.2f", capacidadeDisponivel) %> kWh
            </small>
        </div>

        <button type="submit">Fechar Contrato</button>
    </form>
</main>
</body>
</html>
ss