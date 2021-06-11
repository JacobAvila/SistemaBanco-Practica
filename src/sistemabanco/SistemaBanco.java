package sistemabanco;

import java.sql.*;

public class SistemaBanco {

    
    public static void main(String[] args) {
        try{
            //1. Cargar el Driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            //2. Establecer la conexión con la BD
            String url = "jdbc:sqlserver://localhost:1433;databaseName=banco";
            Connection con = DriverManager.getConnection(url, "sa", "sasa");
            //3. Crear una sentencia
            Statement st = con.createStatement();
            //4. Ejecutar una Consulta
            String consulta = "SELECT * FROM Clientes";
            ResultSet rs = st.executeQuery(consulta);
            //5. Manipular los resultados
            while(rs.next()){
                String rfc = rs.getString("rfc");
                String nombre = rs.getString("nombre");
                int cuentas = rs.getInt("cuentas");
                System.out.println(rfc + " " + nombre + " " + cuentas);
            }
            System.out.println("============================================");
            //Opción de PrepareStatement
            String consulta2 = "SELECT * FROM Clientes Where cuentas > ?";
            PreparedStatement ps = con.prepareStatement(consulta2);
            int cantidadCuentas = 2;
            ps.setInt(1, cantidadCuentas);
            ResultSet rs2 = ps.executeQuery();
            while(rs2.next()){
                String rfc = rs2.getString("rfc");
                String nombre = rs2.getString("nombre");
                int cuentas = rs2.getInt("cuentas");
                System.out.println(rfc + " " + nombre + " " + cuentas);
            }
            System.out.println("============================================");
            //Opción para Ejecución de un Procedimiento Almacenado
            int no_cuenta = 6;
            double monto = 4000.0;
            CallableStatement cs = con.prepareCall("{call sp_movimiento(?, ?)}");
            cs.setInt(1, no_cuenta);
            cs.setDouble(2, monto);
            cs.execute();
            System.out.println("Se depositaron 4,000 en la cuenta 6");
            
            
            //6. Cerrar la conexión
            con.close();;
            
        }
        catch(ClassNotFoundException e){
            e.printStackTrace();
        }
        catch(SQLException e){
            e.printStackTrace();
        }
    }
    
}
