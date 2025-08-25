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
        try {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                buscarPorId(request, response);
                return;
            }

            String cpfCnpj = request.getParameter("usuarioCpfCnpj");
            String idUnidadeStr = request.getParameter("unidadeGeradoraId");

            if (cpfCnpj != null && !cpfCnpj.isEmpty()) {
                listarPorUsuario(request, response, cpfCnpj);
            } else if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                int idUnidade = Integer.parseInt(idUnidadeStr);
                listarPorUnidade(request, response, idUnidade);
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "adicionar":
                    adicionarContrato(request, response);
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
                        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    }
                    break;
                case "listarPorUnidade":
                    String idUnidadeStr = request.getParameter("unidadeGeradoraId");
                    if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                        int idUnidade = Integer.parseInt(idUnidadeStr);
                        listarPorUnidade(request, response, idUnidade);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    }
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void adicionarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        LocalDate vigenciaInicio = LocalDate.parse(request.getParameter("vigenciaInicio"), DateTimeFormatter.ISO_DATE);
        LocalDate vigenciaFim = LocalDate.parse(request.getParameter("vigenciaFim"), DateTimeFormatter.ISO_DATE);
        int reajustePeriodico = Integer.parseInt(request.getParameter("reajustePeriodico"));
        String observacoes = request.getParameter("observacoes");
        String regrasExcecoes = request.getParameter("regrasExcecoes");
        double qtdContratada = Double.parseDouble(request.getParameter("quantidadeContratada"));

        int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));
        UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);

        String cpfCnpjUsuario = request.getParameter("usuarioCpfCnpj");
        Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpjUsuario);

        if (unidade == null || usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            return;
        }

        if (contratoDAO.existeContratoUsuarioUnidade(cpfCnpjUsuario, idUnidade)) {
            request.getSession().setAttribute("erroContratoExistente", 
                "Você já possui um contrato para esta unidade geradora.");
            response.sendRedirect(request.getContextPath() + "/pages/unidadeGeradora/listaUnidadesDisponiveis.jsp");
            return;
        }

        Contrato contrato = new Contrato();
        contrato.setVigenciaInicio(vigenciaInicio);
        contrato.setVigenciaFim(vigenciaFim);
        contrato.setReajustePeriodico(reajustePeriodico);
        contrato.setObservacoes(observacoes);
        contrato.setRegrasExcecoes(regrasExcecoes);
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

        response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + contrato.getId());
    }

    private void editarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        LocalDate vigenciaInicio = LocalDate.parse(request.getParameter("vigenciaInicio"), DateTimeFormatter.ISO_DATE);
        LocalDate vigenciaFim = LocalDate.parse(request.getParameter("vigenciaFim"), DateTimeFormatter.ISO_DATE);
        int reajustePeriodico = Integer.parseInt(request.getParameter("reajustePeriodico"));
        String observacoes = request.getParameter("observacoes");
        String regrasExcecoes = request.getParameter("regrasExcecoes");
        double qtdContratada = Double.parseDouble(request.getParameter("quantidadeContratada"));

        int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));
        UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);

        String cpfCnpjUsuario = request.getParameter("usuarioCpfCnpj");
        Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpjUsuario);

        if (unidade == null || usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            return;
        }

        Contrato contrato = new Contrato();
        contrato.setId(id);
        contrato.setVigenciaInicio(vigenciaInicio);
        contrato.setVigenciaFim(vigenciaFim);
        contrato.setReajustePeriodico(reajustePeriodico);
        contrato.setObservacoes(observacoes);
        contrato.setRegrasExcecoes(regrasExcecoes);
        contrato.setQuantidadeContratada(qtdContratada);
        contrato.setUnidadeGeradora(unidade);
        contrato.setUsuario(usuario);

        contratoDAO.atualizar(contrato);

        HistoricoContrato historico = new HistoricoContrato(
            LocalDateTime.now(),
            "Alteração do contrato",
            "Contrato atualizado. Quantidade: " + qtdContratada,
            TipoHistorico.ALTERACAO_CONTRATUAL,
            contrato
        );
        historicoContratoDAO.cadastrar(historico);

        response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + id);
    }

    private void deletarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        contratoDAO.excluir(id);
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            return;
        }

        int id = Integer.parseInt(idStr);
        Contrato contrato = contratoDAO.buscarPorId(id);
        if (contrato == null) {
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
    }

    private void listarPorUsuario(HttpServletRequest request, HttpServletResponse response, String cpfCnpj) throws SQLException, ServletException, IOException {
        List<Contrato> lista = contratoDAO.listarPorUsuario(cpfCnpj);
        if (!lista.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + lista.get(0).getId());
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarPorUnidade(HttpServletRequest request, HttpServletResponse response, int idUnidade) throws SQLException, ServletException, IOException {
        List<Contrato> lista = contratoDAO.listarPorUnidade(idUnidade);
        if (!lista.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + lista.get(0).getId());
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarPorDono(HttpServletRequest request, HttpServletResponse response, String cpfCnpjDono)
            throws SQLException, ServletException, IOException {
        List<Contrato> lista = contratoDAO.listarPorDonoGeradora(cpfCnpjDono);
        request.setAttribute("contratosDono", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/usuario/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
