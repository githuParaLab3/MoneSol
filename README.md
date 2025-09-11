# MoneSol - Plataforma de Gestão de Energia Solar

Aplicação web em Java para gestão e comercialização de energia solar fotovoltaica. Conecta donos de unidades geradoras a consumidores e parceiros, centralizando contratos, medições e documentos.

## Funcionalidades Principais

### Administração

* CRUD de usuários.
* Gestão de unidades geradoras.
* Gestão de contratos.

### Donos de Geradoras

* Dashboard pessoal.
* Cadastro e edição de unidades geradoras.
* Visualização de contratos vinculados.
* Registro de medições (gerada, consumida, injetada).

### Consumidores Parceiros

* Marketplace de energia (visualização e filtro de unidades disponíveis).
* Contratação direta de energia.
* Dashboard pessoal (contratos ativos e consumo).

### Funcionalidades Comuns

* Detalhes de contratos (vigência, quantidade contratada, cláusulas).
* Upload de documentos (relatórios, manutenção).
* Histórico de contratos (alterações e ocorrências).

## Arquitetura e Tecnologias

* **Arquitetura**: MVC + DAO
* **Back-end**: Java, Servlets, JSP, JDBC, MySQL
* **Front-end**: HTML5, CSS3, JavaScript
* **Servidor**: Apache Tomcat

## Requisitos

* JDK 17+
* Apache Tomcat 9+
* MySQL Server configurado

## Configuração do Banco de Dados

```sql
CREATE DATABASE monesol;
USE monesol;

CREATE TABLE Usuario (
    cpfCnpj VARCHAR(14) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    contato VARCHAR(20),
    endereco VARCHAR(255),
    tipo VARCHAR(50) NOT NULL
);

CREATE TABLE UnidadeGeradora (
    id INT AUTO_INCREMENT PRIMARY KEY,
    localizacao VARCHAR(255),
    potenciaInstalada DOUBLE,
    eficienciaMedia DOUBLE,
    usuario VARCHAR(14),
    precoPorKWh DOUBLE,
    quantidadeMinimaAceita DOUBLE,
    regraDeExcecoes TEXT,
    quantidadeMaximaComerciavel DOUBLE,
    FOREIGN KEY (usuario) REFERENCES Usuario(cpfCnpj)
);

CREATE TABLE Contrato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vigenciaInicio DATE,
    vigenciaFim DATE,
    reajustePeriodico INT,
    quantidadeContratada DOUBLE,
    unidadeGeradora INT,
    usuario VARCHAR(14),
    FOREIGN KEY (unidadeGeradora) REFERENCES UnidadeGeradora(id),
    FOREIGN KEY (usuario) REFERENCES Usuario(cpfCnpj)
);

CREATE TABLE Medicao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dataMedicao DATETIME,
    energiaGerada DOUBLE,
    energiaConsumidaLocalmente DOUBLE,
    energiaInjetadaNaRede DOUBLE,
    unidadeGeradora INT,
    FOREIGN KEY (unidadeGeradora) REFERENCES UnidadeGeradora(id)
);

CREATE TABLE Documento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50),
    descricao VARCHAR(255),
    dataDocumento DATETIME,
    arquivo VARCHAR(255),
    contrato INT,
    FOREIGN KEY (contrato) REFERENCES Contrato(id)
);

CREATE TABLE HistoricoContrato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dataHistorico DATETIME,
    titulo VARCHAR(255),
    descricao TEXT,
    tipo VARCHAR(50),
    contrato INT,
    FOREIGN KEY (contrato) REFERENCES Contrato(id)
);
```

Atualizar credenciais em `src/main/java/br/com/monesol/util/Conexao.java`.

## Implantação e Execução

1. Clonar repositório.
2. Importar em IDE (Eclipse, IntelliJ).
3. Configurar Tomcat.
4. Fazer deploy do projeto.
5. Acessar via navegador: `http://localhost:8080/MoneSol`.

## Estrutura do Projeto

```
src/main/java/br/com/monesol/
├── controller/   # Servlets
├── dao/          # DAOs
├── model/        # Entidades
└── util/         # Utilitários (ex: conexão DB)

src/main/webapp/
├── assets/       # CSS, JS, imagens
├── pages/        # JSPs (views)
└── index.jsp     # Página inicial
```
