<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>

<%
    Contrato contrato = (Contrato) request.getAttribute("contrato");
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dtfHora = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    List<Documento> listaDocumentos = (List<Documento>) request.getAttribute("listaDocumentos");
    List<HistoricoContrato> listaHistoricos = (List<HistoricoContrato>) request.getAttribute("listaHistoricos");

    Usuario usuario = null;
    HttpSession sessao = request.getSession(false);
    if (sessao != null) {
        usuario = (Usuario) sessao.getAttribute("usuarioLogado");
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Detalhes do Contrato - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff8e1;
            color: #2e2e2e;
            min-height: 100vh;
        }
        main {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px 60px;
        }
        h1, h2, h3 { color: #212121; }
        h1 { font-size: 2.4rem; font-weight: 900; margin-bottom: 15px; text-align: center; }
        h2 {
            font-size: 1.8rem;
            margin-bottom: 20px;
            border-bottom: 2px solid #f7c600;
            padding-bottom: 8px;
        }
        h3 { font-size: 1.4rem; margin-top: 30px; margin-bottom: 12px; color: #555; }

        .card {
            background: #ffffff;
            border-radius: 12px;
            border: 1.5px solid #f7c600;
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: 0 8px 25px rgba(247, 198, 0, 0.25);
        }

        .info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
            gap: 12px;
            flex-wrap: wrap;
        }
        .info-label {
            font-weight: 700;
            color: #555;
            flex: 0 0 180px;
            min-width: 120px;
        }
        .info-value {
            background: #f9f6d8;
            padding: 10px 14px;
            border-radius: 8px;
            font-size: 1rem;
            color: #2e2e2e;
            flex: 1 1 auto;
            word-wrap: break-word;
        }

        @media (max-width: 520px) {
            .info { flex-direction: column; align-items: flex-start; }
            .info-label { flex: none; width: 100%; margin-bottom: 6px; }
            .info-value { width: 100%; }
        }

        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 30px;
            font-weight: 700;
            cursor: pointer;
            user-select: none;
            font-size: 0.95rem;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: background 0.25s ease;
            text-decoration: none;
            color: #212121;
            border: 2px solid #212121;
            background: transparent;
            margin-top: 10px;
            margin-bottom: 30px;
        }
        .btn:hover {
            background: #212121;
            color: #ffd600;
            border-color: #ffd600;
            text-decoration: none;
        }

        table.documentos {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        table.documentos th, table.documentos td {
            border: 1px solid #f7c600;
            padding: 10px 12px;
            text-align: left;
        }
        table.documentos th {
            background: #f7c600;
            color: #212121;
            font-weight: 700;
        }
        table.documentos tr:nth-child(even) { background: #fff9d1; }

        a.arquivo-link {
            color: #212121;
            text-decoration: none;
            font-weight: 700;
        }
        a.arquivo-link:hover {
            text-decoration: underline;
            color: #f7c600;
        }

        body.pagina-detalhes-contrato header,
        body.pagina-detalhes-contrato #header,
        body.pagina-detalhes-contrato .header {
            padding-top: 8px !important;
            padding-bottom: 8px !important;
            margin-bottom: 20px !important;
            height: auto !important;
            line-height: normal !important;
        }
    </style>
</head>
<body class="pagina-detalhes-contrato">

<jsp:include page="/pages/usuario/header.jsp" />

<main aria-label="Detalhes do contrato">
    <a href="<%= request.getContextPath() %>/pages/usuario/dashboard.jsp" class="btn">&larr; Voltar</a>

    <h1>Detalhes do Contrato</h1>

    <div class="card">
        <div class="info"><span class="info-label">ID do Contrato:</span><span class="info-value"><%= contrato.getId() %></span></div>
        <div class="info"><span class="info-label">Vigência:</span><span class="info-value"><%= dtf.format(contrato.getVigenciaInicio()) %> até <%= dtf.format(contrato.getVigenciaFim()) %></span></div>
        <div class="info"><span class="info-label">Reajuste a cada:</span><span class="info-value"><%= contrato.getReajustePeriodicoMeses() %> meses</span></div>
        <div class="info"><span class="info-label">Limite mínimo de energia:</span><span class="info-value"><%= contrato.getLimiteMinimoEnergiaKWh() %> kWh</span></div>
        <div class="info"><span class="info-label">Preço por kWh:</span><span class="info-value">R$ <%= String.format("%.2f", contrato.getPrecoPorKWh()) %></span></div>
        <div class="info"><span class="info-label">Quantidade contratada:</span><span class="info-value"><%= contrato.getQtdContratada() %> kWh</span></div>
        <div class="info"><span class="info-label">Modelo comercial:</span><span class="info-value"><%= contrato.getModeloComercial() %></span></div>
        <div class="info"><span class="info-label">Regra de alocação:</span><span class="info-value"><%= contrato.getRegraAlocacao() %></span></div>
        <div class="info"><span class="info-label">Observações:</span><span class="info-value"><%= contrato.getObservacoes() != null ? contrato.getObservacoes() : "-" %></span></div>
        <div class="info"><span class="info-label">CPF/CNPJ Usuário:</span><span class="info-value"><%= contrato.getUsuario().getCpfCnpj() %></span></div>
        <div class="info"><span class="info-label">ID Unidade Geradora:</span><span class="info-value"><%= contrato.getUnidadeGeradora().getId() %></span></div>
        <div class="info"><span class="info-label">Localização Unidade:</span><span class="info-value"><%= contrato.getUnidadeGeradora().getLocalizacao() %></span></div>
    </div>

    <!-- Documentos -->
    <h2>Documentos Associados</h2>

    <% if (usuario != null && usuario.getTipo() == br.com.monesol.model.Usuario.TipoUsuario.DONO_GERADORA) { %>
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
                            <a href="<%= request.getContextPath() + "/uploads/documentos/" + doc.getArquivo() %>" target="_blank" class="arquivo-link">Ver arquivo</a>
                        <% } else { %> - <% } %>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>Não há documentos associados a este contrato.</p>
        <% } %>
    </div>

    <!-- Histórico de Ocorrências -->
    <h2>Histórico de Ocorrências</h2>

    <% if (usuario != null && usuario.getTipo() == br.com.monesol.model.Usuario.TipoUsuario.DONO_GERADORA) { %>
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
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } else { %>
        <p>Não há ocorrências registradas para este contrato.</p>
        <% } %>
    </div>

</main>
</body>
</html>
