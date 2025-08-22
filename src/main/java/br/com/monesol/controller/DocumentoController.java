package br.com.monesol.controller;

import br.com.monesol.dao.DocumentoDAO;
import br.com.monesol.dao.ContratoDAO;
import br.com.monesol.model.Documento;
import br.com.monesol.model.Documento.TipoDocumento;
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

@WebServlet("/DocumentoController")
public class DocumentoController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private DocumentoDAO documentoDAO;
    private ContratoDAO contratoDAO;

    @Override
    public void init() throws ServletException {
        try {
            documentoDAO = new DocumentoDAO();
            contratoDAO = new ContratoDAO();
        } catch (Exception e) {
            throw new ServletException("Erro ao inicializar DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("listarPorContrato".equals(action)) {
                String idContratoStr = request.getParameter("contratoId");
                if (idContratoStr != null) {
                    int idContrato = Integer.parseInt(idContratoStr);
                    listarPorContrato(request, response, idContrato);
                } else {
                    response.sendRedirect("pages/listaDocumentos.jsp");
                }
            } else {
                response.sendRedirect("pages/listaDocumentos.jsp");
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
                    adicionarDocumento(request, response);
                    break;
                case "editar":
                    editarDocumento(request, response);
                    break;
                case "deletar":
                    deletarDocumento(request, response);
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
                        response.sendRedirect("pages/listaDocumentos.jsp");
                    }
                    break;
                default:
                    response.sendRedirect("pages/listaDocumentos.jsp");
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void adicionarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String dataStr = request.getParameter("dataDocumento");
        LocalDateTime dataDocumento = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        TipoDocumento tipo = TipoDocumento.valueOf(request.getParameter("tipo"));
        String descricao = request.getParameter("descricao");
        String arquivo = request.getParameter("arquivo");

        int idContrato = Integer.parseInt(request.getParameter("contratoId"));
        Contrato contrato = contratoDAO.buscarPorId(idContrato);

        if (contrato == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Contrato não encontrado!'); window.location.href='pages/listaDocumentos.jsp';</script>");
            out.close();
            return;
        }

        Documento doc = new Documento(tipo, descricao, dataDocumento, arquivo, contrato);
        documentoDAO.cadastrar(doc);

        response.sendRedirect("pages/usuario/dashboard.jsp");
    }

    private void editarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String dataStr = request.getParameter("dataDocumento");
        LocalDateTime dataDocumento = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        TipoDocumento tipo = TipoDocumento.valueOf(request.getParameter("tipo"));
        String descricao = request.getParameter("descricao");
        String arquivo = request.getParameter("arquivo");

        int idContrato = Integer.parseInt(request.getParameter("contratoId"));
        Contrato contrato = contratoDAO.buscarPorId(idContrato);

        if (contrato == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Contrato não encontrado!'); window.location.href='pages/listaDocumentos.jsp';</script>");
            out.close();
            return;
        }

        Documento doc = new Documento(tipo, descricao, dataDocumento, arquivo, contrato);
        doc.setId(id);
        documentoDAO.atualizar(doc);

        response.sendRedirect("pages/listaDocumentos.jsp?contratoId=" + idContrato);
    }

    private void deletarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        documentoDAO.excluir(id);
        response.sendRedirect("pages/listaDocumentos.jsp");
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Documento doc = documentoDAO.buscarPorId(id);

        if (doc == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Documento não encontrado!'); window.location.href='pages/listaDocumentos.jsp';</script>");
            out.close();
            return;
        }

        request.setAttribute("documento", doc);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/documentoDetalhes.jsp");
        dispatcher.forward(request, response);
    }

    private void listarPorContrato(HttpServletRequest request, HttpServletResponse response, int idContrato) throws SQLException, ServletException, IOException {
        List<Documento> lista = documentoDAO.listarPorContrato(idContrato);

        request.setAttribute("listaDocumentos", lista);
        request.setAttribute("contratoId", idContrato);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/listaDocumentos.jsp");
        dispatcher.forward(request, response);
    }
    
}
