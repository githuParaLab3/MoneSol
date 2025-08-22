package br.com.monesol.controller;

import br.com.monesol.dao.HistoricoContratoDAO;
import br.com.monesol.dao.ContratoDAO;
import br.com.monesol.model.HistoricoContrato;
import br.com.monesol.model.HistoricoContrato.TipoHistorico;
import br.com.monesol.model.Contrato;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/HistoricoContratoController")
public class HistoricoContratoController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private HistoricoContratoDAO historicoDAO;
    private ContratoDAO contratoDAO;

    @Override
    public void init() throws ServletException {
        try {
            historicoDAO = new HistoricoContratoDAO();
            contratoDAO = new ContratoDAO();
        } catch (Exception e) {
            throw new ServletException("Erro ao inicializar DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idContratoStr = request.getParameter("contratoId");
            if (idContratoStr != null) {
                int idContrato = Integer.parseInt(idContratoStr);
                listarPorContrato(request, response, idContrato);
            } else {
                response.sendRedirect("pages/historicoContrato/cadastrarHistorico.jsp");
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
                    adicionarHistorico(request, response);
                    break;
                case "editar":
                    editarHistorico(request, response);
                    break;
                case "deletar":
                    deletarHistorico(request, response);
                    break;
                case "buscarPorId":
                    buscarPorId(request, response);
                    break;
                case "listarPorContrato":
                    String idContratoStr = request.getParameter("contratoId");
                    if (idContratoStr != null) {
                        int idContrato = Integer.parseInt(idContratoStr);
                        listarPorContrato(request, response, idContrato);
                    } else {
                        response.sendRedirect("pages/listaHistoricos.jsp");
                    }
                    break;
                default:
                    response.sendRedirect("pages/listaHistoricos.jsp");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void adicionarHistorico(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String dataStr = request.getParameter("dataHistorico");
        LocalDateTime dataHistorico = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        String titulo = request.getParameter("titulo");
        String descricao = request.getParameter("descricao");
        TipoHistorico tipo = TipoHistorico.valueOf(request.getParameter("tipo"));

        int idContrato = Integer.parseInt(request.getParameter("contratoId"));
        Contrato contrato = contratoDAO.buscarPorId(idContrato);

        if (contrato == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Contrato não encontrado!'); window.location.href='pages/contrato/detalhesContrato.jsp';</script>");
            out.close();
            return;
        }

        HistoricoContrato historico = new HistoricoContrato(dataHistorico, titulo, descricao, tipo, contrato);
        historicoDAO.cadastrar(historico);

        response.sendRedirect(request.getContextPath() + "/ContratoController?action=buscarPorId&id=" + idContrato);
    }

    private void editarHistorico(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String dataStr = request.getParameter("dataHistorico");
        LocalDateTime dataHistorico = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        String titulo = request.getParameter("titulo");
        String descricao = request.getParameter("descricao");
        TipoHistorico tipo = TipoHistorico.valueOf(request.getParameter("tipo"));

        int idContrato = Integer.parseInt(request.getParameter("contratoId"));
        Contrato contrato = contratoDAO.buscarPorId(idContrato);

        if (contrato == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Contrato não encontrado!'); window.location.href='pages/listaHistoricos.jsp';</script>");
            out.close();
            return;
        }

        HistoricoContrato historico = new HistoricoContrato(dataHistorico, titulo, descricao, tipo, contrato);
        historico.setId(id);
        historicoDAO.atualizar(historico);

        response.sendRedirect("pages/listaHistoricos.jsp?contratoId=" + idContrato);
    }

    private void deletarHistorico(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        historicoDAO.excluir(id);
        response.sendRedirect("pages/listaHistoricos.jsp");
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        HistoricoContrato historico = historicoDAO.buscarPorId(id);

        if (historico == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Histórico não encontrado!'); window.location.href='pages/listaHistoricos.jsp';</script>");
            out.close();
            return;
        }

        request.setAttribute("historico", historico);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/historicoDetalhes.jsp");
        dispatcher.forward(request, response);
    }

    private void listarPorContrato(HttpServletRequest request, HttpServletResponse response, int idContrato) throws SQLException, ServletException, IOException {
        List<HistoricoContrato> lista = historicoDAO.listarPorContrato(idContrato);

        request.setAttribute("listaHistoricos", lista);
        request.setAttribute("contratoId", idContrato);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/listaHistoricos.jsp");
        dispatcher.forward(request, response);
    }
}
