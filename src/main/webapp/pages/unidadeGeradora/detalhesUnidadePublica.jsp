<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*"%>
<%@ page import="br.com.monesol.dao.ContratoDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%
    HttpSession sessaoDetalhesUnidade = request.getSession(false);
    Usuario usuarioDetalhesUnidade = (sessaoDetalhesUnidade != null) ? (Usuario) sessaoDetalhesUnidade.getAttribute("usuarioLogado") : null;
    if (usuarioDetalhesUnidade == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }

    UnidadeGeradora unidade = (UnidadeGeradora) request.getAttribute("unidade");
    if (unidade == null) {
        out.println("<p>Unidade não encontrada.</p>");
        return;
    }
  
    ContratoDAO contratoDAO = new ContratoDAO();

    double capacidadeContratada = 0.0;
    try {
        capacidadeContratada = contratoDAO.calcularCapacidadeContratada(unidade.getId());
    } catch (Exception e) {
        e.printStackTrace();
    }

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Detalhes da Unidade Geradora - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/detalhes.css" />
</head>
<body class="pagina-detalhes-unidade">

    <jsp:include page="/pages/outros/mensagens.jsp" />
    <jsp:include page="/pages/usuario/header.jsp" />

    <main aria-label="Detalhes da unidade geradora">
        <a href="javascript:history.back()" class="btn btn-back" aria-label="Voltar para a página anterior">
            &larr; Voltar ao Marketplace
        </a>

        <h1>Unidade Geradora #<%= unidade.getId() %></h1>
        <div class="sub">Detalhes da unidade e medições recentes</div>

        <div class="card">
            <div class="flex">
                <div class="info">
                    <div class="info-label">Localização</div>
                    <div class="info-value"><%= unidade.getLocalizacao() %></div>

                    <div class="info-label">Potência Instalada (kW)</div>
                    <div class="info-value"><%= String.format("%.2f", unidade.getPotenciaInstalada()) %></div>

                    <div class="info-label">Eficiência Média (%)</div>
                    <div class="info-value"><%= String.format("%.1f", unidade.getEficienciaMedia()) %></div>

                    <div class="info-label">Preço por kWh (R$)</div>
                    <div class="info-value"><%= String.format("%.2f", unidade.getPrecoPorKWh()) %></div>
                    
                    <div class="info-label">Quantidade Máxima Comerciável (%)</div>
                    <div class="info-value"><%=String.format("%.2f", unidade.getQuantidadeMaximaComerciavel())%></div>

                    <div class="info-label">Quantidade Mínima Aceita (kWh)</div>
                    <div class="info-value">
                        <%= unidade.getQuantidadeMinimaAceita() > 0 ? String.format("%.2f", unidade.getQuantidadeMinimaAceita()) : "-" %>
                    </div>
                    <div class="info-label">Regra de Exceções</div>
                    <div class="info-value">
                        <%= (unidade.getRegraDeExcecoes() != null && !unidade.getRegraDeExcecoes().isBlank())
                                ? unidade.getRegraDeExcecoes()
                                : "Não definida" %>
                    </div>
                </div>
                <div class="info">
                    <div class="info-label">Dono da Unidade</div>
                    <div class="info-value"><%=unidade.getCpfCnpjUsuario() != null ?
                            unidade.getCpfCnpjUsuario() : "-"%></div>
                    
                    <div class="progress-container">
                        <div class="progress-label"><strong>Capacidade de Contrato</strong></div>
                        <div class="progress-bar-wrapper">
                            <%
                                double porcentagem = (unidade.getQuantidadeMaximaComerciavel() > 0) ? (capacidadeContratada / unidade.getQuantidadeMaximaComerciavel()) * 100 : 0;
                                String porcentagemFormatada = String.format("%.2f", porcentagem).replace(",", ".");
                            %>
                            <div class="progress-bar-fill" style="width: <%= porcentagemFormatada %>%;"></div>
                            <span class="progress-bar-text">
                                <%= String.format("%.2f", capacidadeContratada) %>/<%= String.format("%.2f", unidade.getQuantidadeMaximaComerciavel()) %> kWh
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card" aria-labelledby="medicoes-title">
            <h2 id="medicoes-title">Medições Recentes</h2>
            <p>Não há medições registradas para esta unidade.</p>
        </div>

        <% if (!unidade.getCpfCnpjUsuario().equals(usuarioDetalhesUnidade.getCpfCnpj())) { %>
        <form
            action="<%= request.getContextPath() %>/pages/contrato/cadastrarContrato.jsp"
            method="get" style="text-align: center; margin-top: 30px;">
            <input type="hidden" name="unidadeGeradoraId"
                value="<%= unidade.getId() %>" />
            <button type="submit" class="btn btn-contract">Firmar
                Contrato</button>
        </form>
        <% } %>
    </main>
</body>
</html>