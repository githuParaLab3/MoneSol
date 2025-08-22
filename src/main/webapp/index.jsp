<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="br.com.monesol.model.Usuario" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>MoneSol - Soluções em Energia Solar Sustentável</title>
<style>
    
    * {
        margin: 0; padding: 0; box-sizing: border-box;
    }
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #fff8e1; 
        color: #333;
        min-height: 100vh;
        margin: 0;
        padding: 0;
    }

    
    header {
        background: #FFD600; 
        padding: 15px 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        box-shadow: 0 3px 6px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 1000;
    }
    header h1 {
        font-weight: 900;
        font-size: 2.4rem;
        color: #212121; 
        user-select: none;
        cursor: default;
        letter-spacing: 2px;
    }
    nav {
        display: flex;
        gap: 24px;
    }
    nav a {
        color: #212121;
        text-decoration: none;
        font-weight: 600;
        font-size: 1.05rem;
        padding: 6px 12px;
        border-radius: 8px;
        transition: background-color 0.3s ease;
        user-select: none;
    }
    nav a:hover, nav a:focus {
        background: #ffea00; 
        outline: none;
    }

    .auth-buttons {
        display: flex;
        gap: 10px;
    }
    .btn {
        padding: 8px 20px;
        font-weight: 700;
        border-radius: 30px;
        cursor: pointer;
        border: none;
        transition: background-color 0.3s ease;
        user-select: none;
        font-size: 1rem;
    }
    .btn-login {
        background: transparent;
        border: 2px solid #212121;
        color: #212121;
    }
    .btn-login:hover {
        background: #212121;
        color: #ffd600;
    }
    .btn-register {
        background: #212121;
        color: #ffd600;
    }
    .btn-register:hover {
        background: #000;
        color: #fff700;
    }

   
    .hero {
        background: linear-gradient(90deg, #ffd600ee, #fff8e1ee);
        display: flex;
        align-items: center;
        justify-content: space-around;
        padding: 80px 40px;
        gap: 40px;
        flex-wrap: wrap;
    }
    .hero-text {
        max-width: 550px;
    }
    .hero-text h2 {
        font-size: 3rem;
        color: #212121;
        font-weight: 900;
        margin-bottom: 20px;
    }
    .hero-text p {
        font-size: 1.2rem;
        line-height: 1.5;
        margin-bottom: 30px;
        color: #424242;
    }
    .btn-hero {
        background: #212121;
        color: #ffd600;
        font-weight: 700;
        padding: 15px 40px;
        border-radius: 50px;
        font-size: 1.2rem;
        cursor: pointer;
        border: none;
        box-shadow: 0 5px 15px rgba(33,33,33,0.4);
        transition: background-color 0.3s ease;
        user-select: none;
    }
    .btn-hero:hover {
        background: #000;
    }
    .hero-image {
        max-width: 450px;
        flex-shrink: 0;
    }
    .hero-image img {
        width: 100%;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(255, 214, 0, 0.3);
    }

    
    .about {
        max-width: 900px;
        margin: 60px auto 40px;
        padding: 0 20px;
        text-align: center;
    }
    .about h3 {
        font-size: 2.2rem;
        font-weight: 900;
        color: #ffd600;
        margin-bottom: 15px;
    }
    .about p {
        font-size: 1.15rem;
        line-height: 1.6;
        color: #424242;
        max-width: 700px;
        margin: 0 auto;
    }

  
    .features {
        background: #fffde7; 
        border-radius: 15px;
        padding: 40px 30px;
        max-width: 1000px;
        margin: 0 auto 60px;
        box-shadow: 0 8px 25px rgba(255, 214, 0, 0.3);
    }
    .features h3 {
        color: #212121;
        font-weight: 900;
        font-size: 2rem;
        margin-bottom: 35px;
        text-align: center;
    }
    .features-list {
        display: grid;
        grid-template-columns: repeat(auto-fit,minmax(280px,1fr));
        gap: 25px;
        list-style: none;
        padding: 0;
    }
    .feature-item {
        background: #fff8e1;
        border: 2px solid #ffd600;
        border-radius: 15px;
        padding: 25px 20px;
        font-weight: 700;
        font-size: 1.05rem;
        color: #212121;
        box-shadow: 0 3px 12px rgba(255, 214, 0, 0.3);
        text-align: center;
        transition: background-color 0.3s ease, box-shadow 0.3s ease;
        cursor: default;
        user-select: none;
    }
    .feature-item:hover {
        background: #ffea00;
        box-shadow: 0 5px 20px #ffd600cc;
    }


    .testimonials {
        max-width: 800px;
        margin: 0 auto 60px;
        padding: 0 20px;
        text-align: center;
    }
    .testimonials h3 {
        font-size: 2rem;
        font-weight: 900;
        color: #ffd600;
        margin-bottom: 35px;
    }
    .testimonial-item {
        font-style: italic;
        font-size: 1.1rem;
        color: #424242;
        margin-bottom: 18px;
        position: relative;
    }
    .testimonial-item::before {
        content: "“";
        font-size: 3rem;
        color: #ffd600;
        position: absolute;
        left: -25px;
        top: -10px;
    }
    .testimonial-author {
        font-weight: 700;
        color: #212121;
        margin-top: 5px;
    }

  
    .final-cta {
        background: #ffd600;
        padding: 45px 20px;
        text-align: center;
        border-radius: 15px;
        box-shadow: 0 10px 30px rgba(255, 214, 0, 0.5);
        margin-bottom: 40px;
    }
    .final-cta h3 {
        font-size: 2.4rem;
        font-weight: 900;
        color: #212121;
        margin-bottom: 25px;
    }
    .final-cta button {
        background: #212121;
        color: #ffd600;
        font-weight: 700;
        padding: 15px 50px;
        border-radius: 50px;
        font-size: 1.3rem;
        cursor: pointer;
        border: none;
        box-shadow: 0 6px 15px rgba(33,33,33,0.5);
        transition: background-color 0.3s ease;
        user-select: none;
    }
    .final-cta button:hover {
        background: #000;
    }

    footer {
        background: #212121;
        color: #ffd600;
        text-align: center;
        padding: 20px;
        font-size: 0.95rem;
        user-select: none;
    }

    @media(max-width: 900px) {
        .hero {
            padding: 60px 20px;
            flex-direction: column;
            text-align: center;
        }
        .hero-image {
            max-width: 90%;
            margin: 30px auto 0;
        }
    }

    @media(max-width: 500px) {
        header h1 {
            font-size: 1.8rem;
        }
        nav a {
            font-size: 0.9rem;
        }
        .hero-text h2 {
            font-size: 2rem;
        }
        .features-list {
            grid-template-columns: 1fr;
        }
        .final-cta h3 {
            font-size: 1.8rem;
        }
        .final-cta button {
            width: 100%;
            font-size: 1.1rem;
        }
    }
</style>
</head>
<body>

<jsp:include page="/pages/usuario/header.jsp" />

<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
%>

<main>

<% if (usuarioLogado != null) { %>

    <section class="hero" role="banner" aria-label="Área do usuário logado">
        <div class="hero-text">
            <h2>Bem-vindo, <%= usuarioLogado.getNome() %>!</h2>
            <p>Acesse seu dashboard para acompanhar seus contratos, medições e unidades geradoras.</p>
            <button class="btn-hero" onclick="window.location.href='pages/usuario/dashboard.jsp'">Ir para Dashboard</button>
        </div>
        <div class="hero-image">
            <img src="assets/images/paineisSolares.webp" alt="Painéis solares instalados em telhado" />
        </div>
    </section>

    <section class="about" aria-labelledby="about-title">
        <h3 id="about-title">Sobre a MoneSol</h3>
        <p>
            A MoneSol é líder em soluções tecnológicas para gestão e comercialização de energia gerada por sistemas fotovoltaicos. Nossa plataforma conecta consumidores, parceiros e geradores, promovendo eficiência, transparência e sustentabilidade no mercado de energia solar.
        </p>
    </section>

    <section class="features" aria-labelledby="features-title">
        <h3 id="features-title">Funcionalidades</h3>
        <ul class="features-list">
            <li class="feature-item">Cadastro e monitoramento de unidades geradoras com dados técnicos detalhados</li>
            <li class="feature-item">Registro automático de medições de geração, consumo e injeção na rede</li>
            <li class="feature-item">Gestão de contratos flexíveis com regras personalizadas e alocação automática</li>
            <li class="feature-item">Upload e controle de documentos técnicos e relatórios</li>
            <li class="feature-item">Histórico completo para auditorias e gestão operacional eficiente</li>
        </ul>
    </section>

    <section class="testimonials" aria-label="Depoimentos de clientes e parceiros">
        <h3>O que nossos clientes dizem</h3>
        <div class="testimonial-item">
            “A MoneSol transformou a forma como gerencio a energia da minha unidade geradora. Fácil, transparente e eficiente.”
            <div class="testimonial-author">– João Silva, Proprietário Parceiro</div>
        </div>
        <div class="testimonial-item">
            “Com a MoneSol, conseguimos contratos flexíveis que atendem às nossas necessidades de consumo e sustentabilidade.”
            <div class="testimonial-author">– Maria Oliveira, Consumidora </div>
        </div>
    </section>

    <section class="final-cta" aria-label="Chamada final para ações do usuário">
        <h3>Pronto para gerenciar sua energia solar com a MoneSol?</h3>
        <button onclick="window.location.href='pages/usuario/dashboard.jsp'">Acessar Dashboard</button>
    </section>

<% } else { %>

    <section class="hero" role="banner" aria-label="Imagem e slogan do sistema MoneSol">
        <div class="hero-text">
            <h2>Energia Solar Sustentável para um Futuro Melhor</h2>
            <p>Transforme a forma como você gerencia e comercializa energia solar. Com a MoneSol, tenha controle total, contratos flexíveis e alocação automática da energia.</p>
            <button class="btn-hero" onclick="window.location.href='pages/usuario/cadastro.jsp'">Comece Agora</button>
        </div>
        <div class="hero-image">
            <img src="assets/images/paineisSolares.webp" alt="Painéis solares instalados em telhado" />
        </div>
    </section>

    <section class="about" aria-labelledby="about-title">
        <h3 id="about-title">Sobre a MoneSol</h3>
        <p>
            A MoneSol é líder em soluções tecnológicas para gestão e comercialização de energia gerada por sistemas fotovoltaicos. Nossa plataforma conecta consumidores, parceiros e geradores, promovendo eficiência, transparência e sustentabilidade no mercado de energia solar.
        </p>
    </section>

    <section class="features" aria-labelledby="features-title">
        <h3 id="features-title">Funcionalidades</h3>
        <ul class="features-list">
            <li class="feature-item">Cadastro e monitoramento de unidades geradoras com dados técnicos detalhados</li>
            <li class="feature-item">Registro automático de medições de geração, consumo e injeção na rede</li>
            <li class="feature-item">Gestão de contratos flexíveis com regras personalizadas e alocação automática</li>
            <li class="feature-item">Upload e controle de documentos técnicos e relatórios</li>
            <li class="feature-item">Histórico completo para auditorias e gestão operacional eficiente</li>
        </ul>
    </section>

    <section class="testimonials" aria-label="Depoimentos de clientes e parceiros">
        <h3>O que nossos clientes dizem</h3>
        <div class="testimonial-item">
            “A MoneSol transformou a forma como gerencio a energia da minha unidade geradora. Fácil, transparente e eficiente.”
            <div class="testimonial-author">– João Silva, Proprietário Parceiro</div>
        </div>
        <div class="testimonial-item">
            “Com a MoneSol, conseguimos contratos flexíveis que atendem às nossas necessidades de consumo e sustentabilidade.”
            <div class="testimonial-author">– Maria Oliveira, Consumidora </div>
        </div>
    </section>

    <section class="final-cta" aria-label="Chamada final para cadastro ou login">
        <h3>Pronto para revolucionar sua gestão de energia solar?</h3>
        <button onclick="window.location.href='pages/usuario/cadastro.jsp'">Cadastre-se Agora</button>
    </section>

<% } %>

</main>

<footer>
    &copy; 2025 MoneSol — Energia limpa, inovação e sustentabilidade para um futuro melhor.
</footer>

</body>
</html>
