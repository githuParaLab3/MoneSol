package br.com.monesol.controller;

import br.com.monesol.dao.UnidadeGeradoraDAO;
import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.model.Usuario;
import br.com.monesol.model.Usuario.TipoUsuario;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/UnidadeGeradoraController")
public class UnidadeGeradoraController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UnidadeGeradoraDAO unidadeDAO;

    @Override
    public void init() throws ServletException {
        try {
            unidadeDAO = new UnidadeGeradoraDAO();
        } catch (Exception e) {
            throw new ServletException("Erro ao inicializar UnidadeGeradoraDAO", e);
        }
    }

    private Usuario getUsuarioLogado(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (Usuario) session.getAttribute("usuarioLogado");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String action = request.getParameter("action");

            if ("buscarPorId".equals(action)) {
                buscarPorId(request, response);
            } else if ("detalhesPublicos".equals(action)) {
                detalhesPublicos(request, response);
            } else if ("buscar".equals(action)) {
                buscarPorLocalizacao(request, response);
            } else {
                listarUnidades(request, response);
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
                    adicionarUnidade(request, response);
                    break;
                case "editar":
                    editarUnidade(request, response);
                    break;
                case "deletar":
                    deletarUnidade(request, response);
                    break;
                case "listar":
                    listarUnidades(request, response);
                    break;
                case "buscar":
                    buscarPorLocalizacao(request, response);
                    break;
                case "buscarPorId":
                    buscarPorId(request, response);
                    break;
                default:
                    listarUnidades(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void adicionarUnidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Usuario usuario = getUsuarioLogado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
            return;
        }

        String localizacao = request.getParameter("localizacao");
        double potencia = Double.parseDouble(request.getParameter("potenciaInstalada"));
        double eficiencia = Double.parseDouble(request.getParameter("eficienciaMedia"));
        double precoPorKWh = Double.parseDouble(request.getParameter("precoPorKWh"));
        double quantidadeMinima = Double.parseDouble(request.getParameter("quantidadeMinimaAceita"));
        String regra = request.getParameter("regraDeExcecoes"); // <<< novo campo

        UnidadeGeradora unidade = new UnidadeGeradora();
        unidade.setLocalizacao(localizacao);
        unidade.setPotenciaInstalada(potencia);
        unidade.setEficienciaMedia(eficiencia);
        unidade.setPrecoPorKWh(precoPorKWh);
        unidade.setQuantidadeMinimaAceita(quantidadeMinima);
        unidade.setRegraDeExcecoes(regra);

        if (usuario.getTipo() == TipoUsuario.DONO_GERADORA) {
            unidade.setCpfCnpjUsuario(usuario.getCpfCnpj());
        } else if (usuario.getTipo() == TipoUsuario.ADMIN) {
            String dono = request.getParameter("usuario");
            if (dono != null && !dono.isBlank()) {
                unidade.setCpfCnpjUsuario(dono);
            } else {
                unidade.setCpfCnpjUsuario(usuario.getCpfCnpj());
            }
        } else {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Sem permissão para cadastrar unidade.");
            return;
        }

        unidadeDAO.cadastrar(unidade); 

        HttpSession session = request.getSession();
        session.setAttribute("msgSucesso", "Unidade Geradora cadastrada com sucesso!");

        response.sendRedirect(request.getContextPath() 
                + "/UnidadeGeradoraController?action=buscarPorId&id=" + unidade.getId());
    }

    private void editarUnidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Usuario usuario = getUsuarioLogado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String localizacao = request.getParameter("localizacao");
        double potencia = Double.parseDouble(request.getParameter("potenciaInstalada"));
        double eficiencia = Double.parseDouble(request.getParameter("eficienciaMedia"));
        double precoPorKWh = Double.parseDouble(request.getParameter("precoPorKWh"));
        double quantidadeMinima = Double.parseDouble(request.getParameter("quantidadeMinimaAceita"));
        String regra = request.getParameter("regraDeExcecoes"); // <<< novo campo

        UnidadeGeradora existente = unidadeDAO.buscarPorId(id);
        if (existente == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unidade não encontrada.");
            return;
        }

        if (usuario.getTipo() == TipoUsuario.CONSUMIDOR_PARCEIRO && !usuario.getCpfCnpj().equals(existente.getCpfCnpjUsuario())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Sem permissão para editar essa unidade.");
            return;
        }

        existente.setLocalizacao(localizacao);
        existente.setPotenciaInstalada(potencia);
        existente.setEficienciaMedia(eficiencia);
        existente.setPrecoPorKWh(precoPorKWh);
        existente.setQuantidadeMinimaAceita(quantidadeMinima);
        existente.setRegraDeExcecoes(regra);

        if (usuario.getTipo() == TipoUsuario.ADMIN) {
            String novoDono = request.getParameter("usuario");
            if (novoDono != null && !novoDono.isBlank()) {
                existente.setCpfCnpjUsuario(novoDono);
            }
        }

        unidadeDAO.atualizar(existente);

        response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + id);
    }

    private void deletarUnidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        Usuario usuario = getUsuarioLogado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        UnidadeGeradora existente = unidadeDAO.buscarPorId(id);
        if (existente == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unidade não encontrada.");
            return;
        }

        if (usuario.getTipo() == TipoUsuario.CONSUMIDOR_PARCEIRO && !usuario.getCpfCnpj().equals(existente.getCpfCnpjUsuario())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Sem permissão para deletar essa unidade.");
            return;
        }

        unidadeDAO.excluir(id);
        response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
    }

    private void listarUnidades(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        Usuario usuario = getUsuarioLogado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
            return;
        }

        List<UnidadeGeradora> lista;
        if (usuario.getTipo() == TipoUsuario.CONSUMIDOR_PARCEIRO) {
            lista = unidadeDAO.listarPorUsuario(usuario.getCpfCnpj());
        } else if (usuario.getTipo() == TipoUsuario.ADMIN) {
            lista = unidadeDAO.listarTodas();
        } else {
            lista = List.of();
        }

        request.setAttribute("listaUnidades", lista);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/listaUnidades.jsp");
        dispatcher.forward(request, response);
    }

    private void buscarPorLocalizacao(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        Usuario usuario = getUsuarioLogado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
            return;
        }

        String localizacao = request.getParameter("localizacao");
        List<UnidadeGeradora> lista = unidadeDAO.buscarPorLocalizacao(localizacao);

        if (usuario.getTipo() == TipoUsuario.CONSUMIDOR_PARCEIRO) {
            lista = lista.stream()
                    .filter(u -> usuario.getCpfCnpj().equals(u.getCpfCnpjUsuario()))
                    .collect(Collectors.toList());
        }

        request.setAttribute("listaUnidades", lista != null ? lista : List.of());
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/listaUnidades.jsp");
        dispatcher.forward(request, response);
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        Usuario usuario = getUsuarioLogado(request);
        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        UnidadeGeradora unidade = unidadeDAO.buscarPorId(id);

        if (unidade == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unidade Geradora não encontrada para ID: " + id);
            return;
        }

        if (usuario.getTipo() == TipoUsuario.CONSUMIDOR_PARCEIRO && !usuario.getCpfCnpj().equals(unidade.getCpfCnpjUsuario())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Sem permissão para ver essa unidade.");
            return;
        }

        request.setAttribute("unidade", unidade);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/detalhesUnidade.jsp");
        dispatcher.forward(request, response);
    }

    private void detalhesPublicos(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        UnidadeGeradora unidade = unidadeDAO.buscarPorId(id);

        if (unidade == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Unidade Geradora não encontrada para ID: " + id);
            return;
        }

        request.setAttribute("unidade", unidade);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/detalhesUnidadePublica.jsp");
        dispatcher.forward(request, response);
    }
}
