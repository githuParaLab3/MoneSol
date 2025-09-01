package br.com.monesol.controller;

import br.com.monesol.dao.ContratoDAO;
import br.com.monesol.dao.UnidadeGeradoraDAO;
import br.com.monesol.dao.UsuarioDAO;
import br.com.monesol.dao.DocumentoDAO;
import br.com.monesol.dao.HistoricoContratoDAO;
import br.com.monesol.model.Contrato;
import br.com.monesol.model.Documento;
import br.com.monesol.model.HistoricoContrato;
import br.com.monesol.model.HistoricoContrato.TipoHistorico;
import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.model.Usuario;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/ContratoController")
public class ContratoController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ContratoDAO contratoDAO;
    private UnidadeGeradoraDAO unidadeDAO;
    private UsuarioDAO usuarioDAO;
    private DocumentoDAO documentoDAO;
    private HistoricoContratoDAO historicoContratoDAO;

    @Override
    public void init() throws ServletException {
        try {
            contratoDAO = new ContratoDAO();
            unidadeDAO = new UnidadeGeradoraDAO();
            usuarioDAO = new UsuarioDAO();
            documentoDAO = new DocumentoDAO();
            historicoContratoDAO = new HistoricoContratoDAO();
        } catch (Exception e) {
            throw new ServletException("Erro ao inicializar DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            String action = request.getParameter("action");
            
            if (action == null) {
                action = "buscar";
            }
            
            switch (action) {
                case "buscar":
                    String idStr = request.getParameter("id");
                    if (idStr != null && !idStr.isEmpty()) {
                        buscarPorId(request, response);
                    } else {
                        String cpfCnpj = request.getParameter("usuarioCpfCnpj");
                        String idUnidadeStr = request.getParameter("unidadeGeradoraId");

                        if (cpfCnpj != null && !cpfCnpj.isEmpty()) {
                            listarPorUsuario(request, response, cpfCnpj);
                        } else if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                            int idUnidade = Integer.parseInt(idUnidadeStr);
                            listarPorUnidade(request, response, idUnidade);
                        } else {
                            request.getSession().setAttribute("mensagemInfo", 
                                "Nenhum parâmetro de busca fornecido.");
                            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                        }
                    }
                    break;
                case "formCadastrar":
                    mostrarFormCadastro(request, response);
                    break;
                case "formEditar":
                    mostrarFormEdicao(request, response);
                    break;
                default:
                    request.getSession().setAttribute("mensagemInfo", 
                        "Ação não reconhecida, redirecionando para dashboard.");
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    break;
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "Parâmetro inválido fornecido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "adicionar":
                    adicionarContrato(request, response);
                    break;
                case "adminAdicionar":
                    adminAdicionarContrato(request, response);
                    break;
                case "editar":
                    editarContrato(request, response);
                    break;
                case "deletar":
                    deletarContrato(request, response);
                    break;
                case "listarPorDono":
                    String cpfDono = request.getParameter("usuarioCpfCnpj");
                    listarPorDono(request, response, cpfDono);
                    break;
                case "buscarPorId":
                    buscarPorId(request, response);
                    break;
                case "listarPorUsuario":
                    String cpfCnpj = request.getParameter("usuarioCpfCnpj");
                    if (cpfCnpj != null && !cpfCnpj.isEmpty()) {
                        listarPorUsuario(request, response, cpfCnpj);
                    } else {
                        request.getSession().setAttribute("mensagemErro", 
                            "CPF/CNPJ não informado para busca.");
                        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    }
                    break;
                case "listarPorUnidade":
                    String idUnidadeStr = request.getParameter("unidadeGeradoraId");
                    if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                        int idUnidade = Integer.parseInt(idUnidadeStr);
                        listarPorUnidade(request, response, idUnidade);
                    } else {
                        request.getSession().setAttribute("mensagemErro", 
                            "ID da unidade não informado para busca.");
                        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    }
                    break;
                default:
                    request.getSession().setAttribute("mensagemInfo", 
                        "Ação não reconhecida, redirecionando para dashboard.");
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    break;
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "Dados numéricos inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void mostrarFormCadastro(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            String unidadeIdStr = request.getParameter("unidadeGeradoraId");
            if (unidadeIdStr == null || unidadeIdStr.isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "ID da unidade geradora não informado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            int unidadeId = Integer.parseInt(unidadeIdStr);
            UnidadeGeradora unidade = unidadeDAO.buscarPorId(unidadeId);
            
            if (unidade == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Unidade geradora não encontrada (ID: " + unidadeId + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            LocalDate hoje = LocalDate.now();
            LocalDate dataFim = hoje.plusMonths(12);
            
            request.setAttribute("unidade", unidade);
            request.setAttribute("dataInicio", hoje);
            request.setAttribute("dataFim", dataFim);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/contrato/cadastrarContrato.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID da unidade geradora inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao carregar formulário de cadastro: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void mostrarFormEdicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            String contratoIdStr = request.getParameter("id");
            if (contratoIdStr == null || contratoIdStr.isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "ID do contrato não informado para edição.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            int contratoId = Integer.parseInt(contratoIdStr);
            Contrato contrato = contratoDAO.buscarPorId(contratoId);

            if (contrato == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Contrato não encontrado (ID: " + contratoId + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            request.setAttribute("contrato", contrato);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/contrato/editarContrato.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID do contrato inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao carregar formulário de edição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void adicionarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            LocalDate vigenciaInicio = LocalDate.parse(request.getParameter("vigenciaInicio"), DateTimeFormatter.ISO_DATE);
            LocalDate vigenciaFim = LocalDate.parse(request.getParameter("vigenciaFim"), DateTimeFormatter.ISO_DATE);
            int reajustePeriodico = Integer.parseInt(request.getParameter("reajustePeriodico"));
            double qtdContratada = Double.parseDouble(request.getParameter("quantidadeContratada").replace(",","."));

            int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));
            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);

            String cpfCnpjUsuario = request.getParameter("usuarioCpfCnpj");
            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpjUsuario);

            if (unidade == null || usuario == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Dados inválidos: unidade ou usuário não encontrado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            if (contratoDAO.existeContratoUsuarioUnidade(cpfCnpjUsuario, idUnidade)) {
                request.getSession().setAttribute("mensagemErro", 
                    "Você já possui um contrato para esta unidade geradora.");
                response.sendRedirect(request.getContextPath() + "/pages/unidadeGeradora/listaUnidadesDisponiveis.jsp");
                return;
            }

            if (vigenciaFim.isBefore(vigenciaInicio)) {
                request.getSession().setAttribute("mensagemErro", 
                    "A data de fim deve ser posterior à data de início.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?action=formCadastrar&unidadeGeradoraId=" + idUnidade);
                return;
            }

            if (qtdContratada < unidade.getQuantidadeMinimaAceita()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Quantidade contratada deve ser no mínimo " + unidade.getQuantidadeMinimaAceita() + " kWh.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?action=formCadastrar&unidadeGeradoraId=" + idUnidade);
                return;
            }

            Contrato contrato = new Contrato();
            contrato.setVigenciaInicio(vigenciaInicio);
            contrato.setVigenciaFim(vigenciaFim);
            contrato.setReajustePeriodico(reajustePeriodico);
            contrato.setQuantidadeContratada(qtdContratada);
            contrato.setUnidadeGeradora(unidade);
            contrato.setUsuario(usuario);

            contratoDAO.cadastrar(contrato);

            HistoricoContrato historico = new HistoricoContrato(
                LocalDateTime.now(),
                "Início do contrato",
                "Contrato firmado com sucesso.",
                TipoHistorico.ALTERACAO_CONTRATUAL,
                contrato
            );
            historicoContratoDAO.cadastrar(historico);

            request.getSession().setAttribute("mensagemSucesso", 
                "Contrato criado com sucesso! ID: " + contrato.getId());

            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + contrato.getId());

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "Dados numéricos inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao criar contrato: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }
    
    // MÉTODO CORRIGIDO E COMPLETADO
    private void adminAdicionarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String redirectPathOnError = request.getContextPath() + "/pages/admin/criarContrato.jsp";
        HttpSession session = request.getSession();

        try {
            String cpfCnpjUsuario = request.getParameter("cpfCnpjUsuario");
            String idUnidadeStr = request.getParameter("idUnidade");
            String vigenciaInicioStr = request.getParameter("vigenciaInicio");
            String vigenciaFimStr = request.getParameter("vigenciaFim");
            String reajustePeriodicoStr = request.getParameter("reajustePeriodico");
            String quantidadeContratadaStr = request.getParameter("quantidadeContratada");

            if (cpfCnpjUsuario == null || cpfCnpjUsuario.trim().isEmpty() ||
                idUnidadeStr == null || idUnidadeStr.trim().isEmpty() ||
                vigenciaInicioStr == null || vigenciaInicioStr.trim().isEmpty() ||
                vigenciaFimStr == null || vigenciaFimStr.trim().isEmpty() ||
                reajustePeriodicoStr == null || reajustePeriodicoStr.trim().isEmpty() ||
                quantidadeContratadaStr == null || quantidadeContratadaStr.trim().isEmpty()) {
                
                session.setAttribute("mensagemErro", "Todos os campos são obrigatórios.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            int idUnidade = Integer.parseInt(idUnidadeStr);
            LocalDate vigenciaInicio = LocalDate.parse(vigenciaInicioStr);
            LocalDate vigenciaFim = LocalDate.parse(vigenciaFimStr);
            int reajustePeriodico = Integer.parseInt(reajustePeriodicoStr);
            double quantidadeContratada = Double.parseDouble(quantidadeContratadaStr.replace(",", "."));

            if (vigenciaInicio.isAfter(vigenciaFim)) {
                session.setAttribute("mensagemErro", "A data de início da vigência não pode ser posterior à data de fim.");
                response.sendRedirect(redirectPathOnError);
                return;
            }
            
            Usuario contratante = usuarioDAO.buscarPorCpfCnpj(cpfCnpjUsuario);
            UnidadeGeradora unidadeContratada = unidadeDAO.buscarPorId(idUnidade);

            if (contratante == null || unidadeContratada == null) {
                session.setAttribute("mensagemErro", "Usuário ou Unidade Geradora inválidos.");
                response.sendRedirect(redirectPathOnError);
                return;
            }
            
            // --- LÓGICA DE NEGÓCIO ADICIONADA ---
            if (contratoDAO.existeContratoUsuarioUnidade(cpfCnpjUsuario, idUnidade)) {
                session.setAttribute("mensagemErro", "Este usuário já possui um contrato para esta unidade.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            if (quantidadeContratada < unidadeContratada.getQuantidadeMinimaAceita()) {
                session.setAttribute("mensagemErro", "Quantidade contratada deve ser no mínimo " + unidadeContratada.getQuantidadeMinimaAceita() + " kWh.");
                response.sendRedirect(redirectPathOnError);
                return;
            }
            // --- FIM DA LÓGICA ADICIONADA ---

            Contrato novoContrato = new Contrato();
            novoContrato.setUsuario(contratante);
            novoContrato.setUnidadeGeradora(unidadeContratada);
            novoContrato.setVigenciaInicio(vigenciaInicio);
            novoContrato.setVigenciaFim(vigenciaFim);
            novoContrato.setReajustePeriodico(reajustePeriodico);
            novoContrato.setQuantidadeContratada(quantidadeContratada);
            
            contratoDAO.cadastrar(novoContrato);
            
            // --- CRIAÇÃO DE HISTÓRICO ADICIONADA ---
            HistoricoContrato historico = new HistoricoContrato(
                LocalDateTime.now(),
                "Início do contrato (Admin)",
                "Contrato firmado com sucesso pelo administrador.",
                TipoHistorico.ALTERACAO_CONTRATUAL,
                novoContrato
            );
            historicoContratoDAO.cadastrar(historico);
            // --- FIM DA CRIAÇÃO DE HISTÓRICO ---

            session.setAttribute("mensagemSucesso", "Contrato criado com sucesso!");
            response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarContratos.jsp");

        } catch (NumberFormatException e) {
            session.setAttribute("mensagemErro", "Dados numéricos inválidos fornecidos. Verifique os campos de ID, reajuste e quantidade.");
            response.sendRedirect(redirectPathOnError);
        } catch (Exception e) {
            session.setAttribute("mensagemErro", "Erro ao processar o contrato: " + e.getMessage());
            response.sendRedirect(redirectPathOnError);
        }
    }

    private void editarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            LocalDate vigenciaInicio = LocalDate.parse(request.getParameter("vigenciaInicio"), DateTimeFormatter.ISO_DATE);
            LocalDate vigenciaFim = LocalDate.parse(request.getParameter("vigenciaFim"), DateTimeFormatter.ISO_DATE);
            int reajustePeriodico = Integer.parseInt(request.getParameter("reajustePeriodico"));
            double qtdContratada = Double.parseDouble(request.getParameter("quantidadeContratada").replace(",","."));

            int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));
            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);

            String cpfCnpjUsuario = request.getParameter("usuarioCpfCnpj");
            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpjUsuario);

            if (unidade == null || usuario == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Dados inválidos: unidade ou usuário não encontrado.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + id);
                return;
            }

            if (vigenciaFim.isBefore(vigenciaInicio)) {
                request.getSession().setAttribute("mensagemErro", 
                    "A data de fim deve ser posterior à data de início.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?action=formEditar&id=" + id);
                return;
            }

            if (qtdContratada < unidade.getQuantidadeMinimaAceita()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Quantidade contratada deve ser no mínimo " + unidade.getQuantidadeMinimaAceita() + " kWh.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?action=formEditar&id=" + id);
                return;
            }

            Contrato contrato = new Contrato();
            contrato.setId(id);
            contrato.setVigenciaInicio(vigenciaInicio);
            contrato.setVigenciaFim(vigenciaFim);
            contrato.setReajustePeriodico(reajustePeriodico);
            contrato.setQuantidadeContratada(qtdContratada);
            contrato.setUnidadeGeradora(unidade);
            contrato.setUsuario(usuario);

            contratoDAO.atualizar(contrato);

            HistoricoContrato historico = new HistoricoContrato(
                LocalDateTime.now(),
                "Alteração do contrato",
                "Contrato atualizado. Quantidade: " + qtdContratada + " kWh",
                TipoHistorico.ALTERACAO_CONTRATUAL,
                contrato
            );
            historicoContratoDAO.cadastrar(historico);

            request.getSession().setAttribute("mensagemSucesso", 
                "Contrato atualizado com sucesso!");

            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + id);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "Dados numéricos inválidos fornecidos.");
            String contratoId = request.getParameter("id");
            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + contratoId);
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao atualizar contrato: " + e.getMessage());
            String contratoId = request.getParameter("id");
            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + contratoId);
        }
    }

    private void deletarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            Contrato contrato = contratoDAO.buscarPorId(id);
            if (contrato == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Contrato não encontrado (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            String localizacaoUnidade = contrato.getUnidadeGeradora() != null ? 
                contrato.getUnidadeGeradora().getLocalizacao() : "N/A";

            contratoDAO.excluir(id);

            request.getSession().setAttribute("mensagemSucesso", 
                "Contrato cancelado com sucesso! (ID: " + id + " - " + localizacaoUnidade + ")");

            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID do contrato inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao cancelar contrato: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "ID do contrato não informado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            int id = Integer.parseInt(idStr);
            Contrato contrato = contratoDAO.buscarPorId(id);
            if (contrato == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Contrato não encontrado (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            List<Documento> listaDocumentos = documentoDAO.listarPorContrato(id);
            List<HistoricoContrato> listaHistoricos = historicoContratoDAO.listarPorContrato(id);

            request.setAttribute("contrato", contrato);
            request.setAttribute("listaDocumentos", listaDocumentos);
            request.setAttribute("listaHistoricos", listaHistoricos);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/contrato/detalhesContrato.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID do contrato inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar detalhes do contrato: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarPorUsuario(HttpServletRequest request, HttpServletResponse response, String cpfCnpj) throws SQLException, ServletException, IOException {
        try {
            List<Contrato> lista = contratoDAO.listarPorUsuario(cpfCnpj);
            if (!lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", 
                    "Encontrado(s) " + lista.size() + " contrato(s) para este usuário.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + lista.get(0).getId());
            } else {
                request.getSession().setAttribute("mensagemInfo", 
                    "Nenhum contrato encontrado para o usuário " + cpfCnpj + ".");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar contratos do usuário: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarPorUnidade(HttpServletRequest request, HttpServletResponse response, int idUnidade) throws SQLException, ServletException, IOException {
        try {
            List<Contrato> lista = contratoDAO.listarPorUnidade(idUnidade);
            if (!lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", 
                    "Encontrado(s) " + lista.size() + " contrato(s) para esta unidade.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + lista.get(0).getId());
            } else {
                request.getSession().setAttribute("mensagemInfo", 
                    "Nenhum contrato encontrado para a unidade ID " + idUnidade + ".");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar contratos da unidade: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarPorDono(HttpServletRequest request, HttpServletResponse response, String cpfCnpjDono)
            throws SQLException, ServletException, IOException {
        try {
            if (cpfCnpjDono == null || cpfCnpjDono.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF/CNPJ do dono não informado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            List<Contrato> lista = contratoDAO.listarPorDonoGeradora(cpfCnpjDono);
            request.setAttribute("contratosDono", lista);
            
            if (lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", 
                    "Nenhum contrato encontrado para suas unidades geradoras.");
            } else {
                request.getSession().setAttribute("mensagemSucesso", 
                    "Encontrado(s) " + lista.size() + " contrato(s) para suas unidades.");
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/usuario/dashboard.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar contratos do dono: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }
}

