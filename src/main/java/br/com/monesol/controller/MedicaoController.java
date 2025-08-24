package br.com.monesol.controller;

import br.com.monesol.dao.MedicaoDAO;
import br.com.monesol.dao.UnidadeGeradoraDAO;
import br.com.monesol.model.Medicao;
import br.com.monesol.model.UnidadeGeradora;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@WebServlet("/MedicaoController")
public class MedicaoController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private MedicaoDAO medicaoDAO;
    private UnidadeGeradoraDAO unidadeDAO;

    @Override
    public void init() throws ServletException {
        try {
            medicaoDAO = new MedicaoDAO();
            unidadeDAO = new UnidadeGeradoraDAO();
        } catch (Exception e) {
            throw new ServletException("Erro ao inicializar DAOs", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idUnidadeStr = request.getParameter("unidadeGeradoraId");
            if (idUnidadeStr != null) {
                int idUnidade = Integer.parseInt(idUnidadeStr);
                listarPorUnidade(request, response, idUnidade);
            } else {
                response.sendRedirect("pages/listaMedicoes.jsp");
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
                    adicionarMedicao(request, response);
                    break;
                case "editar":
                    editarMedicao(request, response);
                    break;
                case "deletar":
                    deletarMedicao(request, response);
                    break;
                case "buscarPorId":
                    buscarPorId(request, response);
                    break;
                case "listarPorUnidade":
                    String idUnidadeStr = request.getParameter("unidadeGeradoraId");
                    if (idUnidadeStr != null) {
                        int idUnidade = Integer.parseInt(idUnidadeStr);
                        listarPorUnidade(request, response, idUnidade);
                    } else {
                        response.sendRedirect("pages/listaMedicoes.jsp");
                    }
                    break;
                default:
                    response.sendRedirect("pages/listaMedicoes.jsp");
                    break;
            }
        } catch (Exception e) {
            // Mensagem de erro global
            request.getSession().setAttribute("mensagemErro", "Ocorreu um erro: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void adicionarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            String dataStr = request.getParameter("dataMedicao");
            LocalDateTime dataMedicao = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

            double energiaGerada = Double.parseDouble(request.getParameter("energiaGerada"));
            double energiaConsumida = Double.parseDouble(request.getParameter("energiaConsumidaLocalmente"));
            double energiaInjetada = Double.parseDouble(request.getParameter("energiaInjetadaNaRede"));
            int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));

            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);
            if (unidade == null) {
                request.getSession().setAttribute("mensagemErro", "Unidade Geradora não encontrada!");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            Medicao medicao = new Medicao(dataMedicao, energiaGerada, energiaConsumida, energiaInjetada, unidade);
            medicaoDAO.cadastrar(medicao);

            request.getSession().setAttribute("mensagemSucesso", "Medição adicionada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao adicionar medição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void editarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String dataStr = request.getParameter("dataMedicao");
            LocalDateTime dataMedicao = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

            double energiaGerada = Double.parseDouble(request.getParameter("energiaGerada"));
            double energiaConsumida = Double.parseDouble(request.getParameter("energiaConsumidaLocalmente"));
            double energiaInjetada = Double.parseDouble(request.getParameter("energiaInjetadaNaRede"));
            int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));

            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);
            if (unidade == null) {
                request.getSession().setAttribute("mensagemErro", "Unidade Geradora não encontrada!");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            Medicao medicao = new Medicao(dataMedicao, energiaGerada, energiaConsumida, energiaInjetada, unidade);
            medicao.setId(id);
            medicaoDAO.atualizar(medicao);

            request.getSession().setAttribute("mensagemSucesso", "Medição atualizada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao editar medição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void deletarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            Medicao medicao = medicaoDAO.buscarPorId(id);
            if (medicao == null) {
                request.getSession().setAttribute("mensagemErro", "Medição não encontrada!");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            int idUnidade = medicao.getUnidadeGeradora().getId();
            medicaoDAO.excluir(id);

            request.getSession().setAttribute("mensagemSucesso", "Medição deletada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao deletar medição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicao medicao = medicaoDAO.buscarPorId(id);

        if (medicao == null) {
            request.getSession().setAttribute("mensagemErro", "Medição não encontrada para ID: " + id);
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
            return;
        }

        request.setAttribute("medicao", medicao);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/medicaoDetalhes.jsp");
        dispatcher.forward(request, response);
    }

    private void listarPorUnidade(HttpServletRequest request, HttpServletResponse response, int idUnidade) throws SQLException, ServletException, IOException {
        List<Medicao> lista = medicaoDAO.listarPorUnidade(idUnidade);

        request.setAttribute("listaMedicoes", lista);
        request.setAttribute("unidadeGeradoraId", idUnidade);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/listaMedicoes.jsp");
        dispatcher.forward(request, response);
    }
}
