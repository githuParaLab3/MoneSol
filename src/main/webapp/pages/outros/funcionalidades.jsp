<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8" />
    <title>O que oferecemos - MoneSol</title>
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
            max-width: 1000px;
            margin: 50px auto 80px;
            padding: 0 20px;
        }
        h1 {
            font-weight: 900;
            font-size: 2.6rem;
            margin-bottom: 40px;
            color: #212121;
            text-align: center;
            user-select: none;
        }
        h2 {
            font-size: 1.8rem;
            color: #f7c600;
            margin-top: 30px;
            margin-bottom: 15px;
            border-bottom: 3px solid #f7c600;
            padding-bottom: 6px;
            user-select: none;
        }
        p {
            color: #424242;
            font-weight: 600;
            line-height: 1.6;
            margin-bottom: 20px;
            user-select: text;
        }
        ul {
            list-style: disc inside;
            margin-left: 20px;
            color: #424242;
            font-weight: 600;
            line-height: 1.6;
            margin-bottom: 30px;
            max-width: 900px;
        }
        ul li {
            margin-bottom: 10px;
        }
        .beneficios {
            background: #fffde7;
            border: 2px solid #f7c600;
            border-radius: 14px;
            padding: 25px 30px;
            box-shadow: 0 6px 22px rgba(247, 198, 0, 0.28);
            margin-bottom: 40px;
        }
        /* Responsividade */
        @media (max-width: 700px) {
            main {
                margin: 30px 15px 60px;
            }
            h1 {
                font-size: 2.2rem;
            }
            h2 {
                font-size: 1.5rem;
            }
            p, ul {
                font-size: 1.05rem;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/pages/usuario/header.jsp" />

    <main role="main" aria-labelledby="oferecemos-title">
        <h1 id="oferecemos-title">O que oferecemos na MoneSol</h1>

        <p>
            A MoneSol é uma plataforma completa para gestão e comercialização de energia solar, pensada para atender desde donos de unidades geradoras até consumidores finais.
            Com ferramentas modernas, oferecemos transparência, agilidade e controle total em todas as etapas do processo.
        </p>

        <h2>Gestão Inteligente de Usuários</h2>
        <p>
            Gerencie múltiplos perfis com diferentes permissões: administradores, donos de unidades geradoras e consumidores/parceiros.
            Controle o acesso e a interação de forma simples e segura, garantindo que cada usuário tenha a experiência adequada ao seu papel.
        </p>

        <h2>Controle Completo das Unidades Geradoras</h2>
        <p>
            Cadastre suas unidades geradoras com detalhes técnicos e localização precisa.
            Acompanhe em tempo real a geração de energia, o status operacional e dados históricos para otimizar a performance.
        </p>

        <h2>Marketplace Dinâmico e Transparente</h2>
        <p>
            Oferecemos um marketplace para compra e venda de energia solar entre usuários, com contratos claros e condições competitivas.
            Escolha as melhores opções de energia para seu perfil e acompanhe todas as negociações diretamente na plataforma.
        </p>

        <h2>Gerenciamento e Histórico de Contratos</h2>
        <p>
            Controle rigoroso dos contratos de fornecimento de energia, incluindo vigência, reajustes periódicos e cláusulas específicas.
            Visualize o histórico completo para facilitar auditorias e garantir a conformidade legal.
        </p>

        <h2>Acompanhamento e Monitoramento</h2>
        <p>
            Acompanhe medições de geração e consumo com dashboards intuitivos, gráficos interativos e alertas personalizados.
            Tome decisões informadas para melhorar o uso da energia e reduzir custos.
        </p>

        <h2>Relatórios e Auditorias</h2>
        <p>
            Gere relatórios detalhados para análise técnica, financeira e regulatória.
            Facilite auditorias internas e externas com dados confiáveis e organizados.
        </p>

        <div class="beneficios" role="region" aria-label="Benefícios da plataforma MoneSol">
            <h2>Benefícios para você</h2>
            <ul>
                <li>Redução de custos e otimização do consumo energético.</li>
                <li>Transparência total nas negociações e contratos.</li>
                <li>Segurança e controle de acesso por perfil de usuário.</li>
                <li>Acesso fácil e prático via desktop ou dispositivos móveis.</li>
                <li>Suporte dedicado e consultoria para maximizar resultados.</li>
                <li>Contribuição ativa para a sustentabilidade e uso consciente da energia solar.</li>
            </ul>
        </div>

    </main>
</body>
</html>
