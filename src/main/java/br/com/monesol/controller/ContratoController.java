package br.com.monesol.controller;

import br.com.monesol.dao.ContratoDAO;
import br.com.monesol.dao.UnidadeGeradoraDAO;
import br.com.monesol.dao.UsuarioDAO;
import br.com.monesol.dao.DocumentoDAO;
import br.com.monesol.dao.HistoricoContratoDAO;
import br.com.monesol.model.Contrato;
import br.com.monesol.model.Contrato.StatusContrato;
import br.com.monesol.model.Documento;
import br.com.monesol.model.HistoricoContrato;
import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.model.Usuario;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
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
            String cpfCnpj = request.getParameter("usuarioCpfCnpj");
            String idUnidadeStr = request.getParameter("unidadeGeradoraId");

            if (cpfCnpj != null && !cpfCnpj.isEmpty()) {
                listarPorUsuario(request, response, cpfCnpj);
            } else if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                int idUnidade = Integer.parseInt(idUnidadeStr);
                listarPorUnidade(request, response, idUnidade);
            } else {
                response.sendRedirect("pages/listaContratos.jsp");
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
                case "buscarPorId":
                    buscarPorId(request, response);
                    break;
                case "listarPorUsuario":
                    String cpfCnpj = request.getParameter("usuarioCpfCnpj");
                    if (cpfCnpj != null && !cpfCnpj.isEmpty()) {
                        listarPorUsuario(request, response, cpfCnpj);
                    } else {
                        response.sendRedirect("pages/listaContratos.jsp");
                    }
                    break;
                case "listarPorUnidade":
                    String idUnidadeStr = request.getParameter("unidadeGeradoraId");
                    if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                        int idUnidade = Integer.parseInt(idUnidadeStr);
                        listarPorUnidade(request, response, idUnidade);
                    } else {
                        response.sendRedirect("pages/listaContratos.jsp");
                    }
                    break;
                default:
                    response.sendRedirect("pages/listaContratos.jsp");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void adicionarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        try {
            LocalDate vigenciaInicio = LocalDate.parse(request.getParameter("vigenciaInicio"), DateTimeFormatter.ISO_DATE);
            LocalDate vigenciaFim = LocalDate.parse(request.getParameter("vigenciaFim"), DateTimeFormatter.ISO_DATE);
            int reajustePeriodico = Integer.parseInt(request.getParameter("reajustePeriodico"));
            StatusContrato status = StatusContrato.valueOf(request.getParameter("statusContrato"));
            String observacoes = request.getParameter("observacoes");
            String regrasExcecoes = request.getParameter("regrasExcecoes");
            double qtdContratada = Double.parseDouble(request.getParameter("quantidadeContratada"));

            int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));
            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);

            String cpfCnpjUsuario = request.getParameter("usuarioCpfCnpj");
            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpjUsuario);

            if (unidade == null || usuario == null) {
                response.setContentType("text/html; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>alert('Unidade Geradora ou Usuário não encontrado!'); window.location.href='pages/listaContratos.jsp';</script>");
                out.close();
                return;
            }

            Contrato contrato = new Contrato();
            contrato.setVigenciaInicio(vigenciaInicio);
            contrato.setVigenciaFim(vigenciaFim);
            contrato.setReajustePeriodico(reajustePeriodico);
            contrato.setStatusContrato(status);
            contrato.setObservacoes(observacoes);
            contrato.setRegrasExcecoes(regrasExcecoes);
            contrato.setQuantidadeContratada(qtdContratada);
            contrato.setUnidadeGeradora(unidade);
            contrato.setUsuario(usuario);

            contratoDAO.cadastrar(contrato);
            response.sendRedirect("pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void editarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            LocalDate vigenciaInicio = LocalDate.parse(request.getParameter("vigenciaInicio"), DateTimeFormatter.ISO_DATE);
            LocalDate vigenciaFim = LocalDate.parse(request.getParameter("vigenciaFim"), DateTimeFormatter.ISO_DATE);
            int reajustePeriodico = Integer.parseInt(request.getParameter("reajustePeriodico"));
            StatusContrato status = StatusContrato.valueOf(request.getParameter("statusContrato"));
            String observacoes = request.getParameter("observacoes");
            String regrasExcecoes = request.getParameter("regrasExcecoes");
            double qtdContratada = Double.parseDouble(request.getParameter("quantidadeContratada"));

            int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));
            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);

            String cpfCnpjUsuario = request.getParameter("usuarioCpfCnpj");
            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpjUsuario);

            if (unidade == null || usuario == null) {
                response.setContentType("text/html; charset=UTF-8");
                PrintWriter out = response.getWriter();
                out.println("<script>alert('Unidade Geradora ou Usuário não encontrado!'); window.location.href='pages/listaContratos.jsp';</script>");
                out.close();
                return;
            }

            Contrato contrato = new Contrato();
            contrato.setId(id);
            contrato.setVigenciaInicio(vigenciaInicio);
            contrato.setVigenciaFim(vigenciaFim);
            contrato.setReajustePeriodico(reajustePeriodico);
            contrato.setStatusContrato(status);
            contrato.setObservacoes(observacoes);
            contrato.setRegrasExcecoes(regrasExcecoes);
            contrato.setQuantidadeContratada(qtdContratada);
            contrato.setUnidadeGeradora(unidade);
            contrato.setUsuario(usuario);

            contratoDAO.atualizar(contrato);
            response.sendRedirect("pages/listaContratos.jsp?usuarioCpfCnpj=" + cpfCnpjUsuario);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void deletarContrato(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        contratoDAO.excluir(id);
        response.sendRedirect("pages/listaContratos.jsp");
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Contrato contrato = contratoDAO.buscarPorId(id);

        if (contrato == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Contrato não encontrado!'); window.location.href='pages/contrato/detalhesContrato.jsp';</script>");
            out.close();
            return;
        }

        List<Documento> listaDocumentos = documentoDAO.listarPorContrato(id);
        List<HistoricoContrato> listaHistoricos = historicoContratoDAO.listarPorContrato(id);

        request.setAttribute("contrato", contrato);
        request.setAttribute("listaDocumentos", listaDocumentos);
        request.setAttribute("listaHistoricos", listaHistoricos);

        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/contrato/detalhesContrato.jsp");
        dispatcher.forward(request, response);
    }

    private void listarPorUsuario(HttpServletRequest request, HttpServletResponse response, String cpfCnpj) throws SQLException, ServletException, IOException {
        List<Contrato> lista = contratoDAO.listarPorUsuario(cpfCnpj);
        request.setAttribute("listaContratos", lista);
        request.setAttribute("usuarioCpfCnpj", cpfCnpj);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/contrato/detalhesContrato.jsp");
        dispatcher.forward(request, response);
    }

    private void listarPorUnidade(HttpServletRequest request, HttpServletResponse response, int idUnidade) throws SQLException, ServletException, IOException {
        List<Contrato> lista = contratoDAO.listarPorUnidade(idUnidade);
        request.setAttribute("listaContratos", lista);
        request.setAttribute("unidadeGeradoraId", idUnidade);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/listaContratos.jsp");
        dispatcher.forward(request, response);
    }
}
