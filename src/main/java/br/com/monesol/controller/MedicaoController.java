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
import java.io.PrintWriter;
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
            throw new ServletException(e);
        }
    }

    private void adicionarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String dataStr = request.getParameter("dataMedicao");
        LocalDateTime dataMedicao = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        double energiaGerada = Double.parseDouble(request.getParameter("energiaGerada"));
        double energiaConsumida = Double.parseDouble(request.getParameter("energiaConsumidaLocalmente"));
        double energiaInjetada = Double.parseDouble(request.getParameter("energiaInjetadaNaRede"));
        int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));

        UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);
        if (unidade == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Unidade Geradora não encontrada!'); window.location.href='pages/listaMedicoes.jsp';</script>");
            out.close();
            return;
        }

        Medicao medicao = new Medicao(dataMedicao, energiaGerada, energiaConsumida, energiaInjetada, unidade);
        medicaoDAO.cadastrar(medicao);

        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>alert('Medição cadastrada com sucesso!'); window.location.href='pages/listaMedicoes.jsp?unidadeGeradoraId=" + idUnidade + "';</script>");
        out.close();
    }

    private void editarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String dataStr = request.getParameter("dataMedicao");
        LocalDateTime dataMedicao = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

        double energiaGerada = Double.parseDouble(request.getParameter("energiaGerada"));
        double energiaConsumida = Double.parseDouble(request.getParameter("energiaConsumidaLocalmente"));
        double energiaInjetada = Double.parseDouble(request.getParameter("energiaInjetadaNaRede"));
        int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));

        UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);
        if (unidade == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Unidade Geradora não encontrada!'); window.location.href='pages/listaMedicoes.jsp';</script>");
            out.close();
            return;
        }

        Medicao medicao = new Medicao(dataMedicao, energiaGerada, energiaConsumida, energiaInjetada, unidade);
        medicao.setId(id);
        medicaoDAO.atualizar(medicao);

        response.sendRedirect("pages/listaMedicoes.jsp?unidadeGeradoraId=" + idUnidade);
    }

    private void deletarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        medicaoDAO.excluir(id);
        response.sendRedirect("pages/listaMedicoes.jsp");
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Medicao medicao = medicaoDAO.buscarPorId(id);

        if (medicao == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Medição não encontrada para ID: " + id + "'); window.location.href='pages/listaMedicoes.jsp';</script>");
            out.close();
            return;
        }

        request.setAttribute("medicao", medicao);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/medicaoDetalhes.jsp");
        dispatcher.forward(request, response);
    }

    private void listarPorUnidade(HttpServletRequest request, HttpServletResponse response, int idUnidade) throws SQLException, ServletException, IOException {
        List<Medicao> lista = medicaoDAO.listarPorUnidade(idUnidade);

        if (lista == null || lista.isEmpty()) {
            request.setAttribute("mensagem", "Nenhuma medição encontrada para essa unidade geradora.");
        }

        request.setAttribute("listaMedicoes", lista);
        request.setAttribute("unidadeGeradoraId", idUnidade);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/listaMedicoes.jsp");
        dispatcher.forward(request, response);
    }
}
