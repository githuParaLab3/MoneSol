<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.Usuario" %>
<%
    HttpSession sessaoCadastrarUnidade = request.getSession(false);
    Usuario usuarioLogadoCadastrarUnidade = (sessaoCadastrarUnidade != null) ? (Usuario) sessaoCadastrarUnidade.getAttribute("usuarioLogado") : null;
    if (usuarioLogadoCadastrarUnidade == null) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Cadastrar Unidade Geradora - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff8e1;
            color: #212121;
            min-height: 100vh;
        }
        .wrapper {
            max-width: 640px;
            margin: 50px auto;
            padding: 0 15px;
        }
        h2 {
            color: #212121;
            font-weight: 900;
            margin-bottom: 20px;
            text-align: center;
            font-size: 2.2rem;
        }
        .card {
            background: #fff;
            border: 2px solid #ffd600;
            border-radius: 12px;
            padding: 30px 25px;
            box-shadow: 0 8px 25px rgba(255,214,0,0.25);
        }
        label {
            display: block;
            font-weight: 700;
            margin-top: 15px;
            margin-bottom: 6px;
            font-size: 0.95rem;
        }
        input[type="text"],
        input[type="number"] {
            width: 100%;
            padding: 12px 14px;
            border-radius: 8px;
            border: 1.8px solid #e0d000;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.25s ease, box-shadow 0.25s ease;
        }
        input:focus {
            border-color: #212121;
            box-shadow: 0 0 8px rgba(33,33,33,0.2);
        }
        .btn-submit {
            margin-top: 30px;
            width: 100%;
            background: linear-gradient(90deg,#212121,#424242);
            color: #ffd600;
            font-weight: 700;
            padding: 14px;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            cursor: pointer;
            transition: filter 0.2s ease;
        }
        .btn-submit:hover {
            filter: brightness(1.1);
        }
        .btn-voltar {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: transparent;
            color: #212121;
            border: 2px solid #212121;
            border-radius: 30px;
            font-weight: 700;
            cursor: pointer;
            transition: background 0.25s ease, color 0.25s ease;
            text-decoration: none;
            user-select: none;
        }
        .btn-voltar:hover {
            background: #212121;
            color: #ffd600;
            text-decoration: none;
        }
        .note {
            font-size: 0.85rem;
            color: #555;
            margin-top: 5px;
        }
    </style>
</head>
<body>

<%@ include file="../usuario/header.jsp" %>

<div class="wrapper" aria-label="Formulário de cadastro de unidade geradora">
    <button class="btn-voltar" onclick="window.history.back()">← Voltar</button>

    <div class="card">
        <h2>Cadastrar Unidade Geradora</h2>
        <form action="<%= request.getContextPath() %>/UnidadeGeradoraController" method="post" aria-label="Formulário de nova unidade">
            <input type="hidden" name="action" value="adicionar" />

            <label for="localizacao">Localização</label>
            <input type="text" id="localizacao" name="localizacao" required placeholder="Ex: Fazenda Solar, São Paulo" />

            <label for="potenciaInstalada">Potência Instalada (kW)</label>
            <input type="number" step="0.01" id="potenciaInstalada" name="potenciaInstalada" required placeholder="Ex: 12.50" />

            <label for="eficienciaMedia">Eficiência Média (%)</label>
            <input type="number" step="0.01" id="eficienciaMedia" name="eficienciaMedia" required placeholder="Ex: 85.5" />
            <div class="note">Informe em porcentagem; será convertido automaticamente.</div>

            <label for="precoPorKWh">Preço por kWh (R$)</label>
            <input type="number" step="0.01" id="precoPorKWh" name="precoPorKWh" required placeholder="Ex: 0.50" />

            <label for="quantidadeMinimaAceita">Quantidade Mínima Aceita (kWh)</label>
            <input type="number" step="0.01" id="quantidadeMinimaAceita" name="quantidadeMinimaAceita" placeholder="Ex: 100.00" />
            <div class="note">Opcional; deixe em branco se não houver mínimo.</div>

            <button type="submit" class="btn-submit">Cadastrar Unidade</button>
        </form>
    </div>
</div>

</body>
</html>
