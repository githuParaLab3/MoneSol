package br.com.monesol.dao;

import br.com.monesol.model.Usuario;
import br.com.monesol.model.Usuario.TipoUsuario;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO {

    public void cadastrar(Usuario usuario) throws SQLException {
        String sql = "INSERT INTO Usuario (cpfCnpj, nome, email, senha, contato, endereco, tipo) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getCpfCnpj());
            stmt.setString(2, usuario.getNome());
            stmt.setString(3, usuario.getEmail());
            stmt.setString(4, usuario.getSenha());
            stmt.setString(5, usuario.getContato());
            stmt.setString(6, usuario.getEndereco());
            stmt.setString(7, usuario.getTipo().name()); 

            stmt.executeUpdate();
            
            stmt.close();
        }
        
    }

    public Usuario buscarPorCpfCnpj(String cpfCnpj) throws SQLException {
        String sql = "SELECT * FROM Usuario WHERE cpfCnpj = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpj);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Usuario(
                        rs.getString("cpfCnpj"),
                        rs.getString("nome"),
                        rs.getString("email"),
                        rs.getString("senha"),
                        rs.getString("contato"),
                        rs.getString("endereco"),
                        TipoUsuario.valueOf(rs.getString("tipo")) 
                    );
                }
            }
            stmt.close();
        }

        return null;
    }

    public List<Usuario> listarTodos() throws SQLException {
        List<Usuario> lista = new ArrayList<>();
        String sql = "SELECT * FROM Usuario";

        try (Connection conn = Conexao.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Usuario usuario = new Usuario(
                    rs.getString("cpfCnpj"),
                    rs.getString("nome"),
                    rs.getString("email"),
                    rs.getString("senha"),
                    rs.getString("contato"),
                    rs.getString("endereco"),
                    TipoUsuario.valueOf(rs.getString("tipo"))
                );
                lista.add(usuario);
            }
            
            stmt.close();
        }

        return lista;
    }

    public void atualizar(Usuario usuario) throws SQLException {
        String sql = "UPDATE Usuario SET nome = ?, email = ?, senha = ?, contato = ?, endereco = ?, tipo = ? WHERE cpfCnpj = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getSenha());
            stmt.setString(4, usuario.getContato());
            stmt.setString(5, usuario.getEndereco());
            stmt.setString(6, usuario.getTipo().name());
            stmt.setString(7, usuario.getCpfCnpj());

            stmt.executeUpdate();
            stmt.close();
        }
    }

    public void excluir(String cpfCnpj) throws SQLException {
        String sql = "DELETE FROM Usuario WHERE cpfCnpj = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpj);
            stmt.executeUpdate();
            stmt.close();
        }
    }
}
