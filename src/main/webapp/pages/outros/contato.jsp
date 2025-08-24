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
<style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
        font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background:#fff8e1;
        color:#212121;
        min-height:100vh;
        display:flex;
        flex-direction:column;
    }
    main {
        max-width:900px;
        margin:50px auto 80px;
        padding:0 20px;
    }
    h1,h2 { font-weight:900; color:#212121; user-select:none; }
    h1 { font-size:2.4rem; margin-bottom:30px; text-align:center; }
    h2 { font-size:1.8rem; margin-top:40px; margin-bottom:18px; border-bottom:3px solid #f7c600; padding-bottom:6px; }
    p { color:#424242; font-size:1.15rem; line-height:1.7; margin-bottom:18px; max-width:720px; margin-left:auto; margin-right:auto; }
    ul.contact-list { max-width:720px; margin:0 auto 30px; padding-left:1.25rem; color:#555; font-weight:600; font-size:1.1rem; line-height:1.5; }
    ul.contact-list li { margin-bottom:10px; list-style-type:disc; }
    .contact-section {
        max-width:720px;
        margin:0 auto;
        padding:30px;
        border:1.5px solid #f7c600;
        border-radius:12px;
        box-shadow:0 4px 15px rgba(247,198,0,0.2);
        background:#fffde7;
    }
    .contact-section a {
        color:#212121;
        text-decoration:none;
        font-weight:700;
    }
    .contact-section a:hover { text-decoration:underline; }
    @media (max-width:600px) {
        main { margin:30px 15px 60px; }
        h1 { font-size:2rem; }
        h2 { font-size:1.5rem; }
        p, ul.contact-list { font-size:1.05rem; }
    }
</style>
</head>
<body>

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
