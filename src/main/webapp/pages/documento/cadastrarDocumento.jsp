<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="br.com.monesol.model.Documento.TipoDocumento"%>

<%
    String contratoId = request.getParameter("contratoId");
    if (contratoId == null || contratoId.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        return;
    }

    java.time.LocalDateTime agora = java.time.LocalDateTime.now();
    String dataHoraFormatada = agora.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Cadastrar Documento - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/forms.css" />
</head>
<body>
    <jsp:include page="/pages/outros/mensagens.jsp" />

    <main aria-label="Cadastrar novo documento">
        <a href="javascript:history.back()" class="btn-back" aria-label="Voltar para a página anterior">
            &#8592; Voltar
        </a>

        <h1>Cadastrar Documento</h1>

        <form action="<%= request.getContextPath() %>/DocumentoController"
              method="post" enctype="multipart/form-data">

            <input type="hidden" name="action" value="adicionar" />
            <input type="hidden" name="contratoId" value="<%= contratoId %>" />

            <label for="tipo">Tipo de Documento</label>
            <select id="tipo" name="tipo" required>
                <option value="" disabled selected>Selecione o tipo</option>
                <option value="MANUTENCAO">Manutenção</option>
                <option value="RELATORIO">Relatório</option>
            </select>

            <label for="descricao">Descrição</label>
            <input type="text" id="descricao" name="descricao" maxlength="255" required />

            <label for="dataDocumento">Data e Hora do Documento</label>
            <input type="datetime-local" id="dataDocumento" name="dataDocumento"
                   required value="<%= dataHoraFormatada %>" />

            <label for="arquivo">Selecione o arquivo</label>
            <input type="file" id="arquivo" name="arquivo" required />

            <button type="submit">Salvar Documento</button>
        </form>
    </main>
</body>
</html>
