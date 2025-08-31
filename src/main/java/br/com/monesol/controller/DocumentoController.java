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
                if (idContratoStr != null && !idContratoStr.isEmpty()) {
                    int idContrato = Integer.parseInt(idContratoStr);
                    listarPorContrato(request, response, idContrato);
                } else {
                    request.getSession().setAttribute("mensagemErro", 
                        "ID do contrato não informado para listar documentos.");
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                }
            } else {
                request.getSession().setAttribute("mensagemInfo", 
                    "Ação não reconhecida, redirecionando para dashboard.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID do contrato inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
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
                    if (idContratoStr != null && !idContratoStr.isEmpty()) {
                        int idContrato = Integer.parseInt(idContratoStr);
                        listarPorContrato(request, response, idContrato);
                    } else {
                        request.getSession().setAttribute("mensagemErro", 
                            "ID do contrato não informado para listar documentos.");
                        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    }
                    break;
                default:
                    request.getSession().setAttribute("mensagemInfo", 
                        "Ação não reconhecida, redirecionando para dashboard.");
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
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

    private void adicionarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        try {
            int idContrato = Integer.parseInt(request.getParameter("contratoId"));
            Contrato contrato = contratoDAO.buscarPorId(idContrato);
            
            if (contrato == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Contrato não encontrado (ID: " + idContrato + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            String dataStr = request.getParameter("dataDocumento");
            if (dataStr == null || dataStr.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Data do documento é obrigatória.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            LocalDateTime dataDocumento = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            TipoDocumento tipo = TipoDocumento.valueOf(request.getParameter("tipo"));
            String descricao = request.getParameter("descricao");

            if (descricao == null || descricao.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Descrição do documento é obrigatória.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            Part arquivoPart = request.getPart("arquivo");
            if (arquivoPart == null || arquivoPart.getSize() == 0) {
                request.getSession().setAttribute("mensagemErro", 
                    "Arquivo é obrigatório.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            String nomeArquivo = Paths.get(arquivoPart.getSubmittedFileName()).getFileName().toString();
            if (nomeArquivo.isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Nome do arquivo inválido.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            // Verificar extensão do arquivo
            String extensao = nomeArquivo.substring(nomeArquivo.lastIndexOf(".") + 1).toLowerCase();
            if (!extensao.matches("pdf|doc|docx|jpg|jpeg|png|txt")) {
                request.getSession().setAttribute("mensagemErro", 
                    "Tipo de arquivo não permitido. Use: PDF, DOC, DOCX, JPG, JPEG, PNG ou TXT.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            String uploadPath = getServletContext().getRealPath("/") + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Gerar nome único para evitar conflitos
            String nomeUnico = System.currentTimeMillis() + "_" + nomeArquivo;
            String caminhoArquivo = uploadPath + File.separator + nomeUnico;
            arquivoPart.write(caminhoArquivo);

            Documento doc = new Documento(tipo, descricao, dataDocumento, "uploads/" + nomeUnico, contrato);
            documentoDAO.cadastrar(doc);

            request.getSession().setAttribute("mensagemSucesso", 
                "Documento '" + descricao + "' adicionado com sucesso!");

            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID do contrato inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao adicionar documento: " + e.getMessage());
            String contratoId = request.getParameter("contratoId");
            if (contratoId != null && !contratoId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + contratoId);
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        }
    }

    private void editarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int idContrato = Integer.parseInt(request.getParameter("contratoId"));
            
            Contrato contrato = contratoDAO.buscarPorId(idContrato);
            if (contrato == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Contrato não encontrado (ID: " + idContrato + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            Documento docExistente = documentoDAO.buscarPorId(id);
            if (docExistente == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Documento não encontrado (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            String dataStr = request.getParameter("dataDocumento");
            if (dataStr == null || dataStr.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Data do documento é obrigatória.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            LocalDateTime dataDocumento = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            TipoDocumento tipo = TipoDocumento.valueOf(request.getParameter("tipo"));
            String descricao = request.getParameter("descricao");

            if (descricao == null || descricao.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Descrição do documento é obrigatória.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            Part arquivoPart = request.getPart("arquivo");
            String caminhoArquivo = docExistente.getArquivo(); // mantém o arquivo antigo por padrão

            // Se um novo arquivo foi enviado
            if (arquivoPart != null && arquivoPart.getSize() > 0) {
                String nomeArquivo = Paths.get(arquivoPart.getSubmittedFileName()).getFileName().toString();
                
                if (!nomeArquivo.isEmpty()) {
                    // Verificar extensão do arquivo
                    String extensao = nomeArquivo.substring(nomeArquivo.lastIndexOf(".") + 1).toLowerCase();
                    if (!extensao.matches("pdf|doc|docx|jpg|jpeg|png|txt")) {
                        request.getSession().setAttribute("mensagemErro", 
                            "Tipo de arquivo não permitido. Use: PDF, DOC, DOCX, JPG, JPEG, PNG ou TXT.");
                        response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                        return;
                    }

                    String uploadPath = getServletContext().getRealPath("/") + "uploads";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }

                    // Gerar nome único
                    String nomeUnico = System.currentTimeMillis() + "_" + nomeArquivo;
                    String novoCaminho = uploadPath + File.separator + nomeUnico;
                    arquivoPart.write(novoCaminho);
                    caminhoArquivo = "uploads/" + nomeUnico;

                    // Excluir arquivo antigo se existir
                    if (docExistente.getArquivo() != null && !docExistente.getArquivo().isEmpty()) {
                        String arquivoAntigo = getServletContext().getRealPath("/") + docExistente.getArquivo();
                        File fileAntigo = new File(arquivoAntigo);
                        if (fileAntigo.exists()) {
                            fileAntigo.delete();
                        }
                    }
                }
            }

            Documento doc = new Documento(tipo, descricao, dataDocumento, caminhoArquivo, contrato);
            doc.setId(id);
            documentoDAO.atualizar(doc);

            request.getSession().setAttribute("mensagemSucesso", 
                "Documento '" + descricao + "' atualizado com sucesso!");

            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "IDs inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao editar documento: " + e.getMessage());
            String contratoId = request.getParameter("contratoId");
            if (contratoId != null && !contratoId.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + contratoId);
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        }
    }

    private void deletarDocumento(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Documento doc = documentoDAO.buscarPorId(id);
            
            if (doc == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Documento não encontrado (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            int idContrato = doc.getContrato().getId();
            String descricaoDoc = doc.getDescricao();

            // Excluir arquivo físico se existir
            if (doc.getArquivo() != null && !doc.getArquivo().isEmpty()) {
                String caminhoArquivo = getServletContext().getRealPath("/") + doc.getArquivo();
                File arquivo = new File(caminhoArquivo);
                if (arquivo.exists()) {
                    arquivo.delete();
                }
            }

            documentoDAO.excluir(id);

            request.getSession().setAttribute("mensagemSucesso", 
                "Documento '" + descricaoDoc + "' excluído com sucesso!");

            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID do documento inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao excluir documento: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Documento doc = documentoDAO.buscarPorId(id);
            
            if (doc == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Documento não encontrado (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            request.setAttribute("documento", doc);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/documentoDetalhes.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID do documento inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar documento: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarPorContrato(HttpServletRequest request, HttpServletResponse response, int idContrato) throws SQLException, ServletException, IOException {
        try {
            List<Documento> lista = documentoDAO.listarPorContrato(idContrato);
            request.setAttribute("listaDocumentos", lista);
            request.setAttribute("contratoId", idContrato);

            if (lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", 
                    "Nenhum documento encontrado para este contrato.");
            } else {
                request.getSession().setAttribute("mensagemSucesso", 
                    "Encontrado(s) " + lista.size() + " documento(s) para este contrato.");
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/contrato/detalhesContrato.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao listar documentos: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }
}