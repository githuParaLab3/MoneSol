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
import java.time.format.DateTimeParseException;
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
            if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                int idUnidade = Integer.parseInt(idUnidadeStr);
                listarPorUnidade(request, response, idUnidade);
            } else {
                request.getSession().setAttribute("mensagemErro", 
                    "ID da unidade geradora não informado para listar medições.");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID da unidade geradora inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
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
                    if (idUnidadeStr != null && !idUnidadeStr.isEmpty()) {
                        int idUnidade = Integer.parseInt(idUnidadeStr);
                        listarPorUnidade(request, response, idUnidade);
                    } else {
                        request.getSession().setAttribute("mensagemErro", 
                            "ID da unidade não informado para listar medições.");
                        response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                    }
                    break;
                default:
                    request.getSession().setAttribute("mensagemInfo", 
                        "Ação não reconhecida, redirecionando para lista de medições.");
                    response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                    break;
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "Dados numéricos inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void adicionarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            String dataStr = request.getParameter("dataMedicao");
            if (dataStr == null || dataStr.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Data da medição é obrigatória.");
                response.sendRedirect(request.getContextPath() + "/pages/medicao/cadastrarMedicao.jsp");
                return;
            }

            LocalDateTime dataMedicao;
            try {
                dataMedicao = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            } catch (DateTimeParseException e) {
                request.getSession().setAttribute("mensagemErro", 
                    "Formato de data inválido.");
                response.sendRedirect(request.getContextPath() + "/pages/medicao/cadastrarMedicao.jsp");
                return;
            }

            // Validar se data não é futura
            if (dataMedicao.isAfter(LocalDateTime.now().plusMinutes(5))) {
                request.getSession().setAttribute("mensagemErro", 
                    "Data da medição não pode ser futura.");
                response.sendRedirect(request.getContextPath() + "/pages/medicao/cadastrarMedicao.jsp");
                return;
            }

            String energiaGeradaStr = request.getParameter("energiaGerada");
            String energiaConsumidaStr = request.getParameter("energiaConsumidaLocalmente");
            String energiaInjetadaStr = request.getParameter("energiaInjetadaNaRede");
            String idUnidadeStr = request.getParameter("unidadeGeradoraId");

            // Validar campos obrigatórios
            if (energiaGeradaStr == null || energiaGeradaStr.trim().isEmpty() ||
                energiaConsumidaStr == null || energiaConsumidaStr.trim().isEmpty() ||
                energiaInjetadaStr == null || energiaInjetadaStr.trim().isEmpty() ||
                idUnidadeStr == null || idUnidadeStr.trim().isEmpty()) {
                
                request.getSession().setAttribute("mensagemErro", 
                    "Todos os campos de energia são obrigatórios.");
                response.sendRedirect(request.getContextPath() + "/pages/medicao/cadastrarMedicao.jsp");
                return;
            }

            double energiaGerada = Double.parseDouble(energiaGeradaStr);
            double energiaConsumida = Double.parseDouble(energiaConsumidaStr);
            double energiaInjetada = Double.parseDouble(energiaInjetadaStr);
            int idUnidade = Integer.parseInt(idUnidadeStr);

            // Validar valores não negativos
            if (energiaGerada < 0 || energiaConsumida < 0 || energiaInjetada < 0) {
                request.getSession().setAttribute("mensagemErro", 
                    "Valores de energia não podem ser negativos.");
                response.sendRedirect(request.getContextPath() + "/pages/medicao/cadastrarMedicao.jsp");
                return;
            }

            // Validar lógica: energia injetada + consumida não pode ser maior que gerada
            if ((energiaConsumida + energiaInjetada) > (energiaGerada * 1.05)) { // 5% tolerância
                request.getSession().setAttribute("mensagemErro", 
                    "Soma da energia consumida e injetada não pode ser maior que a energia gerada.");
                response.sendRedirect(request.getContextPath() + "/pages/medicao/cadastrarMedicao.jsp");
                return;
            }

            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);
            if (unidade == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Unidade Geradora não encontrada (ID: " + idUnidade + ").");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            Medicao medicao = new Medicao(dataMedicao, energiaGerada, energiaConsumida, energiaInjetada, unidade);
            medicaoDAO.cadastrar(medicao);

            request.getSession().setAttribute("mensagemSucesso", 
                "Medição adicionada com sucesso! Energia gerada: " + energiaGerada + " kWh");

            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "Valores numéricos inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao adicionar medição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void editarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            // Verificar se medição existe
            Medicao medicaoExistente = medicaoDAO.buscarPorId(id);
            if (medicaoExistente == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Medição não encontrada (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            String dataStr = request.getParameter("dataMedicao");
            if (dataStr == null || dataStr.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "Data da medição é obrigatória.");
                int idUnidade = medicaoExistente.getUnidadeGeradora().getId();
                response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
                return;
            }

            LocalDateTime dataMedicao;
            try {
                dataMedicao = LocalDateTime.parse(dataStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            } catch (DateTimeParseException e) {
                request.getSession().setAttribute("mensagemErro", 
                    "Formato de data inválido.");
                int idUnidade = medicaoExistente.getUnidadeGeradora().getId();
                response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
                return;
            }

            // Validar se data não é futura
            if (dataMedicao.isAfter(LocalDateTime.now().plusMinutes(5))) {
                request.getSession().setAttribute("mensagemErro", 
                    "Data da medição não pode ser futura.");
                int idUnidade = medicaoExistente.getUnidadeGeradora().getId();
                response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
                return;
            }

            double energiaGerada = Double.parseDouble(request.getParameter("energiaGerada"));
            double energiaConsumida = Double.parseDouble(request.getParameter("energiaConsumidaLocalmente"));
            double energiaInjetada = Double.parseDouble(request.getParameter("energiaInjetadaNaRede"));
            int idUnidade = Integer.parseInt(request.getParameter("unidadeGeradoraId"));

            // Validar valores não negativos
            if (energiaGerada < 0 || energiaConsumida < 0 || energiaInjetada < 0) {
                request.getSession().setAttribute("mensagemErro", 
                    "Valores de energia não podem ser negativos.");
                response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
                return;
            }

            // Validar lógica energética
            if ((energiaConsumida + energiaInjetada) > (energiaGerada * 1.05)) {
                request.getSession().setAttribute("mensagemErro", 
                    "Soma da energia consumida e injetada não pode ser maior que a energia gerada.");
                response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);
                return;
            }

            UnidadeGeradora unidade = unidadeDAO.buscarPorId(idUnidade);
            if (unidade == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Unidade Geradora não encontrada (ID: " + idUnidade + ").");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            Medicao medicao = new Medicao(dataMedicao, energiaGerada, energiaConsumida, energiaInjetada, unidade);
            medicao.setId(id);
            medicaoDAO.atualizar(medicao);

            request.getSession().setAttribute("mensagemSucesso", 
                "Medição atualizada com sucesso! Energia gerada: " + energiaGerada + " kWh");

            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "Dados numéricos inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao editar medição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void deletarMedicao(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));

            Medicao medicao = medicaoDAO.buscarPorId(id);
            if (medicao == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Medição não encontrada (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            int idUnidade = medicao.getUnidadeGeradora().getId();
            double energiaGerada = medicao.getEnergiaGerada();
            
            medicaoDAO.excluir(id);

            request.getSession().setAttribute("mensagemSucesso", 
                "Medição excluída com sucesso! (ID: " + id + " - " + energiaGerada + " kWh)");

            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + idUnidade);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID da medição inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao excluir medição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Medicao medicao = medicaoDAO.buscarPorId(id);

            if (medicao == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Medição não encontrada (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
                return;
            }

            request.setAttribute("medicao", medicao);
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/medicaoDetalhes.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", 
                "ID da medição inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar medição: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }

    private void listarPorUnidade(HttpServletRequest request, HttpServletResponse response, int idUnidade) throws SQLException, ServletException, IOException {
        try {
            List<Medicao> lista = medicaoDAO.listarPorUnidade(idUnidade);

            if (lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", 
                    "Nenhuma medição encontrada para esta unidade geradora.");
            } else {
                request.getSession().setAttribute("mensagemSucesso", 
                    "Encontrada(s) " + lista.size() + " medição(ões) para esta unidade.");
            }

            request.setAttribute("listaMedicoes", lista);
            request.setAttribute("unidadeGeradoraId", idUnidade);
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/listaMedicoes.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao listar medições: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/listaMedicoes.jsp");
        }
    }
}