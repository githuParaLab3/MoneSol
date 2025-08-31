package br.com.monesol.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexao {
    private static final String URL = "jdbc:mysql://localhost:3306/monesol";
    private static final String USUARIO = "root";
    private static final String SENHA = "12345";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(URL, USUARIO, SENHA);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Erro na conexão com o banco de dados", e);
        }
    }
   
    public static void main(String[] args) {
        try {
            Connection conexao = getConnection();
            if (conexao != null) {
                System.out.println("Conexão bem-sucedida!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}