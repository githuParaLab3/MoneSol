package br.com.monesol.controller;

import br.com.monesol.dao.UsuarioDAO;
import br.com.monesol.model.Usuario;
import br.com.monesol.model.Usuario.TipoUsuario;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/UsuarioController")
public class UsuarioController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UsuarioDAO usuarioDAO;

    @Override
    public void init() throws ServletException {
        try {
            usuarioDAO = new UsuarioDAO();
        } catch (Exception e) {
            throw new ServletException("Erro ao inicializar UsuarioDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            listarUsuarios(request, response);
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
                    adicionarUsuario(request, response);
                    break;
                case "editar":
                    editarUsuario(request, response);
                    break;
                case "deletar":
                    deletarUsuario(request, response);
                    break;
                case "listar":
                    listarUsuarios(request, response);
                    break;
                case "buscar":
                    buscarUsuario(request, response);
                    break;
                case "login":
                    login(request, response);
                    break;
                case "logout":
                    logout(request, response);
                    break;
                default:
                    listarUsuarios(request, response);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ================== ADMIN / USUÁRIO ===================

    private void adicionarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String cpfCnpj = request.getParameter("cpfCnpj").replaceAll("\\D", ""); 
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String contato = request.getParameter("contato");
        String endereco = request.getParameter("endereco");
        String tipoStr = request.getParameter("tipo");

        TipoUsuario tipo = TipoUsuario.CONSUMIDOR_PARCEIRO;
        if (tipoStr != null && !tipoStr.isEmpty()) {
            try {
                TipoUsuario tipoTemp = TipoUsuario.valueOf(tipoStr);
                if (tipoTemp == TipoUsuario.DONO_GERADORA || tipoTemp == TipoUsuario.CONSUMIDOR_PARCEIRO) {
                    tipo = tipoTemp;
                }
            } catch (IllegalArgumentException e) {}
        }

        Usuario usuario = new Usuario(cpfCnpj, nome, email, senha, contato, endereco, tipo);
        usuarioDAO.cadastrar(usuario);

        HttpSession session = request.getSession(true);
        session.setAttribute("usuarioLogado", usuario);

        response.sendRedirect("index.jsp");
    }

    private void editarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String cpfCnpjRaw = request.getParameter("cpfCnpj");
        String cpfCnpj = (cpfCnpjRaw != null) ? cpfCnpjRaw.replaceAll("\\D", "") : "";

        HttpSession session = request.getSession(false);
        Usuario logado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        // Usuário normal só pode editar o próprio perfil
        if (logado == null || (logado.getTipo() != TipoUsuario.ADMIN && !logado.getCpfCnpj().equals(cpfCnpj))) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String contato = request.getParameter("contato");
        String endereco = request.getParameter("endereco");
        String tipoStr = request.getParameter("tipo");
        TipoUsuario tipo = null;
        if (tipoStr != null && !tipoStr.isBlank() && logado.getTipo() == TipoUsuario.ADMIN) {
            try {
                tipo = TipoUsuario.valueOf(tipoStr);
            } catch (IllegalArgumentException e) {}
        }

        Usuario existente = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
        if (existente == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Usuário não encontrado.'); window.location.href='pages/usuario/dashboard.jsp';</script>");
            out.close();
            return;
        }

        // Se senha não fornecida, mantém a antiga
        String senhaFinal = (senha == null || senha.trim().isEmpty()) ? existente.getSenha() : senha;

        if (tipo == null) {
            tipo = existente.getTipo();
        }

        Usuario usuarioAtualizado = new Usuario(cpfCnpj, nome, email, senhaFinal, contato, endereco, tipo);
        usuarioDAO.atualizar(usuarioAtualizado);

        // Atualiza sessão se o próprio usuário editou
        if (logado != null && logado.getCpfCnpj().equals(cpfCnpj)) {
            session.setAttribute("usuarioLogado", usuarioAtualizado);
        }

        response.sendRedirect(logado.getTipo() == TipoUsuario.ADMIN ? 
            "pages/admin/usuarios.jsp" : "pages/usuario/dashboard.jsp");
    }

    private void deletarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String cpfCnpj = request.getParameter("cpfCnpj");

        HttpSession session = request.getSession(false);
        Usuario logado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        // Usuário normal só pode deletar a si mesmo (se permitido)
        if (logado == null || logado.getTipo() != TipoUsuario.ADMIN) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }

        usuarioDAO.excluir(cpfCnpj);
        response.sendRedirect("pages/admin/usuarios.jsp");
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Usuario> listaUsuarios = usuarioDAO.listarTodos();
        request.setAttribute("listaUsuarios", listaUsuarios);

        HttpSession session = request.getSession(false);
        Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

        String jsp;
        if (usuarioLogado != null && usuarioLogado.getTipo() == TipoUsuario.ADMIN) {
            jsp = "pages/admin/usuarios.jsp";
        } else {
            jsp = "pages/listaUsuarios.jsp";
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(jsp);
        dispatcher.forward(request, response);
    }

    private void buscarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String cpfCnpj = request.getParameter("cpfCnpj");
        Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);

        if (usuario == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Usuário não encontrado.'); window.location.href='pages/admin/usuarios.jsp';</script>");
            out.close();
        } else {
            request.setAttribute("usuario", usuario);

            HttpSession session = request.getSession(false);
            Usuario logado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

            String jsp = (logado != null && logado.getTipo() == TipoUsuario.ADMIN) ? 
                "pages/admin/usuarioDetalhes.jsp" : "pages/usuarioDetalhes.jsp";

            RequestDispatcher dispatcher = request.getRequestDispatcher(jsp);
            dispatcher.forward(request, response);
        }
    }

    // ================== LOGIN / LOGOUT ===================

    private void login(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String cpfCnpj = request.getParameter("cpfCnpj").replaceAll("\\D", ""); 
        String senha = request.getParameter("senha");

        Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);

        if (usuario != null && usuario.getSenha().equals(senha)) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", usuario);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("erroLogin", "CPF/CNPJ ou senha inválidos");
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/usuario/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false); 
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("index.jsp");
    }
}
