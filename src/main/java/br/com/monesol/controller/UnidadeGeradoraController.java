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
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "Parâmetro numérico inválido fornecido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
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
                    request.getSession().setAttribute("mensagemInfo", "Ação não reconhecida, redirecionando para dashboard.");
                    listarUnidades(request, response);
                    break;
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "Dados numéricos inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void adicionarUnidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            Usuario usuario = getUsuarioLogado(request);
            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", "Usuário não logado. Faça login para continuar.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
                return;
            }

            String localizacao = request.getParameter("localizacao");
            double potencia = Double.parseDouble(request.getParameter("potenciaInstalada"));
            double eficiencia = Double.parseDouble(request.getParameter("eficienciaMedia"));
            double precoPorKWh = Double.parseDouble(request.getParameter("precoPorKWh"));
            double quantidadeMinima = Double.parseDouble(request.getParameter("quantidadeMinimaAceita"));
            String regra = request.getParameter("regraDeExcecoes");

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
                unidade.setCpfCnpjUsuario((dono != null && !dono.isBlank()) ? dono : usuario.getCpfCnpj());
            } else {
                request.getSession().setAttribute("mensagemErro", "Você não tem permissão para cadastrar unidade.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            unidadeDAO.cadastrar(unidade);

            request.getSession().setAttribute("mensagemSucesso", "Unidade Geradora '" + localizacao + "' cadastrada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + unidade.getId());

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "Valores numéricos inválidos.");
            response.sendRedirect(request.getContextPath() + "/pages/unidadeGeradora/cadastrarUnidade.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao cadastrar unidade: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void editarUnidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            Usuario usuario = getUsuarioLogado(request);
            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", "Usuário não logado. Faça login para continuar.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));
            UnidadeGeradora existente = unidadeDAO.buscarPorId(id);

            if (existente == null) {
                request.getSession().setAttribute("mensagemErro", "Unidade Geradora não encontrada (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            String localizacao = request.getParameter("localizacao");
            double potencia = Double.parseDouble(request.getParameter("potenciaInstalada"));
            double eficiencia = Double.parseDouble(request.getParameter("eficienciaMedia"));
            double precoPorKWh = Double.parseDouble(request.getParameter("precoPorKWh"));
            double quantidadeMinima = Double.parseDouble(request.getParameter("quantidadeMinimaAceita"));
            String regra = request.getParameter("regraDeExcecoes");

            existente.setLocalizacao(localizacao);
            existente.setPotenciaInstalada(potencia);
            existente.setEficienciaMedia(eficiencia);
            existente.setPrecoPorKWh(precoPorKWh);
            existente.setQuantidadeMinimaAceita(quantidadeMinima);
            existente.setRegraDeExcecoes(regra);

            unidadeDAO.atualizar(existente);

            request.getSession().setAttribute("mensagemSucesso", "Unidade Geradora '" + localizacao + "' atualizada com sucesso!");
            response.sendRedirect(request.getContextPath() + "/UnidadeGeradoraController?action=buscarPorId&id=" + id);

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "Valores inválidos fornecidos.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao editar unidade: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void deletarUnidade(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            Usuario usuario = getUsuarioLogado(request);
            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", "Usuário não logado. Faça login para continuar.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));
            UnidadeGeradora existente = unidadeDAO.buscarPorId(id);

            if (existente == null) {
                request.getSession().setAttribute("mensagemErro", "Unidade Geradora não encontrada (ID: " + id + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            unidadeDAO.excluir(id);

            request.getSession().setAttribute("mensagemSucesso", "Unidade Geradora excluída com sucesso!");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("mensagemErro", "ID inválido.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao excluir unidade: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void listarUnidades(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            Usuario usuario = getUsuarioLogado(request);
            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", "Usuário não logado. Faça login para continuar.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
                return;
            }

            List<UnidadeGeradora> lista;
            if (usuario.getTipo() == TipoUsuario.CONSUMIDOR_PARCEIRO) {
                lista = unidadeDAO.listarPorUsuario(usuario.getCpfCnpj());
            } else {
                lista = unidadeDAO.listarTodas();
            }

            if (lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", "Nenhuma unidade encontrada.");
            } else {
                request.getSession().setAttribute("mensagemSucesso", "Encontrada(s) " + lista.size() + " unidade(s).");
            }

            request.setAttribute("listaUnidades", lista);
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/listaUnidades.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao listar unidades: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void buscarPorLocalizacao(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            Usuario usuario = getUsuarioLogado(request);
            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", "Usuário não logado. Faça login para continuar.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
                return;
            }

            String localizacao = request.getParameter("localizacao");
            List<UnidadeGeradora> lista = unidadeDAO.buscarPorLocalizacao(localizacao);

            if (lista.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", "Nenhuma unidade encontrada para localização: " + localizacao);
            } else {
                request.getSession().setAttribute("mensagemSucesso", "Encontrada(s) " + lista.size() + " unidade(s) em " + localizacao);
            }

            request.setAttribute("listaUnidades", lista);
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/listaUnidades.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao buscar unidades: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void buscarPorId(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            Usuario usuario = getUsuarioLogado(request);
            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", "Usuário não logado. Faça login para continuar.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
                return;
            }

            int id = Integer.parseInt(request.getParameter("id"));
            UnidadeGeradora unidade = unidadeDAO.buscarPorId(id);

            if (unidade == null) {
                request.getSession().setAttribute("mensagemErro", "Unidade Geradora não encontrada.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            request.setAttribute("unidade", unidade);
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/detalhesUnidade.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao buscar unidade: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void detalhesPublicos(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        UnidadeGeradora unidade = unidadeDAO.buscarPorId(id);

        if (unidade == null) {
            request.getSession().setAttribute("mensagemErro", "Unidade Geradora pública não encontrada.");
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            return;
        }

        request.setAttribute("unidade", unidade);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/unidadeGeradora/detalhesUnidadePublica.jsp");
        dispatcher.forward(request, response);
    }
}
