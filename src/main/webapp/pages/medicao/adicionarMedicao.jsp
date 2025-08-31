<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String unidadeId = request.getParameter("unidadeId");
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <title>Adicionar Medição - MoneSol</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #fff8e1; color: #2e2e2e; }
        main { max-width: 500px; margin: 40px auto; background: #fff; border: 1px solid #f7c600; border-radius: 12px; box-shadow: 0 8px 20px rgba(247, 198, 0, 0.25); padding: 30px; }
        h1 { font-size: 1.8rem; font-weight: 800; text-align: center; margin-bottom: 20px; }
        label { font-weight: 600; display: block; margin-top: 10px; margin-bottom: 5px; }
        input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 8px; margin-bottom: 15px; }
        .btn { width: 100%; padding: 12px; border: none; border-radius: 30px; background: #212121; color: #ffd600; font-weight: 700; cursor: pointer; transition: background 0.3s; }
        .btn:hover { background: #000; }
        .btn-back {
            display: inline-block;
            padding: 10px 22px;
            border: 2px solid #212121;
            border-radius: 30px;
            background: transparent;
            color: #212121;
            font-weight: 700;
            text-decoration: none;
            margin-bottom: 20px;
            transition: background 0.3s, color 0.3s;
        }
        .btn-back:hover {
            background: #212121;
            color: #ffd600;
        }
    </style>
</head>
<body>
<jsp:include page="/pages/outros/mensagens.jsp" />
<main>
    <a href="javascript:history.back();" class="btn-back" aria-label="Voltar para a página anterior">&larr; Voltar</a>

    <h1>Adicionar Medição</h1>
    <form action="<%= request.getContextPath() %>/MedicaoController" method="post">
        <input type="hidden" name="action" value="adicionar"/>
        <input type="hidden" name="unidadeGeradoraId" value="<%= unidadeId %>"/>

        <label for="dataMedicao">Data e Hora da Medição:</label>
        <input type="datetime-local" id="dataMedicao" name="dataMedicao" value="<%=java.time.LocalDateTime.now().withSecond(0).withNano(0).toString()%>" required/>

        <label for="energiaGerada">Energia Gerada (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaGerada" name="energiaGerada" required/>

        <label for="energiaConsumidaLocalmente">Energia Consumida Localmente (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaConsumidaLocalmente" name="energiaConsumidaLocalmente" required/>

        <label for="energiaInjetadaNaRede">Energia Injetada na Rede (kWh):</label>
        <input type="number" step="0.01" min="0" id="energiaInjetadaNaRede" name="energiaInjetadaNaRede" required/>

        <button type="submit" class="btn">Salvar Medição</button>
    </form>
</main>
</body>
</html>
