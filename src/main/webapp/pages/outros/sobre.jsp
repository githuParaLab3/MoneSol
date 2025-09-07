<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>Sobre a MoneSol</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <style>
        * {
            margin: 0; padding: 0; box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #fff8e1;
            color: #212121;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        main {
            max-width: 900px;
            margin: 50px auto 80px;
            padding: 0 20px;
        }
        h1, h2 {
            font-weight: 900;
            color: #212121;
            user-select: none;
        }
        h1 {
            font-size: 2.4rem;
            margin-bottom: 30px;
            text-align: center;
        }
        h2 {
            font-size: 1.8rem;
            margin-top: 40px;
            margin-bottom: 18px;
            border-bottom: 3px solid #f7c600;
            padding-bottom: 6px;
        }
        p {
            color: #424242;
            font-size: 1.15rem;
            line-height: 1.7;
            margin-bottom: 18px;
            max-width: 720px;
            margin-left: auto;
            margin-right: auto;
        }

        ul.valores-list {
            max-width: 720px;
            margin: 0 auto 30px;
            padding-left: 1.25rem;
            color: #555;
            font-weight: 600;
            font-size: 1.1rem;
            line-height: 1.5;
        }
        ul.valores-list li {
            margin-bottom: 10px;
            list-style-type: disc;
        }

        section.faq {
            max-width: 720px;
            margin: 0 auto 60px;
        }
        .faq-item {
            border: 1.5px solid #f7c600;
            border-radius: 12px;
            margin-bottom: 15px;
            box-shadow: 0 4px 12px rgba(247, 198, 0, 0.2);
            background: #fffde7;
        }
        .faq-question {
            padding: 15px 20px;
            cursor: pointer;
            font-weight: 700;
            font-size: 1.15rem;
            color: #212121;
            user-select: none;
            position: relative;
        }
        .faq-question::after {
            content: "+";
            position: absolute;
            right: 20px;
            font-size: 1.5rem;
            transition: transform 0.3s ease;
        }
        .faq-item.open .faq-question::after {
            content: "−";
            transform: rotate(180deg);
        }
        .faq-answer {
            max-height: 0;
            overflow: hidden;
            padding: 0 20px;
            font-weight: 600;
            color: #424242;
            line-height: 1.5;
            font-size: 1rem;
            transition: max-height 0.4s ease, padding 0.4s ease;
        }
        .faq-item.open .faq-answer {
            max-height: 500px;
            padding-top: 12px;
            padding-bottom: 15px;
        }

        @media (max-width: 600px) {
            main {
                margin: 30px 15px 60px;
            }
            h1 {
                font-size: 2rem;
            }
            h2 {
                font-size: 1.5rem;
            }
            p, ul.valores-list {
                font-size: 1.05rem;
            }
            .faq-question {
                font-size: 1.1rem;
            }
            .faq-answer {
                font-size: 0.95rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/pages/usuario/header.jsp" />

    <main role="main" aria-labelledby="sobre-title">
        <h1 id="sobre-title">Sobre a MoneSol</h1>

        <p>
            A MoneSol é uma plataforma inovadora para gestão e comercialização de energia fotovoltaica.
            Nosso objetivo é conectar geradores e consumidores de forma eficiente, transparente e sustentável.
        </p>
        <p>
            Por meio da MoneSol, usuários podem gerenciar unidades geradoras, acompanhar contratos, monitorar
            medições e otimizar o uso da energia solar. Tudo isso com tecnologia de ponta e segurança.
        </p>

        <h2>Nossa Missão e Visão</h2>
        <p><strong>Missão:</strong> Promover o acesso democratizado e sustentável à energia solar, facilitando a
            gestão e comercialização para todos os envolvidos.</p>
        <p><strong>Visão:</strong> Ser referência nacional em soluções integradas para o mercado fotovoltaico, gerando impacto positivo no meio ambiente e na sociedade.</p>

        <h2>Valores</h2>
        <ul class="valores-list" aria-label="Lista de valores da empresa">
            <li>Sustentabilidade ambiental e social</li>
            <li>Transparência e ética nas operações</li>
            <li>Inovação tecnológica constante</li>
            <li>Foco no cliente e usabilidade</li>
            <li>Segurança e confiabilidade dos dados</li>
        </ul>

        <h2>Perguntas Frequentes</h2>
        <section class="faq" aria-label="Perguntas frequentes">

            <article class="faq-item" tabindex="0">
                <header class="faq-question" role="button" aria-expanded="false" aria-controls="faq1-answer" id="faq1-question">
                    O que é a plataforma MoneSol?
                </header>
                <div class="faq-answer" id="faq1-answer" aria-labelledby="faq1-question" hidden>
                    A MoneSol é uma plataforma para gestão e comercialização de energia solar fotovoltaica, conectando
                    donos de unidades geradoras e consumidores de energia de forma segura e eficiente.
                </div>
            </article>

            <article class="faq-item" tabindex="0">
                <header class="faq-question" role="button" aria-expanded="false" aria-controls="faq2-answer" id="faq2-question">
                    Quem pode usar a MoneSol?
                </header>
                <div class="faq-answer" id="faq2-answer" aria-labelledby="faq2-question" hidden>
                    A plataforma atende perfis de Administradores, Consumidores/Parceiros que buscam energia e Donos de
                    Unidades Geradoras que desejam comercializar sua energia.
                </div>
            </article>

            <article class="faq-item" tabindex="0">
                <header class="faq-question" role="button" aria-expanded="false" aria-controls="faq3-answer" id="faq3-question">
                    Como funciona o marketplace de energia?
                </header>
                <div class="faq-answer" id="faq3-answer" aria-labelledby="faq3-question" hidden>
                    O marketplace permite que consumidores visualizem unidades geradoras disponíveis para contratar
                    energia, com condições transparentes e possibilidade de assinatura de contratos diretamente pela plataforma.
                </div>
            </article>

            <article class="faq-item" tabindex="0">
                <header class="faq-question" role="button" aria-expanded="false" aria-controls="faq4-answer" id="faq4-question">
                    Quais medidas de segurança a MoneSol utiliza?
                </header>
                <div class="faq-answer" id="faq4-answer" aria-labelledby="faq4-question" hidden>
                    Utilizamos criptografia, autenticação robusta, e políticas de controle de acesso para proteger os dados e as operações dos usuários.
                </div>
            </article>

        </section>
    </main>
<script src="${pageContext.request.contextPath}/assets/js/sobre.js"></script>
</body>
</html>
