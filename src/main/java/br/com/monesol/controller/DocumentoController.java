package br.com.monesol.controller;

import br.com.monesol.dao.DocumentoDAO;
import br.com.monesol.dao.ContratoDAO;
import br.com.monesol.model.Documento;
import br.com.monesol.model.Documento.TipoDocumento;
import br.com.monesol.model.Contrato;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/DocumentoController")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 10 * 1024 * 1024,  // 10MB
        maxRequestSize = 50 * 1024 * 1024 // 50MB
)
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
        String action = request.getParameter("action");
        try {
            if ("listarPorContrato".equals(action)) {
                String idContratoStr = request.getParameter("contratoId");
                if (idContratoStr != null) {
                    int idContrato = Integer.parseInt(idContratoStr);
                    listarPorContrato(request, response, idContrato);
                } else {
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                }
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
                case "adicionar": adicionarDocumento(request, response); break;
                case "editar": editarDocumento(request, response); break;
                case "deletar": deletarDocumento(request, response); break;
                case "buscarPorId": buscarPorId(request, response); break;
                case "listarPorContrato":
                    String idContratoStr = request.getParameter("contratoId");
                    if (idContratoStr != null) {
                        int idContrato = Integer.parseInt(idContratoStr);
                        listarPorContrato(request, response, idContrato);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    }
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void adicionarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int idContrato = Integer.parseInt(request.getParameter("contratoId"));
        Contrato contrato = contratoDAO.buscarPorId(idContrato);
        if (contrato == null) {
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Contrato não encontrado!'); window.location.href='" 
                    + request.getContextPath() + "/pages/usuario/dashboard.jsp';</script>");
            out.close();
            return;
        }

        String dataStr = request.getParameter("dataDocumento");
        LocalDateTime dataDocumento = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        TipoDocumento tipo = TipoDocumento.valueOf(request.getParameter("tipo"));
        String descricao = request.getParameter("descricao");

        Part arquivoPart = request.getPart("arquivo");
        String nomeArquivo = Paths.get(arquivoPart.getSubmittedFileName()).getFileName().toString();

        String uploadPath = getServletContext().getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String caminhoArquivo = uploadPath + File.separator + nomeArquivo;
        arquivoPart.write(caminhoArquivo);

        Documento doc = new Documento(tipo, descricao, dataDocumento, "uploads/" + nomeArquivo, contrato);
        documentoDAO.cadastrar(doc);

        response.sendRedirect(request.getContextPath() + "/ContratoController?action=buscarPorId&id=" + idContrato);
    }

    private void editarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(request.getParameter("id"));
        int idContrato = Integer.parseInt(request.getParameter("contratoId"));
        Contrato contrato = contratoDAO.buscarPorId(idContrato);
        if (contrato == null) {
            response.getWriter().println("<script>alert('Contrato não encontrado!'); window.location.href='" 
                    + request.getContextPath() + "/pages/usuario/dashboard.jsp';</script>");
            return;
        }

        Documento docExistente = documentoDAO.buscarPorId(id);
        if (docExistente == null) {
            response.getWriter().println("<script>alert('Documento não encontrado!'); window.location.href='" 
                    + request.getContextPath() + "/pages/usuario/dashboard.jsp';</script>");
            return;
        }

        String dataStr = request.getParameter("dataDocumento");
        LocalDateTime dataDocumento = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        TipoDocumento tipo = TipoDocumento.valueOf(request.getParameter("tipo"));
        String descricao = request.getParameter("descricao");

        Part arquivoPart = request.getPart("arquivo");
        String caminhoArquivo = docExistente.getArquivo(); // mantém antigo

        if (arquivoPart != null && arquivoPart.getSize() > 0) {
            String nomeArquivo = Paths.get(arquivoPart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String novoCaminho = uploadPath + File.separator + nomeArquivo;
            arquivoPart.write(novoCaminho);
            caminhoArquivo = "uploads/" + nomeArquivo;
        }

        Documento doc = new Documento(tipo, descricao, dataDocumento, caminhoArquivo, contrato);
        doc.setId(id);
        documentoDAO.atualizar(doc);

        response.sendRedirect(request.getContextPath() + "/ContratoController?action=buscarPorId&id=" + idContrato);
    }

    private void deletarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Documento doc = documentoDAO.buscarPorId(id);
        if (doc != null) {
            int idContrato = doc.getContrato().getId();
            documentoDAO.excluir(id);
            response.sendRedirect(request.getContextPath() + "/ContratoController?action=buscarPorId&id=" + idContrato);
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Documento doc = documentoDAO.buscarPorId(id);
        if (doc == null) {
            response.getWriter().println("<script>alert('Documento não encontrado!'); window.location.href='" 
                    + request.getContextPath() + "/pages/usuario/dashboard.jsp';</script>");
            return;
        }
        request.setAttribute("documento", doc);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/documentoDetalhes.jsp");
        dispatcher.forward(request, response);
    }

    private void listarPorContrato(HttpServletRequest request, HttpServletResponse response, int idContrato) throws SQLException, ServletException, IOException {
        List<Documento> lista = documentoDAO.listarPorContrato(idContrato);
        request.setAttribute("listaDocumentos", lista);
        request.setAttribute("contratoId", idContrato);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/contrato/detalhesContrato.jsp");
        dispatcher.forward(request, response);
    }
}
