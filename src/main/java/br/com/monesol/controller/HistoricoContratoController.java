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
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
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
            if (idContratoStr != null && !idContratoStr.isEmpty()) {
                int idContrato = Integer.parseInt(idContratoStr);
                listarPorContrato(request, response, idContrato);
            } else {
                request.getSession().setAttribute("mensagemErro", "ID do contrato não informado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "ID do contrato inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro interno: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
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
                    if (idContratoStr != null && !idContratoStr.isEmpty()) {
                        int idContrato = Integer.parseInt(idContratoStr);
                        listarPorContrato(request, response, idContrato);
                    } else {
                        request.getSession().setAttribute("mensagemErro", "ID do contrato não informado.");
                        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    }
                    break;
                default:
                    request.getSession().setAttribute("mensagemInfo", "Ação não reconhecida.");
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                    break;
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "Parâmetros numéricos inválidos.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro interno: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void adicionarHistorico(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int idContrato = Integer.parseInt(request.getParameter("contratoId"));
            String dataStr = request.getParameter("dataHistorico");
            String titulo = request.getParameter("titulo");
            String descricao = request.getParameter("descricao");
            String tipoStr = request.getParameter("tipo");

            if (dataStr == null || dataStr.trim().isEmpty() ||
                titulo == null || titulo.trim().isEmpty() ||
                descricao == null || descricao.trim().isEmpty() ||
                tipoStr == null || tipoStr.trim().isEmpty()) {

                request.getSession().setAttribute("mensagemErro", "Todos os campos são obrigatórios.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            LocalDateTime dataHistorico;
            try {
                dataHistorico = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            } catch (DateTimeParseException e) {
                request.getSession().setAttribute("mensagemErro", "Formato de data inválido.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            if (dataHistorico.isAfter(LocalDateTime.now().plusMinutes(5))) {
                request.getSession().setAttribute("mensagemErro", "Data do histórico não pode ser futura.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            TipoHistorico tipo;
            try {
                tipo = TipoHistorico.valueOf(tipoStr);
            } catch (IllegalArgumentException e) {
                request.getSession().setAttribute("mensagemErro", "Tipo de histórico inválido.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            Contrato contrato = contratoDAO.buscarPorId(idContrato);
            if (contrato == null) {
                request.getSession().setAttribute("mensagemErro", "Contrato não encontrado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            HistoricoContrato historico = new HistoricoContrato(dataHistorico, titulo, descricao, tipo, contrato);
            historicoDAO.cadastrar(historico);

            request.getSession().setAttribute("mensagemSucesso", "Ocorrência '" + titulo + "' adicionada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao adicionar histórico: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void editarHistorico(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int idContrato = Integer.parseInt(request.getParameter("contratoId"));

            HistoricoContrato historicoExistente = historicoDAO.buscarPorId(id);
            if (historicoExistente == null) {
                request.getSession().setAttribute("mensagemErro", "Histórico não encontrado.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            String dataStr = request.getParameter("dataHistorico");
            String titulo = request.getParameter("titulo");
            String descricao = request.getParameter("descricao");
            String tipoStr = request.getParameter("tipo");

            if (dataStr == null || titulo == null || descricao == null || tipoStr == null) {
                request.getSession().setAttribute("mensagemErro", "Todos os campos são obrigatórios.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            LocalDateTime dataHistorico = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            TipoHistorico tipo = TipoHistorico.valueOf(tipoStr);

            HistoricoContrato historico = new HistoricoContrato(dataHistorico, titulo, descricao, tipo, historicoExistente.getContrato());
            historico.setId(id);
            historicoDAO.atualizar(historico);

            request.getSession().setAttribute("mensagemSucesso", "Ocorrência '" + titulo + "' atualizada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao editar histórico: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void deletarHistorico(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int idContrato = Integer.parseInt(request.getParameter("contratoId"));

            HistoricoContrato historico = historicoDAO.buscarPorId(id);
            if (historico == null) {
                request.getSession().setAttribute("mensagemErro", "Histórico não encontrado.");
                response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);
                return;
            }

            String titulo = historico.getTitulo();
            historicoDAO.excluir(id);

            request.getSession().setAttribute("mensagemSucesso", "Ocorrência '" + titulo + "' excluída com sucesso!");
            response.sendRedirect(request.getContextPath() + "/ContratoController?id=" + idContrato);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao excluir histórico: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            HistoricoContrato historico = historicoDAO.buscarPorId(id);

            if (historico == null) {
                request.getSession().setAttribute("mensagemErro", "Histórico não encontrado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            request.setAttribute("historico", historico);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/historicoDetalhes.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao buscar histórico: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarPorContrato(HttpServletRequest request, HttpServletResponse response, int idContrato) throws IOException, ServletException {
        try {
            List<HistoricoContrato> lista = historicoDAO.listarPorContrato(idContrato);
            request.setAttribute("listaHistoricos", lista);
            request.setAttribute("contratoId", idContrato);

            if (lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", "Nenhuma ocorrência encontrada para este contrato.");
            }

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/listaHistoricos.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao listar históricos: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }
}
