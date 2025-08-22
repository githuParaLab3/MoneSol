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

    private void adicionarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
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
            } catch (IllegalArgumentException e) {
            }
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

        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String contato = request.getParameter("contato");
        String endereco = request.getParameter("endereco");
        String tipoStr = request.getParameter("tipo");
        Usuario.TipoUsuario tipo = null;
        if (tipoStr != null && !tipoStr.isBlank()) {
            try {
                tipo = Usuario.TipoUsuario.valueOf(tipoStr);
            } catch (IllegalArgumentException e) {
            }
        }

        Usuario existente = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);
        if (existente == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('Usuário não encontrado.'); window.location.href='pages/usuario/dashboard.jsp';</script>");
            out.close();
            return;
        }

        String senhaFinal = (senha == null || senha.trim().isEmpty()) ? existente.getSenha() : senha;
        if (tipo == null) {
            tipo = existente.getTipo();
        }

        Usuario usuarioAtualizado = new Usuario(cpfCnpj, nome, email, senhaFinal, contato, endereco, tipo);
        usuarioDAO.atualizar(usuarioAtualizado);

        HttpSession session = request.getSession(false);
        if (session != null) {
            Usuario logado = (Usuario) session.getAttribute("usuarioLogado");
            if (logado != null && logado.getCpfCnpj().replaceAll("\\D", "").equals(cpfCnpj)) {
                session.setAttribute("usuarioLogado", usuarioAtualizado);
            }
        }

        response.sendRedirect("pages/usuario/dashboard.jsp");
    }



    private void deletarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String cpfCnpj = request.getParameter("cpfCnpj");
        usuarioDAO.excluir(cpfCnpj);
        response.sendRedirect("pages/listaUsuarios.jsp");
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Usuario> listaUsuarios = usuarioDAO.listarTodos();

        if (listaUsuarios == null || listaUsuarios.isEmpty()) {
            System.out.println("A lista de usuários está vazia ou nula.");
        } else {
            System.out.println("Lista de Usuários Obtida:");
            for (Usuario u : listaUsuarios) {
                System.out.println("CPF/CNPJ: " + u.getCpfCnpj() + ", Nome: " + u.getNome() + ", Email: " + u.getEmail());
            }
        }

        request.setAttribute("listaUsuarios", listaUsuarios);
        RequestDispatcher dispatcher = request.getRequestDispatcher("pages/listaUsuarios.jsp");
        dispatcher.forward(request, response);
    }

    private void buscarUsuario(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String cpfCnpj = request.getParameter("cpfCnpj");
        Usuario usuario = usuarioDAO.buscarPorCpfCnpj(cpfCnpj);

        if (usuario == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script type='text/javascript'>");
            out.println("alert('Usuário não encontrado para CPF/CNPJ: " + cpfCnpj + "');");
            out.println("window.location.href = 'pages/listaUsuarios.jsp';");
            out.println("</script>");
            out.close();
        } else {
            request.setAttribute("usuario", usuario);
            RequestDispatcher dispatcher = request.getRequestDispatcher("pages/usuarioDetalhes.jsp");
            dispatcher.forward(request, response);
        }
    }
    
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
