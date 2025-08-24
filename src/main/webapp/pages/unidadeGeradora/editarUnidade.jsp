<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.dao.UnidadeGeradoraDAO" %>
<%@ page import="br.com.monesol.model.UnidadeGeradora" %>
<%
    String idParam = request.getParameter("id");
    UnidadeGeradora unidade = null;
    if (idParam != null) {
        try {
            int id = Integer.parseInt(idParam);
            UnidadeGeradoraDAO dao = new UnidadeGeradoraDAO();
            unidade = dao.buscarPorId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    if (unidade == null) {
        out.println("<p>Unidade não encontrada.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Editar Unidade Geradora - MoneSol</title>
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
        input[type="number"] {
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
        input[type="number"]::-webkit-inner-spin-button,
        input[type="number"]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }
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


main h1 {
    margin-top: 60px; 
}

        .btn-back:hover {
            background: #212121;
            color: #ffd600;
        }
    </style>
</head>
<body>

<main aria-label="Editar Unidade Geradora">

    <a href="<%= request.getContextPath() %>/UnidadeGeradoraController?action=buscarPorId&id=<%= unidade.getId() %>" class="btn-back" aria-label="Voltar para detalhes da unidade">
        &larr; Voltar
    </a>

    <h1>Editar Unidade Geradora #<%= unidade.getId() %></h1>

    <form action="<%= request.getContextPath() %>/UnidadeGeradoraController" method="post" novalidate>
        <input type="hidden" name="action" value="editar" />
        <input type="hidden" name="id" value="<%= unidade.getId() %>" />
        

        <label for="localizacao">Localização</label>
        <input type="text" id="localizacao" name="localizacao" value="<%= unidade.getLocalizacao() %>" required />

        <label for="potenciaInstalada">Potência Instalada (kW)</label>
        <input type="number" id="potenciaInstalada" name="potenciaInstalada" step="0.01" min="0" value="<%= unidade.getPotenciaInstalada() %>" required />

        <label for="eficienciaMedia">Eficiência Média (%)</label>
        <input type="number" id="eficienciaMedia" name="eficienciaMedia" step="0.01" min="0" max="100" value="<%= unidade.getEficienciaMedia() * 100 %>" required />

        <label for="precoPorKWh">Preço por kWh (R$)</label>
        <input type="number" id="precoPorKWh" name="precoPorKWh" step="0.01" min="0" value="<%= unidade.getPrecoPorKWh() %>" required />

        <label for="quantidadeMinimaAceita">Quantidade Mínima Aceita (kWh)</label>
        <input type="number" id="quantidadeMinimaAceita" name="quantidadeMinimaAceita" step="0.01" min="0" value="<%= unidade.getQuantidadeMinimaAceita() %>" />

        <button type="submit">Salvar Alterações</button>
    </form>

</main>

</body>
</html>
