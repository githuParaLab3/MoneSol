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
        request.setCharacterEncoding("UTF-8");
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
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        try {
            switch (action) {
                case "adicionar":
                    adicionarUsuario(request, response);
                    break;
                case "adminAdicionar":
                    adminAdicionarUsuario(request, response);
                    break;
                case "editar":
                    // A flag 'false' indica que a edição não é feita por um admin
                    editarUsuario(request, response, false);
                    break;
                // AÇÃO ADICIONADA PARA LIDAR COM A EDIÇÃO DO ADMIN
                case "adminEditar":
                    // A flag 'true' indica que a edição é feita por um admin
                    editarUsuario(request, response, true);
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

    private void adminAdicionarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        // ... (o seu código deste método permanece inalterado)
        String cpfCnpjRaw = request.getParameter("cpfCnpj");
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String contato = request.getParameter("contato");
        String endereco = request.getParameter("endereco");
        String tipoStr = request.getParameter("tipo");
        
        String redirectPathOnError = request.getContextPath() + "/pages/admin/criarUsuario.jsp";

        try {
            if (cpfCnpjRaw == null || cpfCnpjRaw.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "CPF/CNPJ é obrigatório.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            String cpfCnpj = cpfCnpjRaw.replaceAll("\\D", "");
            if (cpfCnpj.length() != 11 && cpfCnpj.length() != 14) {
                request.getSession().setAttribute("mensagemErro", "CPF deve ter 11 dígitos e CNPJ deve ter 14 dígitos.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            Usuario usuarioExistente = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
            if (usuarioExistente != null) {
                request.getSession().setAttribute("mensagemErro", "Usuário com este CPF/CNPJ já está cadastrado.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            if (nome == null || nome.trim().isEmpty() || email == null || email.trim().isEmpty() || senha == null || senha.trim().isEmpty() || tipoStr == null || tipoStr.isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "Nome, email, senha e tipo são obrigatórios.");
                response.sendRedirect(redirectPathOnError);
                return;
            }
            
            if (senha.length() < 6) {
                request.getSession().setAttribute("mensagemErro", "Senha deve ter pelo menos 6 caracteres.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            TipoUsuario tipoFinal;
            try {
                tipoFinal = TipoUsuario.valueOf(tipoStr);
            } catch (IllegalArgumentException e) {
                request.getSession().setAttribute("mensagemErro", "Tipo de usuário inválido.");
                response.sendRedirect(redirectPathOnError);
                return;
            }
            
            Usuario novoUsuario = new Usuario(cpfCnpj, nome, email, senha, contato, endereco, tipoFinal);
            usuarioDAO.cadastrar(novoUsuario);
            
            request.getSession().setAttribute("mensagemSucesso", "Usuário '" + nome + "' criado com sucesso!");
            response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao criar usuário: " + e.getMessage());
            response.sendRedirect(redirectPathOnError);
        }
    }

    private void adicionarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        // ... (o seu código deste método permanece inalterado)
        String cpfCnpjRaw = request.getParameter("cpfCnpj");
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String contato = request.getParameter("contato");
        String endereco = request.getParameter("endereco");
        String tipoStr = request.getParameter("tipo");
        
        String redirectPathOnError = request.getContextPath() + "/pages/usuario/cadastro.jsp";

        try {
            if (cpfCnpjRaw == null || cpfCnpjRaw.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "CPF/CNPJ é obrigatório.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            String cpfCnpj = cpfCnpjRaw.replaceAll("\\D", "");
            if (cpfCnpj.length() != 11 && cpfCnpj.length() != 14) {
                request.getSession().setAttribute("mensagemErro", "CPF deve ter 11 dígitos e CNPJ deve ter 14 dígitos.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            Usuario usuarioExistente = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
            if (usuarioExistente != null) {
                request.getSession().setAttribute("mensagemErro", "Usuário com este CPF/CNPJ já está cadastrado.");
                response.sendRedirect(redirectPathOnError);
                return;
            }

            if (nome == null || nome.trim().isEmpty() || email == null || email.trim().isEmpty() || senha == null || senha.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", "Nome, email e senha são obrigatórios.");
                response.sendRedirect(redirectPathOnError);
                return;
            }
            
            if (senha.length() < 6) {
                request.getSession().setAttribute("mensagemErro", "Senha deve ter pelo menos 6 caracteres.");
                response.sendRedirect(redirectPathOnError);
                return;
            }
            
            TipoUsuario tipoFinal = TipoUsuario.CONSUMIDOR_PARCEIRO; // Padrão
            if (tipoStr != null) {
                try {
                    TipoUsuario tipoTemp = TipoUsuario.valueOf(tipoStr);
                    if (tipoTemp == TipoUsuario.DONO_GERADORA || tipoTemp == TipoUsuario.CONSUMIDOR_PARCEIRO) {
                        tipoFinal = tipoTemp;
                    }
                } catch (IllegalArgumentException e) { /* Mantém o padrão */ }
            }
            
            Usuario novoUsuario = new Usuario(cpfCnpj, nome, email, senha, contato, endereco, tipoFinal);
            usuarioDAO.cadastrar(novoUsuario);

            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("usuarioLogado", novoUsuario);
            newSession.setAttribute("mensagemSucesso", "Cadastro realizado com sucesso! Bem-vindo(a), " + nome + "!");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            
        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", "Erro ao cadastrar usuário: " + e.getMessage());
            response.sendRedirect(redirectPathOnError);
        }
    }
    
    // MÉTODO UNIFICADO E CORRIGIDO
    private void editarUsuario(HttpServletRequest request, HttpServletResponse response, boolean isAdmin) throws SQLException, IOException {
        HttpSession session = request.getSession();
        try {
            String cpfCnpj = request.getParameter("cpfCnpj");
            if (cpfCnpj == null || cpfCnpj.trim().isEmpty()) {
                session.setAttribute("mensagemErro", "CPF/CNPJ não informado para edição.");
                response.sendRedirect(request.getContextPath() + (isAdmin ? "/pages/admin/gerenciarUsuarios.jsp" : "/pages/usuario/dashboard.jsp"));
                return;
            }

            Usuario existente = usuarioDAO.buscarPorCpfCnpj(cpfCnpj.replaceAll("\\D", ""));
            if (existente == null) {
                session.setAttribute("mensagemErro", "Utilizador não encontrado (CPF/CNPJ: " + cpfCnpj + ").");
                response.sendRedirect(request.getContextPath() + (isAdmin ? "/pages/admin/gerenciarUsuarios.jsp" : "/pages/usuario/dashboard.jsp"));
                return;
            }

            String nome = request.getParameter("nome");
            String email = request.getParameter("email");
            String senha = request.getParameter("senha");
            String contato = request.getParameter("contato");
            String endereco = request.getParameter("endereco");

            existente.setNome(nome);
            existente.setEmail(email);
            existente.setContato(contato);
            existente.setEndereco(endereco);

            if (senha != null && !senha.trim().isEmpty()) {
                existente.setSenha(senha);
            }

            if (isAdmin) {
                String tipoStr = request.getParameter("tipo");
                existente.setTipo(TipoUsuario.valueOf(tipoStr));
            }

            usuarioDAO.atualizar(existente);

            // Se o utilizador editou o seu próprio perfil, atualiza a sessão
            Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
            if (logado != null && logado.getCpfCnpj().equals(existente.getCpfCnpj())) {
                session.setAttribute("usuarioLogado", existente);
            }
            
            session.setAttribute("mensagemSucesso", "Perfil de " + nome + " atualizado com sucesso!");
            
            // REDIRECIONAMENTO CORRIGIDO
            if (isAdmin) {
                response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
            }

        } catch (Exception e) {
            session.setAttribute("mensagemErro", "Erro ao editar utilizador: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
        }
    }


    private void deletarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        // ... (o seu código deste método permanece inalterado)
        try {
            String cpfCnpj = request.getParameter("cpfCnpj");
            if (cpfCnpj == null || cpfCnpj.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF/CNPJ não informado para exclusão.");
                response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
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

            Usuario usuarioParaExcluir = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
            if (usuarioParaExcluir == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Usuário não encontrado (CPF/CNPJ: " + cpfCnpj + ").");
                response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
                return;
            }

            if (logado.getCpfCnpj().equals(cpfCnpj)) {
                request.getSession().setAttribute("mensagemErro", 
                    "Você não pode excluir sua própria conta.");
                response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
                return;
            }

            String nomeExcluido = usuarioParaExcluir.getNome();
            usuarioDAO.excluir(cpfCnpj);

            request.getSession().setAttribute("mensagemSucesso", 
                "Usuário " + nomeExcluido + " (CPF/CNPJ: " + cpfCnpj + ") excluído com sucesso!");

            response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao excluir usuário: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
        }
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        // ... (o seu código deste método permanece inalterado)
        try {
            List<Usuario> listaUsuarios = usuarioDAO.listarTodos();

            if (listaUsuarios.isEmpty()) {
                request.setAttribute("mensagemInfo", 
                    "Nenhum usuário cadastrado no sistema.");
            } 
            
            request.setAttribute("listaUsuarios", listaUsuarios);

            HttpSession session = request.getSession(false);
            Usuario usuarioLogado = (session != null) ? (Usuario) session.getAttribute("usuarioLogado") : null;

            String jsp;
            if (usuarioLogado != null && usuarioLogado.getTipo() == TipoUsuario.ADMIN) {
                jsp = "/pages/admin/gerenciarUsuarios.jsp";
            } else {
                jsp = "/pages/usuario/dashboard.jsp"; 
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
        // ... (o seu código deste método permanece inalterado)
        try {
            String cpfCnpj = request.getParameter("cpfCnpj");
            if (cpfCnpj == null || cpfCnpj.trim().isEmpty()) {
                request.getSession().setAttribute("mensagemErro", 
                    "CPF/CNPJ não informado para busca.");
                response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
                return;
            }

            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpj.replaceAll("\\D", ""));

            if (usuario == null) {
                request.getSession().setAttribute("mensagemErro", 
                    "Usuário não encontrado para CPF/CNPJ: " + cpfCnpj);
                response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
                return;
            }

            request.setAttribute("usuario", usuario);
            
             RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/usuario/editarUsuario.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            request.getSession().setAttribute("mensagemErro", 
                "Erro ao buscar usuário: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pages/admin/gerenciarUsuarios.jsp");
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        // ... (o seu código deste método permanece inalterado)
        try {
            String cpfCnpjRaw = request.getParameter("cpfCnpj");
            String senha = request.getParameter("senha");

            if (cpfCnpjRaw == null || cpfCnpjRaw.trim().isEmpty()) {
                request.setAttribute("erroLogin", "CPF/CNPJ é obrigatório");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/usuario/login.jsp");
                dispatcher.forward(request, response);
                return;
            }

            if (senha == null || senha.trim().isEmpty()) {
                request.setAttribute("erroLogin", "Senha é obrigatória");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/usuario/login.jsp");
                dispatcher.forward(request, response);
                return;
            }

            String cpfCnpj = cpfCnpjRaw.replaceAll("\\D", "");
            Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);

            if (usuario != null && usuario.getSenha().equals(senha)) {
                HttpSession session = request.getSession();
                session.setAttribute("usuarioLogado", usuario);
                
                if(usuario.getTipo() == TipoUsuario.ADMIN) {
                	 response.sendRedirect(request.getContextPath() + "/pages/admin/dashboardAdmin.jsp");
                } else {
                	response.sendRedirect(request.getContextPath() + "/pages/usuario/dashboard.jsp");
                }
               
            } else {
                request.setAttribute("erroLogin", "CPF/CNPJ ou senha inválidos");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/usuario/login.jsp");
                dispatcher.forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("erroLogin", "Erro interno: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/usuario/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    private void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // ... (o seu código deste método permanece inalterado)
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
                
                HttpSession novaSessao = request.getSession();
                novaSessao.setAttribute("mensagemInfo", "Logout realizado com sucesso!");
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
