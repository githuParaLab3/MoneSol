<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="br.com.monesol.dao.UnidadeGeradoraDAO" %>
<%@ page import="br.com.monesol.model.UnidadeGeradora" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>MoneSol - Marketplace de Unidades Geradoras</title>
    <link rel="stylesheet" href="../../assets/css/monesol.css" />
    <style>
        
        .container {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
        }

        h1 {
            text-align: center;
            color: #212121;
            font-weight: 900;
            font-size: 2.4rem;
            margin-bottom: 30px;
        }

    
        .units-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: grid;
            grid-template-columns: repeat(auto-fill,minmax(280px,1fr));
            gap: 20px;
        }

        .unit-card {
            background: #fff;
            border: 2px solid #ffd600;
            border-radius: 12px;
            padding: 20px 25px;
            box-shadow: 0 6px 15px rgba(255, 214, 0, 0.2);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            color: #212121;
        }

        .unit-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(255, 214, 0, 0.4);
            border-color: #ffeb3b;
        }

        .unit-title {
            font-weight: 700;
            font-size: 1.25rem;
            margin-bottom: 12px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .unit-info {
            font-size: 0.95rem;
            margin-bottom: 8px;
            color: #555;
        }

        .unit-info strong {
            color: #212121;
        }

        .btn-contratar {
            margin-top: auto;
            background-color: #212121;
            color: #ffd600;
            border: none;
            padding: 10px 16px;
            border-radius: 30px;
            font-weight: 700;
            cursor: pointer;
            align-self: flex-start;
            transition: background-color 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }

        .btn-contratar:hover {
            background-color: #000;
            color: #fff700;
        }

        .link-detalhes {
            color: inherit;
            text-decoration: none;
            cursor: pointer;
        }

        .link-detalhes:hover {
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .units-list {
                grid-template-columns: 1fr;
            }
        }

    </style>
</head>
<body>
    <jsp:include page="/pages/usuario/header.jsp" />

    <div class="container">
        <h1>Marketplace - Unidades Geradoras Disponíveis</h1>

        <%
            UnidadeGeradoraDAO unidadeDAO = new UnidadeGeradoraDAO();
            List<UnidadeGeradora> listaUnidades = null;
            try {
                listaUnidades = unidadeDAO.listarTodas();
            } catch (Exception e) {
                out.println("<p style='color:red; text-align:center;'>Erro ao carregar unidades geradoras: " + e.getMessage() + "</p>");
            }
        %>

        <% if (listaUnidades != null && !listaUnidades.isEmpty()) { %>
            <ul class="units-list" role="list">
                <% for (UnidadeGeradora unidade : listaUnidades) { %>
                    <li>
                        <div class="unit-card" role="listitem" aria-label="Unidade geradora localizada em <%= unidade.getLocalizacao() %>">
                            <a href="<%= request.getContextPath() %>/UnidadeGeradoraController?action=detalhesPublicos&id=<%= unidade.getId() %>" class="link-detalhes">
                                <div class="unit-title"><%= unidade.getLocalizacao() %></div>
                                <div class="unit-info"><strong>Potência Instalada:</strong> <%= String.format("%.2f", unidade.getPotenciaInstalada()) %> kW</div>
                                <div class="unit-info"><strong>Eficiência Média:</strong> <%= (unidade.getEficienciaMedia() != 0.0) ? String.format("%.1f", unidade.getEficienciaMedia() * 100) + " %" : "N/A" %></div>
                                <div class="unit-info"><strong>Preço por kWh:</strong> R$ <%= String.format("%.4f", unidade.getPrecoPorKWh()) %></div>
								<div class="unit-info"><strong>Quantidade mínima aceita:</strong> <%= (unidade.getQuantidadeMinimaAceita() > 0) ? String.format("%.2f", unidade.getQuantidadeMinimaAceita()) + " kWh" : "Não definido" %></div>
                            </a>
                            <form action="<%= request.getContextPath() %>/pages/contrato/cadastrarContrato.jsp" method="get" style="margin-top: 12px;">
                                <input type="hidden" name="unidadeGeradoraId" value="<%= unidade.getId() %>" />
                                <button type="submit" class="btn-contratar">Contratar</button>
                            </form>
                        </div>
                    </li>
                <% } %>
            </ul>
        <% } else { %>
            <p style="text-align:center; color:#777;">Nenhuma unidade geradora disponível no momento.</p>
        <% } %>
    </div>
</body>
</html>
