<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.Contrato" %>
<%
    String contratoIdStr = request.getParameter("contratoId");
    if (contratoIdStr == null || contratoIdStr.isEmpty()) {
        out.println("<script>alert('Contrato não informado!'); window.history.back();</script>");
        return;
    }
    int contratoId = Integer.parseInt(contratoIdStr);
    Contrato contrato = new Contrato();
    contrato.setId(contratoId);
%>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Nova Ocorrência - Contrato</title>
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
        label {
            display: block;
            font-weight: 700;
            margin-top: 15px;
            margin-bottom: 6px;
            font-size: 0.95rem;
        }
        input[type="text"],
        input[type="datetime-local"],
        select,
        textarea {
            width: 100%;
            padding: 12px 14px;
            border-radius: 8px;
            border: 1.8px solid #e0d000;
            font-size: 1rem;
            font-family: inherit;
            outline: none;
            transition: border-color 0.25s ease, box-shadow 0.25s ease;
            resize: vertical;
        }
        input:focus,
        select:focus,
        textarea:focus {
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
            margin-bottom: 30px;
        }
        .btn:hover {
            background: #212121;
            color: #ffd600;
            border-color: #ffd600;
            text-decoration: none;
        }
        .btn-voltar {
            display: inline-block;
            margin-bottom: 25px;
            font-weight: 700;
            color: #212121;
            border: 2px solid #212121;
            padding: 8px 20px;
            border-radius: 30px;
            text-decoration: none;
            transition: background 0.25s ease;
            cursor: pointer;
            background: transparent;
        }
        .btn-voltar:hover {
            background: #212121;
            color: #ffd600;
            border-color: #ffd600;
            text-decoration: none;
        }
    </style>
</head>
<body>

<div class="wrapper" aria-label="Formulário de nova ocorrência do contrato">
 <button type="button" class="btn-voltar" aria-label="Voltar para a página anterior" onclick="window.history.back();">&larr; Voltar</button>
 
    <div class="card">
        <h2>Nova Ocorrência - Contrato #<%= contrato.getId() %></h2>

        <form action="<%= request.getContextPath() %>/HistoricoContratoController" method="post" aria-label="Formulário de nova ocorrência">
            <input type="hidden" name="action" value="adicionar" />
            <input type="hidden" name="contratoId" value="<%= contrato.getId() %>" />

            <label for="dataHistorico">Data e Hora:</label>
            <%
                java.time.LocalDateTime now = java.time.LocalDateTime.now().withSecond(0).withNano(0);
                String nowStr = now.toString();
            %>
            <input type="datetime-local" id="dataHistorico" name="dataHistorico" value="<%= nowStr %>" required />

            <label for="titulo">Título da ocorrência:</label>
            <input type="text" id="titulo" name="titulo" required />

            <label for="descricao">Descrição da ocorrência:</label>
            <textarea id="descricao" name="descricao" rows="4" required></textarea>

            <label for="tipo">Tipo de ocorrência:</label>
            <select id="tipo" name="tipo" required>
                <option value="">-- Selecione --</option>
                <option value="ALOCACAO">Alocação</option>
                <option value="MANUTENCAO">Manutenção</option>
                <option value="RELATORIO">Relatório</option>
                <option value="ALTERACAO_CONTRATUAL">Alteração Contratual</option>
                <option value="OUTRO">Outro</option>
            </select>

            <button type="submit" class="btn-submit">Salvar Ocorrência</button>
        </form>
    </div>
</div>

</body>
</html>
