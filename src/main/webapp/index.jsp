<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="br.com.monesol.model.Usuario" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>MoneSol - Soluções em Energia Solar Sustentável</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/index.css" />
</head>
<body>

<jsp:include page="/pages/usuario/header.jsp" />

<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
%>

<main>

<jsp:include page="/pages/outros/mensagens.jsp" />

<% if (usuarioLogado != null) {
    String tipo = usuarioLogado.getTipo().toString();
    String heroTitle = "";
    String heroParagraph = "";
    String heroButtonText = "";
    String heroButtonLink = "";

    if ("DONO_GERADORA".equals(tipo)) {
        heroTitle = "Olá, " + usuarioLogado.getNome() + "!";
        heroParagraph = "Acompanhe o desempenho de suas unidades geradoras e gerencie seus contratos de forma eficiente.";
        heroButtonText = "Ver Resumo das Unidades";
        heroButtonLink = "pages/usuario/dashboard.jsp";
    } else if ("CONSUMIDOR_PARCEIRO".equals(tipo)) {
        heroTitle = "Bem-vindo(a), " + usuarioLogado.getNome() + "!";
        heroParagraph = "Encontre a melhor solução para sua necessidade de energia solar e gerencie seus contratos de forma simples e transparente.";
        heroButtonText = "Explorar o Marketplace";
        heroButtonLink = "pages/unidadeGeradora/listaUnidadesDisponiveis.jsp";
    } else if ("ADMIN".equals(tipo)) {
        heroTitle = "Painel Administrativo, " + usuarioLogado.getNome() + "!";
        heroParagraph = "Acesse o painel completo para gerenciar todos os usuários, unidades geradoras e contratos do sistema.";
        heroButtonText = "Acessar Painel de Controle";
        heroButtonLink = "pages/admin/dashboardAdmin.jsp";
    }
%>

    <section class="hero" role="banner" aria-label="Área do usuário logado">
        <div class="hero-text">
            <h2><%= heroTitle %></h2>
            <p><%= heroParagraph %></p>
            <button class="btn-hero" onclick="window.location.href='<%= heroButtonLink %>'">
                <%= heroButtonText %>
            </button>
        </div>
        <div class="hero-image">
            <img src="assets/images/paineisSolares.webp" alt="Painéis solares instalados em telhado" />
        </div>
    </section>

    <section class="about" aria-labelledby="about-title">
        <h3 id="about-title">Sobre a MoneSol</h3>
        <p>
            A MoneSol é líder em soluções tecnológicas para gestão e comercialização de energia gerada por sistemas fotovoltaicos.
            Nossa plataforma conecta consumidores, parceiros e geradores, promovendo eficiência, transparência e sustentabilidade no mercado de energia solar.
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
            “A MoneSol transformou a forma como gerencio a energia da 
            minha unidade geradora. Fácil, transparente e eficiente.”
            <div class="testimonial-author">– João Silva, Proprietário Parceiro</div>
        </div>
        <div class="testimonial-item">
            “Com a MoneSol, conseguimos contratos flexíveis que atendem às nossas necessidades de consumo e sustentabilidade.”
            <div class="testimonial-author">– Maria Oliveira, Consumidora </div>
        </div>
    </section>

    <section class="final-cta" aria-label="Chamada final para ações do usuário">
        <h3>Pronto para gerenciar sua energia solar com a MoneSol?</h3>
        <button onclick="window.location.href='<%= heroButtonLink %>'">
            <%= heroButtonText %>
        </button>
    </section>

<% } else { %>

    <section class="hero" role="banner" aria-label="Imagem e slogan do sistema MoneSol">
        <div class="hero-text">
            <h2>Energia Solar Sustentável para um 
            Futuro Melhor</h2>
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
            A MoneSol é líder em soluções tecnológicas para gestão e comercialização de energia gerada por sistemas fotovoltaicos.
            Nossa plataforma conecta consumidores, parceiros e geradores, promovendo eficiência, transparência e sustentabilidade no mercado de energia solar.
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
            “A MoneSol transformou a forma como gerencio a energia da 
            minha unidade geradora. Fácil, transparente e eficiente.”
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