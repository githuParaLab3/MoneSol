package br.com.monesol.controller;

import br.com.monesol.dao.UsuarioDAO;
import br.com.monesol.model.Usuario;
import br.com.monesol.model.Usuario.TipoUsuario;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
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
                    request.getSession().setAttribute("mensagemInfo", 
                        "Ação não reconhecida, redirecionando para lista de usuários.");
                    listarUsuarios(request, response);
                    break;
            }
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro interno do sistema: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void adicionarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            String cpfCnpjRaw = request.getParameter("cpfCnpj");
            if (cpfCnpjRaw == null || cpfCnpjRaw.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF/CNPJ é obrigatório.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            String cpfCnpj = cpfCnpjRaw.replaceAll("\\D", "");
            if (cpfCnpj.length() != 11 && cpfCnpj.length() != 14) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF deve ter 11 dígitos e CNPJ deve ter 14 dígitos.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            // Verificar se usuário já existe
            Usuario usuarioExistente = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
            if (usuarioExistente != null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Usuário com este CPF/CNPJ já está cadastrado.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            String nome = request.getParameter("nome");
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");
            String contato = request.getParameter("contato");
            String endereco = request.getParameter("endereco");
            String tipoStr = request.getParameter("tipo");

            // Validar campos obrigatórios
            if (nome == null || nome.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "Nome é obrigatório.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "Email é obrigatório.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            if (senha == null || senha.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "Senha é obrigatória.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            // Validar email
            if (!email.matches("^[\\w\\.-]+@[\\w\\.-]+\\.[a-zA-Z]{2,}$")) {
                request.getSession().setAttribute("mensagemErro", 
                    "Formato de email inválido.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            // Validar senha (mínimo 6 caracteres)
            if (senha.length() < 6) {
                request.getSession().setAttribute("mensagemErro", 
                    "Senha deve ter pelo menos 6 caracteres.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
                return;
            }

            TipoUsuario tipo = TipoUsuario.CONSUMIDOR_PARCEIRO; // padrão
            if (tipoStr != null && !tipoStr.isEmpty()) {
                try {
                    TipoUsuario tipoTemp = TipoUsuario.valueOf(tipoStr);
                    if (tipoTemp == TipoUsuario.DONO_GERADORA || tipoTemp == TipoUsuario.CONSUMIDOR_PARCEIRO) {
                        tipo = tipoTemp;
                    }
                } catch (IllegalArgumentException e) {
                    // Mantém o tipo padrão
                }
            }

            Usuario usuario = new Usuario(cpfCnpj, nome, email, senha, contato, endereco, tipo);
            usuarioDAO.cadastrar(usuario);

            HttpSession session = request.getSession(true);
            session.setAttribute("usuarioLogado", usuario);
            session.setAttribute("mensagemSucesso", 
                "Cadastro realizado com sucesso! Bem-vindo(a), " + nome + "!");

            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao cadastrar usuário: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/cadastro.jsp");
        }
    }

    private void editarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            String cpfCnpjRaw = request.getParameter("cpfCnpj");
            String cpfCnpj = (cpfCnpjRaw != null) ? cpfCnpjRaw.replaceAll("\\D", "") : "";

            if (cpfCnpj.isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF/CNPJ não informado para edição.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            HttpSession session = request.getSession(false);
            Usuario logado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

            if (logado == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Usuário não logado. Faça login para continuar.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/login.jsp");
                return;
            }

            // Verificar permissões
            if (logado.getTipo() != TipoUsuario.ADMIN && !logado.getCpfCnpj().equals(cpfCnpj)) {
                request.getSession().setAttribute("mensagemErro", 
                    "Você não tem permissão para editar este usuário.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            Usuario existente = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
            if (existente == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Usuário não encontrado (CPF/CNPJ: " + cpfCnpj + ").");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            String nome = request.getParameter("nome");
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");
            String contato = request.getParameter("contato");
            String endereco = request.getParameter("endereco");
            String tipoStr = request.getParameter("tipo");

            // Validar campos obrigatórios
            if (nome == null || nome.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "Nome é obrigatório.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/editarPerfil.jsp");
                return;
            }

            if (email == null || email.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "Email é obrigatório.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/editarPerfil.jsp");
                return;
            }

            // Validar email
            if (!email.matches("^[\\w\\.-]+@[\\w\\.-]+\\.[a-zA-Z]{2,}$")) {
                request.getSession().setAttribute("mensagemErro", 
                    "Formato de email inválido.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/editarPerfil.jsp");
                return;
            }

            // Validar senha se foi fornecida
            String senhaFinal = existente.getSenha(); // mantém a antiga por padrão
            if (senha != null && !senha.trim().isEmpty()) {
                if (senha.length() < 6) {
                    request.getSession().setAttribute("mensagemErro", 
                        "Nova senha deve ter pelo menos 6 caracteres.");
                    response.sendRedirect(request.getContextPath() + "/pages/usuario/editarPerfil.jsp");
                    return;
                }
                senhaFinal = senha;
            }

            TipoUsuario tipo = existente.getTipo(); // mantém o tipo atual
            if (tipoStr != null && !tipoStr.trim().isEmpty() && logado.getTipo() == TipoUsuario.ADMIN) {
                try {
                    tipo = TipoUsuario.valueOf(tipoStr);
                } catch (IllegalArgumentException e) {
                    // Mantém o tipo atual
                }
            }

            Usuario usuarioAtualizado = new Usuario(cpfCnpj, nome, email, senhaFinal, contato, endereco, tipo);
            usuarioDAO.atualizar(usuarioAtualizado);

            // Atualizar sessão se o usuário editou seu próprio perfil
            if (logado.getCpfCnpj().equals(cpfCnpj)) {
                session.setAttribute("usuarioLogado", usuarioAtualizado);
            }

            request.getSession().setAttribute("mensagemSucesso", 
                "Perfil de " + nome + " atualizado com sucesso!");

            String redirectPath = logado.getTipo() == TipoUsuario.ADMIN ? 
                "/pages/admin/usuarios.jsp" : "/pages/usuario/dashboard.jsp";
            response.sendRedirect(request.getContextPath() + redirectPath);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao editar usuário: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void deletarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        try {
            String cpfCnpj = request.getParameter("cpfCnpj");
            if (cpfCnpj == null || cpfCnpj.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF/CNPJ não informado para exclusão.");
                response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");
                return;
            }

            HttpSession session = request.getSession(false);
            Usuario logado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

            if (logado == null || logado.getTipo() != TipoUsuario.ADMIN) {
                request.getSession().setAttribute("mensagemErro", 
                    "Apenas administradores podem excluir usuários.");
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                return;
            }

            // Verificar se usuário existe antes de excluir
            Usuario usuarioParaExcluir = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
            if (usuarioParaExcluir == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Usuário não encontrado (CPF/CNPJ: " + cpfCnpj + ").");
                response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");
                return;
            }

            // Impedir que admin exclua a si mesmo
            if (logado.getCpfCnpj().equals(cpfCnpj)) {
                request.getSession().setAttribute("mensagemErro", 
                    "Você não pode excluir sua própria conta.");
                response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");
                return;
            }

            String nomeExcluido = usuarioParaExcluir.getNome();
            usuarioDAO.excluir(cpfCnpj);

            request.getSession().setAttribute("mensagemSucesso", 
                "Usuário " + nomeExcluido + " (CPF/CNPJ: " + cpfCnpj + ") excluído com sucesso!");

            response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao excluir usuário: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");
        }
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            List<Usuario> listaUsuarios = usuarioDAO.listarTodos();

            if (listaUsuarios.isEmpty()) {
                request.getSession().setAttribute("mensagemInfo", 
                    "Nenhum usuário cadastrado no sistema.");
            } else {
                request.getSession().setAttribute("mensagemSucesso", 
                    "Encontrado(s) " + listaUsuarios.size() + " usuário(s) cadastrado(s).");
            }

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

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao listar usuários: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }

    private void buscarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        try {
            String cpfCnpj = request.getParameter("cpfCnpj");
            if (cpfCnpj == null || cpfCnpj.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF/CNPJ não informado para busca.");
                response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");
                return;
            }

            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpj.replaceAll("\\D", ""));

            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Usuário não encontrado para CPF/CNPJ: " + cpfCnpj);
                response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");
                return;
            }

            request.setAttribute("usuario", usuario);
            request.getSession().setAttribute("mensagemSucesso", 
                "Usuário " + usuario.getNome() + " encontrado com sucesso!");

            HttpSession session = request.getSession(false);
            Usuario logado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

            String jsp = (logado != null && logado.getTipo() == TipoUsuario.ADMIN) ? 
                "pages/admin/usuarioDetalhes.jsp" : "pages/usuarioDetalhes.jsp";

            RequestDispatcher dispatcher = request.getRequestDispatcher(jsp);
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar usuário: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/admin/usuarios.jsp");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        try {
            String cpfCnpjRaw = request.getParameter("cpfCnpj");
            String senha = request.getParameter("senha");

            if (cpfCnpjRaw == null || cpfCnpjRaw.trim().isEmpty()) {
                request.setAttribute("erroLogin", "CPF/CNPJ é obrigatório");
                RequestDispatcher dispatcher = request.getRequestDispatcher("pages/usuario/login.jsp");
                dispatcher.forward(request, response);
                return;
            }

            if (senha == null || senha.trim().isEmpty()) {
                request.setAttribute("erroLogin", "Senha é obrigatória");
                RequestDispatcher dispatcher = request.getRequestDispatcher("pages/usuario/login.jsp");
                dispatcher.forward(request, response);
                return;
            }

            String cpfCnpj = cpfCnpjRaw.replaceAll("\\D", "");
            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);

            if (usuario != null && usuario.getSenha().equals(senha)) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuario);
                session.setAttribute("mensagemSucesso", 
                    "Login realizado com sucesso! Bem-vindo(a), " + usuario.getNome() + "!");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            } else {
                request.setAttribute("erroLogin", "CPF/CNPJ ou senha inválidos");
                RequestDispatcher dispatcher = request.getRequestDispatcher("pages/usuario/login.jsp");
                dispatcher.forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("erroLogin", "Erro interno: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/usuario/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
                String nomeUsuario = usuarioLogado != null ? usuarioLogado.getNome() : "Usuário";
                session.invalidate();
                
                // Criar nova sessão para a mensagem de logout
                HttpSession novaSessao = request.getSession();
                novaSessao.setAttribute("mensagemInfo", 
                    "Logout realizado com sucesso! Até logo, " + nomeUsuario + "!");
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}