package br.com.monesol.dao;

import br.com.monesol.model.Contrato;
import br.com.monesol.model.Contrato.StatusContrato;
import br.com.monesol.model.UnidadeGeradora;
import br.com.monesol.model.Usuario;
import br.com.monesol.util.Conexao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ContratoDAO {

    public void cadastrar(Contrato contrato) throws SQLException {
        String sql = "INSERT INTO Contrato (statusContrato, vigenciaInicio, vigenciaFim, reajustePeriodico, observacoes, regrasExcecoes, quantidadecontratada, unidadeGeradora, usuario) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, contrato.getStatusContrato().name());
            stmt.setDate(2, Date.valueOf(contrato.getVigenciaInicio()));
            stmt.setDate(3, Date.valueOf(contrato.getVigenciaFim()));
            stmt.setInt(4, contrato.getReajustePeriodico());
            stmt.setString(5, contrato.getObservacoes());
            stmt.setString(6, contrato.getRegrasExcecoes());
            stmt.setDouble(7, contrato.getQuantidadeContratada());
            stmt.setInt(8, contrato.getUnidadeGeradora().getId());
            stmt.setString(9, contrato.getUsuario().getCpfCnpj());

            stmt.executeUpdate();

            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                contrato.setId(rs.getInt(1));
            }
        }
    }

    public Contrato buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM Contrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                contrato.setId(id);
                return contrato;
            }
        }

        return null;
    }

    public List<Contrato> listarPorUsuario(String cpfCnpj) throws SQLException {
        String sql = "SELECT * FROM Contrato WHERE usuario = ?";
        List<Contrato> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpj);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                contrato.setId(rs.getInt("id"));
                lista.add(contrato);
            }
        }

        return lista;
    }

    public List<Contrato> listarPorUnidade(int idUnidade) throws SQLException {
        String sql = "SELECT * FROM Contrato WHERE unidadeGeradora = ?";
        List<Contrato> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, idUnidade);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                contrato.setId(rs.getInt("id"));
                lista.add(contrato);
            }
        }

        return lista;
    }

    public void atualizar(Contrato contrato) throws SQLException {
        String sql = "UPDATE Contrato SET statusContrato = ?, vigenciaInicio = ?, vigenciaFim = ?, reajustePeriodico = ?, observacoes = ?, regrasExcecoes = ?, quantidadecontratada = ?, unidadeGeradora = ?, usuario = ? WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, contrato.getStatusContrato().name());
            stmt.setDate(2, Date.valueOf(contrato.getVigenciaInicio()));
            stmt.setDate(3, Date.valueOf(contrato.getVigenciaFim()));
            stmt.setInt(4, contrato.getReajustePeriodico());
            stmt.setString(5, contrato.getObservacoes());
            stmt.setString(6, contrato.getRegrasExcecoes());
            stmt.setDouble(7, contrato.getQuantidadeContratada());
            stmt.setInt(8, contrato.getUnidadeGeradora().getId());
            stmt.setString(9, contrato.getUsuario().getCpfCnpj());
            stmt.setInt(10, contrato.getId());

            stmt.executeUpdate();
        }
    }

    public void excluir(int id) throws SQLException {
        String sql = "DELETE FROM Contrato WHERE id = ?";

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
    }

    private Contrato preencherContrato(ResultSet rs) throws SQLException {
        UnidadeGeradora unidade = new UnidadeGeradora("", 0.0, 0.0, "", 0.0, 0.0);
        unidade.setId(rs.getInt("unidadeGeradora"));

        Usuario usuario = new Usuario(null, null, null, null, null, null, null);
        usuario.setCpfCnpj(rs.getString("usuario"));

        Contrato contrato = new Contrato();
        contrato.setStatusContrato(StatusContrato.valueOf(rs.getString("statusContrato")));
        contrato.setVigenciaInicio(rs.getDate("vigenciaInicio").toLocalDate());
        contrato.setVigenciaFim(rs.getDate("vigenciaFim").toLocalDate());
        contrato.setReajustePeriodico(rs.getInt("reajustePeriodico"));
        contrato.setObservacoes(rs.getString("observacoes"));
        contrato.setRegrasExcecoes(rs.getString("regrasExcecoes"));
        contrato.setQuantidadeContratada(rs.getDouble("quantidadecontratada"));
        contrato.setUnidadeGeradora(unidade);
        contrato.setUsuario(usuario);

        return contrato;
    }
    
    public boolean existeContratoUsuarioUnidade(String cpfCnpj, int idUnidade) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Contrato WHERE usuario = ? AND unidadeGeradora = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpj);
            stmt.setInt(2, idUnidade);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    public void atualizarStatus(int idContrato, StatusContrato novoStatus) throws SQLException {
        String sql = "UPDATE Contrato SET statusContrato = ? WHERE id = ?";
        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoStatus.name());
            stmt.setInt(2, idContrato);
            stmt.executeUpdate();
        }
    }
    
    public List<Contrato> listarPorDonoGeradora(String cpfCnpjDono) throws SQLException {
        String sql = "SELECT c.* FROM Contrato c " +
                     "JOIN UnidadeGeradora u ON c.unidadeGeradora = u.id " +
                     "WHERE u.usuario = ?";
        List<Contrato> lista = new ArrayList<>();

        try (Connection conn = Conexao.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, cpfCnpjDono);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Contrato contrato = preencherContrato(rs);
                contrato.setId(rs.getInt("id"));
                lista.add(contrato);
            }
        }
        return lista;
    }

}
