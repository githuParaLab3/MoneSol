<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="br.com.monesol.model.Usuario" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession sessao = request.getSession(false);
    Usuario usuarioLogado = (sessao != null) ? (Usuario) sessao.getAttribute("usuarioLogado") : null;
%>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Contato - MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/outros.css" />
</head>
<body class="pagina-contato">

<jsp:include page="/pages/usuario/header.jsp" />

<main role="main" aria-labelledby="contato-title">
    <h1 id="contato-title">Fale Conosco</h1>

    <div class="contact-section">
        <p><strong>Geral:</strong> Para dúvidas de usuários, faturamento ou suporte, entre em contato pelo e-mail abaixo. Antes de enviar, consulte nossas <a href="<%= request.getContextPath() %>/pages/outros/sobre.jsp">perguntas frequentes</a> sobre contratos e faturamento.</p>

        <p><strong>Negócios:</strong> Para consultas comerciais, mídia ou profissionais, envie e-mail para: <a href="mailto:contato@monesol.com.br">contato@monesol.com.br</a></p>

        <p><strong>Contratações:</strong> Para trabalhar conosco, envie seu interesse através do e-mail: <a href="mailto:trabalheconosco@monesol.com.br">trabalheconosco@monesol.com.br</a>. Entraremos em contato quando houver posições disponíveis.</p>

        <ul class="contact-list">
            <li>Email: <a href="mailto:contato@monesol.com.br">contato@monesol.com.br</a></li>
            <li>Telefone: (11) 99999-9999</li>
            <li>Endereço: Rua da Energia, 123 - São Paulo, SP</li>
        </ul>
    </div>
</main>

</body>
</html>