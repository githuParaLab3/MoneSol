<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.*"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.util.List"%>
<%
    Contrato contrato = (Contrato) request.getAttribute("contrato");
    List<Documento> listaDocumentos = (List<Documento>) request.getAttribute("listaDocumentos");
    List<HistoricoContrato> listaHistoricos = (List<HistoricoContrato>) request.getAttribute("listaHistoricos");
    
    if (contrato == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        return;
    }
    
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dtfHora = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    Usuario usuario = null;
    HttpSession sessao = request.getSession(false);
    if (sessao != null) {
        usuario = (Usuario) sessao.getAttribute("usuarioLogado");
    }
    
    if (usuario == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
    
    boolean podeGerenciar = "ADMIN".equalsIgnoreCase(usuario.getTipo().name())
        || (contrato.getUnidadeGeradora().getCpfCnpjUsuario() != null 
        && contrato.getUnidadeGeradora().getCpfCnpjUsuario().equals(usuario.getCpfCnpj()));
        
    boolean isAdmin = "ADMIN".equalsIgnoreCase(usuario.getTipo().name());
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Detalhes do Contrato - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/detalhes.css" />
</head>
<body class="pagina-detalhes-contrato">
    <jsp:include page="/pages/outros/mensagens.jsp" />
    <jsp:include page="/pages/usuario/header.jsp" />

    <main aria-label="Detalhes do contrato">
        
        <% if (usuario != null && "ADMIN".equalsIgnoreCase(usuario.getTipo().name())) { %>
            <a href="<%= request.getContextPath() %>/pages/admin/gerenciarContratos.jsp" class="btn">&larr; Voltar</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp" class="btn">&larr; Voltar</a>
        <% } %>
        
        <h1>Detalhes do Contrato</h1>
        
        <% if (isAdmin) { %>
            <div style="margin-bottom:20px; display:flex; gap:10px; flex-wrap:wrap;">
                <form action="<%= request.getContextPath() %>/ContratoController" method="post" onsubmit="return confirm('Deseja realmente cancelar este contrato? Esta ação não pode ser desfeita.');">
                    <input type="hidden" name="action" value="deletar" />
                    <input type="hidden" name="id" value="<%= contrato.getId() %>" />
                    <button type="submit" class="btn btn-delete">Cancelar Contrato</button>
                </form>
                <a href="<%= request.getContextPath() %>/ContratoController?action=formEditar&id=<%= contrato.getId() %>" class="btn">Editar Contrato</a>
            </div>
        <% } %>

        <div class="card">
            <div class="info"><span class="info-label">ID do Contrato:</span><span class="info-value"><%= contrato.getId() %></span></div>
            <div class="info"><span class="info-label">Vigência:</span><span class="info-value"><%= contrato.getVigenciaInicio() != null ? dtf.format(contrato.getVigenciaInicio()) : "-" %> até <%= contrato.getVigenciaFim() != null ? dtf.format(contrato.getVigenciaFim()) : "-" %></span></div>
            <div class="info"><span class="info-label">Reajuste a cada:</span><span class="info-value"><%= contrato.getReajustePeriodico() %> meses</span></div>
            <div class="info"><span class="info-label">Quantidade contratada:</span><span class="info-value"><%= contrato.getQuantidadeContratada() + " kWh" %></span></div>
            <div class="info"><span class="info-label">CPF/CNPJ Usuário:</span><span class="info-value"><%= contrato.getUsuario() != null ? contrato.getUsuario().getCpfCnpj() : "-" %></span></div>
            <div class="info"><span class="info-label">ID Unidade Geradora:</span><span class="info-value"><%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getId() : "-" %></span></div>
            <div class="info"><span class="info-label">Localização Unidade:</span><span class="info-value"><%= contrato.getUnidadeGeradora() != null ? contrato.getUnidadeGeradora().getLocalizacao() : "-" %></span></div>
        </div>

        <h2>Documentos Associados</h2>
        <% if (podeGerenciar) { %>
        <form action="<%= request.getContextPath() %>/pages/documento/cadastrarDocumento.jsp" method="get" style="margin-bottom: 15px;">
            <input type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
            <button type="submit" class="btn">+ Novo Documento</button>
        </form>
        <% } %>
        <div class="card">
            <% if (listaDocumentos != null && !listaDocumentos.isEmpty()) { %>
            <table class="documentos">
                <thead>
                    <tr>
                        <th>ID</th><th>Tipo</th><th>Descrição</th><th>Data</th><th>Arquivo</th>
                        <% if (podeGerenciar) { %><th>Ações</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Documento doc : listaDocumentos) { %>
                    <tr>
                        <td><%= doc.getId() %></td>
                        <td><%= doc.getTipo().name() %></td>
                        <td><%= doc.getDescricao() %></td>
                        <td><%= dtfHora.format(doc.getDataDocumento()) %></td>
                        <td>
                            <% if (doc.getArquivo() != null && !doc.getArquivo().isEmpty()) { %>
                                <a href="<%= request.getContextPath() + "/" + doc.getArquivo() %>" target="_blank" class="btn">Abrir</a>
                            <% } else { %> - <% } %>
                        </td>
                        <% if (podeGerenciar) { %>
                        <td>
                            <form action="<%= request.getContextPath() %>/pages/documento/editarDocumento.jsp" method="get" style="margin: 0; display: inline;">
                                <input type="hidden" name="id" value="<%= doc.getId() %>" />
                                <input type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
                                <button type="submit" class="btn">Editar</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/DocumentoController" method="post" style="margin: 0; display: inline;">
                                <input type="hidden" name="action" value="deletar" />
                                <input type="hidden" name="id" value="<%= doc.getId() %>" />
                                <button type="submit" class="btn" onclick="return confirm('Deseja realmente deletar este documento?');">Deletar</button>
                            </form> 
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %><p>Não há documentos associados a este contrato.</p><% } %>
        </div>

        <h2>Histórico de Ocorrências</h2>
        <% if (podeGerenciar) { %>
        <form action="<%= request.getContextPath() %>/pages/historicoContrato/cadastrarHistorico.jsp" method="get" style="margin-bottom: 15px;">
            <input type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
            <button type="submit" class="btn">+ Nova Ocorrência</button>
        </form>
        <% } %>
        <div class="card">
            <% if (listaHistoricos != null && !listaHistoricos.isEmpty()) { %>
            <table class="documentos">
                <thead>
                    <tr>
                        <th>ID</th><th>Data</th><th>Título</th><th>Tipo</th><th>Descrição</th>
                        <% if (podeGerenciar) { %><th>Ações</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (HistoricoContrato hist : listaHistoricos) { %>
                    <tr>
                        <td><%= hist.getId() %></td>
                        <td><%= dtfHora.format(hist.getDataHistorico()) %></td>
                        <td><%= hist.getTitulo() %></td>
                        <td><%= hist.getTipo().name() %></td>
                        <td><%= hist.getDescricao() %></td>
                        <% if (podeGerenciar) { %>
                        <td>
                            <form action="<%= request.getContextPath() %>/pages/historicoContrato/editarHistorico.jsp" method="get" style="margin: 0; display: inline;">
                                <input type="hidden" name="id" value="<%= hist.getId() %>" />
                                <input type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
                                <button type="submit" class="btn">Editar</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/HistoricoContratoController" method="post" style="margin: 0; display: inline;">
                                <input type="hidden" name="action" value="deletar" />
                                <input type="hidden" name="id" value="<%= hist.getId() %>" />
                                <input type="hidden" name="contratoId" value="<%= contrato.getId() %>" />
                                <button type="submit" class="btn" onclick="return confirm('Deseja realmente deletar esta ocorrência?');">Deletar</button>
                            </form>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %><p>Não há ocorrências registradas para este contrato.</p><% } %>
        </div>
    </main>
</body>
</html>