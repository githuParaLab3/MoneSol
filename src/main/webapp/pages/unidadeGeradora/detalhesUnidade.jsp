<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*"%>
<%@ page import="br.com.monesol.dao.MedicaoDAO"%>
<%@ page import="br.com.monesol.dao.ContratoDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%
    HttpSession sessaoDetalhesUnidade = request.getSession(false);
    Usuario usuarioDetalhesUnidade = (sessaoDetalhesUnidade != null)
            ? (Usuario) sessaoDetalhesUnidade.getAttribute("usuarioLogado")
            : null;
    if (usuarioDetalhesUnidade == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }

    UnidadeGeradora unidade = (UnidadeGeradora) request.getAttribute("unidade");
    if (unidade == null) {
        out.println("<p>Unidade não encontrada.</p>");
        return;
    }

    boolean podeEditar = "ADMIN".equalsIgnoreCase(usuarioDetalhesUnidade.getTipo().name())
            ||
    (unidade.getCpfCnpjUsuario() != null
            && unidade.getCpfCnpjUsuario().equals(usuarioDetalhesUnidade.getCpfCnpj()));

    MedicaoDAO medicaoDAO = new MedicaoDAO();
    ContratoDAO contratoDAO = new ContratoDAO();
    List<Medicao> medições = null;
    try {
        medições = medicaoDAO.listarPorUnidade(unidade.getId());
    } catch (Exception e) {
        e.printStackTrace();
    }

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
        
        <% if (usuarioDetalhesUnidade != null && "ADMIN".equalsIgnoreCase(usuarioDetalhesUnidade.getTipo().name())) { %>
            <a href="<%= request.getContextPath() %>/pages/admin/gerenciarUnidades.jsp" class="btn btn-back" style="margin-bottom: 20px;">&larr; Voltar</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp" class="btn btn-back" style="margin-bottom: 20px;">&larr; Voltar</a>
        <% } %>

        <h1>Unidade Geradora #<%=unidade.getId()%></h1>
        <div class="sub">Detalhes da unidade e medições recentes</div>

        <div class="card">
            <div class="flex">
                <div class="info">
                    <div class="info-label">Localização</div>
                    <div class="info-value"><%=unidade.getLocalizacao()%></div>
                    <div class="info-label">Potência Instalada (kW)</div>
                    <div class="info-value"><%=String.format("%.2f", unidade.getPotenciaInstalada())%></div>
                    <div class="info-label">Eficiência Média (%)</div>
                    <div class="info-value"><%=String.format("%.1f", unidade.getEficienciaMedia())%></div>
                    <div class="info-label">Preço por kWh (R$)</div>
                    <div class="info-value"><%=String.format("%.2f", unidade.getPrecoPorKWh())%></div>
                    <div class="info-label">Quantidade Mínima Aceita (kWh)</div>
                    <div class="info-value"><%=(unidade.getQuantidadeMinimaAceita() > 0) ?
                            String.format("%.2f", unidade.getQuantidadeMinimaAceita())
                            : "Não definido"%></div>
                    <div class="info-label">Regra de Exceções</div>
                    <div class="info-value">
                        <%=(unidade.getRegraDeExcecoes() != null && !unidade.getRegraDeExcecoes().isBlank()) ?
                                unidade.getRegraDeExcecoes()
                                : "Não definida"%></div>
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
                <div class="info">
                    <div class="info-label">Dono da Unidade</div>
                    <div class="info-value"><%=unidade.getCpfCnpjUsuario() != null ?
                            unidade.getCpfCnpjUsuario() : "-"%></div>
                    <div class="info-label">Total de Medições</div>
                    <div class="info-value"><%=(medições != null ? medições.size() : 0)%></div>
                </div>
                <div class="info actions" style="flex: 0 0 200px;">
                    <% if (podeEditar) { %>
                        <form action="<%=request.getContextPath()%>/pages/unidadeGeradora/editarUnidade.jsp" method="get">
                            <input type="hidden" name="id" value="<%=unidade.getId()%>" />
                            <button type="submit" class="btn btn-edit">Editar Unidade</button>
                        </form>
                        <form action="<%=request.getContextPath()%>/UnidadeGeradoraController" method="post" onsubmit="return confirm('Confirma exclusão desta unidade?');">
                            <input type="hidden" name="action" value="deletar" />
                            <input type="hidden" name="id" value="<%=unidade.getId()%>" />
                            <button type="submit" class="btn btn-delete">Excluir</button>
                        </form>
                    <% } %>
                </div>
            </div>
        </div>

        <% if (podeEditar) { %>
            <a href="<%=request.getContextPath()%>/pages/medicao/adicionarMedicao.jsp?unidadeId=<%=unidade.getId()%>" class="btn btn-edit" style="margin-bottom: 20px;">+ Adicionar Medição</a>
        <% } %>

        <div class="card" aria-labelledby="medicoes-title">
            <h2 id="medicoes-title">Medições Recentes</h2>
            <% if (medições == null || medições.isEmpty()) { %>
                <p>Não há medições registradas para esta unidade.</p>
            <% } else {
                double totalGerada = 0, totalConsumidaLocal = 0, totalInjetada = 0;
                for (Medicao m : medições) {
                    totalGerada += m.getEnergiaGerada();
                    totalConsumidaLocal += m.getEnergiaConsumidaLocalmente();
                    totalInjetada += m.getEnergiaInjetadaNaRede();
                }
            %>
            <div class="summary">
                <div class="summary-item">Total Gerado: <strong><%=String.format("%.2f", totalGerada)%> kWh</strong></div>
                <div class="summary-item">Consumido Localmente: <strong><%=String.format("%.2f", totalConsumidaLocal)%> kWh</strong></div>
                <div class="summary-item">Injetado na Rede: <strong><%=String.format("%.2f", totalInjetada)%> kWh</strong></div>
            </div>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Data / Hora</th>
                            <th>Energia Gerada (kWh)</th>
                            <th>Consumida Localmente (kWh)</th>
                            <th>Injetada na Rede (kWh)</th>
                            <% if (podeEditar) { %><th>Ações</th><% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Medicao m : medições) { %>
                        <tr>
                            <td><%=m.getDataMedicao().format(dtf)%></td>
                            <td><%=String.format("%.2f", m.getEnergiaGerada())%></td>
                            <td><%=String.format("%.2f", m.getEnergiaConsumidaLocalmente())%></td>
                            <td><%=String.format("%.2f", m.getEnergiaInjetadaNaRede())%></td>
                            <% if (podeEditar) { %>
                            <td>
                                <a href="<%=request.getContextPath()%>/pages/medicao/editarMedicao.jsp?medicaoId=<%=m.getId()%>" class="btn btn-edit" style="padding: 5px 10px; font-size: 0.85rem;">Editar</a>
                                <form action="<%=request.getContextPath()%>/MedicaoController" method="post" style="display: inline;" onsubmit="return confirm('Deseja realmente deletar esta medição?');">
                                    <input type="hidden" name="action" value="deletar" />
                                    <input type="hidden" name="id" value="<%=m.getId()%>" />
                                    <input type="hidden" name="unidadeGeradoraId" value="<%=unidade.getId()%>" />
                                    <button type="submit" class="btn btn-delete" style="padding: 5px 10px; font-size: 0.85rem;">Deletar</button>
                                </form>
                            </td>
                            <% } %>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </main>
</body>
</html>