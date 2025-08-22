package br.com.monesol.dao;

import br.com.monesol.model.Contrato;
import br.com.monesol.model.Documento;
import br.com.monesol.model.Documento.TipoDocumento;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentoDAO {

    public void cadastrar(Documento documento) throws SQLException {
        String sql = "INSERT INTO Documento (tipo, descricao, dataDocumento, arquivo, contrato) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, documento.getTipo().name());
            stmt.setString(2, documento.getDescricao());
            stmt.setTimestamp(3, Timestamp.valueOf(documento.getDataDocumento()));
            stmt.setString(4, documento.getArquivo());
            stmt.setInt(5, documento.getContrato().getId());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                documento.setId(rs.getInt(1));
            }
            stmt.close();
        }
    }

    public Documento buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM Documento WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Contrato contrato = new Contrato();
                contrato.setId(rs.getInt("contrato"));

                Documento doc = new Documento(
                    TipoDocumento.valueOf(rs.getString("tipo")),
                    rs.getString("descricao"),
                    rs.getTimestamp("dataDocumento").toLocalDateTime(),
                    rs.getString("arquivo"),
                    contrato
                );
                doc.setId(rs.getInt("id"));
                return doc;
            }
            stmt.close();
        }
        

        return null;
    }

    public List<Documento> listarPorContrato(int idContrato) throws SQLException {
        String sql = "SELECT * FROM Documento WHERE contrato = ? ORDER BY dataDocumento DESC";
        List<Documento> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idContrato);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = new Contrato();
                contrato.setId(idContrato);

                Documento doc = new Documento(
                    TipoDocumento.valueOf(rs.getString("tipo")),
                    rs.getString("descricao"),
                    rs.getTimestamp("dataDocumento").toLocalDateTime(),
                    rs.getString("arquivo"),
                    contrato
                );
                doc.setId(rs.getInt("id"));

                lista.add(doc);
            }
            stmt.close();
        }

        return lista;
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM Documento WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
            stmt.close();
        }
    }

    public void atualizar(Documento doc) throws SQLException {
        String sql = "UPDATE Documento SET tipo = ?, descricao = ?, dataDocumento = ?, arquivo = ?, contrato = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, doc.getTipo().name());
            stmt.setString(2, doc.getDescricao());
            stmt.setTimestamp(3, Timestamp.valueOf(doc.getDataDocumento()));
            stmt.setString(4, doc.getArquivo());
            stmt.setInt(5, doc.getContrato().getId());
            stmt.setInt(6, doc.getId());

            stmt.executeUpdate();
            stmt.close();
        }
    }


}
