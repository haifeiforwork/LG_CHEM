/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �����                                                    */
/*   Program Name : �򰡻��� ��ȸ                                               */
/*   Program ID   : B01ValuateDetailDB                                          */
/*   Description  : �򰡰�� ��ȸ ������ �ִ����� ����                          */
/*   Note         : client�� ����� ehr.properties ������ ����                  */
/*                  PRD(165.244.234.69)�϶��� ����Ÿ�ҽ����� "jdbc/essDS"  ���� */
/*                  DEV(165.244.234.72)�϶��� ����Ÿ�ҽ����� "jdbc/hrisDS" ���� */
/*                  QAS(165.244.234.72)�϶��� ����Ÿ�ҽ����� "jdbc/hrisDS" ���� */
/*   Creation     : 2002-07-12  �赵��                                          */
/*   Update       : 2005-01-11  ������                                          */
/* 					2017-05-25   eunha    [CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ                                                                          */
/********************************************************************************/
package hris.B.db;

import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.db.JDFPreparedStatement;
import com.sns.jdf.db.JDFStatement;
import com.sns.jdf.util.DataUtil;
import hris.B.B01ValuateDBData;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.io.*;
import java.sql.*;
import java.util.Vector;

public class B01ValuateDetailDB {

    Connection conn = null;

    private DataSource ds = null;

    String user     = "";
    String password = "";
    String source   = ""; // ����Ÿ�ҽ��̸�
    String url   = ""; // local


    public B01ValuateDetailDB() throws GeneralException
    {
        try {
        Config conf   = new Configuration();
        source   = conf.getString("com.sns.jdf.EHRAPP.dbname");
        user     = conf.getString("com.sns.jdf.EHRAPP.webuser");
        password = conf.getString("com.sns.jdf.EHRAPP.passwd");
        url  = conf.get("com.sns.jdf.EHRAPP.url");  //local

        Logger.debug.println(this,  "##############B01ValuateDetailDB() : " + user);
            /*
            java.util.Hashtable props = new java.util.Hashtable();
            //props.put(Context.INITIAL_CONTEXT_FACTORY, "com.ibm.ejs.ns.jndi.CNInitialContextFactory");
            props.put(Context.INITIAL_CONTEXT_FACTORY, "jeus.jndi.JNSContextFactory");

            Logger.debug.println(this,  "##############B01ValuateDetailDB() : " +source );
            Context ctx = null;
*/
        Context ctx = null;
        try {
            //  ctx = new InitialContext(props);
            //  ds = (DataSource)ctx.lookup(source);

            //���ü������� ������
            ctx = new InitialContext();
            Context env = (Context)ctx.lookup("java:comp/env");
            ds = (DataSource)env.lookup("jdbc/HRESPoolDS");

        } finally {
            if ( ctx != null ) ctx.close();
        }
    } catch (Exception e) {
        Logger.debug.println(e.toString());
    }
}
    /*public B01ValuateDetailDB() throws GeneralException
    {
        try {
            Config conf   = new Configuration();
            source   = conf.getString("com.sns.jdf.EHRAPP.dbname");
            user     = conf.getString("com.sns.jdf.EHRAPP.webuser");
            password = conf.getString("com.sns.jdf.EHRAPP.passwd");

            Logger.debug.println(this,  "##############B01ValuateDetailDB() : " + user);
            java.util.Hashtable props = new java.util.Hashtable();
            //props.put(Context.INITIAL_CONTEXT_FACTORY, "com.ibm.ejs.ns.jndi.CNInitialContextFactory");
            props.put(Context.INITIAL_CONTEXT_FACTORY, "jeus.jndi.JNSContextFactory");

            Logger.debug.println(this,  "##############B01ValuateDetailDB() : " +source );
            Context ctx = null;

            try {
                ctx = new InitialContext(props);
                ds = (DataSource)ctx.lookup(source);
            } finally {
                if ( ctx != null ) ctx.close();
            }
        } catch (Exception e) {
            Logger.debug.println(e.toString());
        }
    }*/

    /**
     * �򰡰�� ��ȸ ������ �ִ����� ���� ��ȸ
     * @param hris.B.B01ValuateDBData
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<B01ValuateDBData> getDetail(String empno) throws GeneralException
    {
        Statement        stmt                = null;
        ResultSet        rs                  = null;
        Vector           B01ValuateDBData_vt = new Vector();
        PreparedStatement pstmt = null; //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ
        try{

        	//�
            //conn = ds.getConnection(user, password);

        	//local
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            empno = DataUtil.fixEndZero(empno, 8);

            StringBuffer query = new StringBuffer();
            query.append("  select APYEAR EVAL_YEAR, 'Y' EVAL_YORN        ");
            query.append("    from APP2000                                ");
           ////[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
            // query.append("   where NAPEMPID  = '" + empno + "'            ");
            query.append("   where NAPEMPID  = ?			           ");
          //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end
            query.append("   order by APYEAR desc                         ");

           //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ start
            //stmt = conn.createStatement();
            //JDFStatement jdfStmt = new JDFStatement(this, stmt);
            //rs = jdfStmt.executeQuery(query.toString());
            pstmt = conn.prepareStatement(query.toString());
            pstmt.setString( 1, empno );
            JDFPreparedStatement jdfPstmt = new JDFPreparedStatement(this, query.toString(), pstmt);
            rs = jdfPstmt.executeQuery();
          //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end


            while( rs.next() ){
                B01ValuateDBData data                = new B01ValuateDBData();

                data.EVAL_YEAR             = rs.getString("EVAL_YEAR");
                data.EVAL_YORN             = rs.getString("EVAL_YORN");

                B01ValuateDBData_vt.addElement(data);
            }

        } catch( Exception e ){
            throw new GeneralException(e);
        } finally {
            DBUtil.close(rs, stmt);
            DBUtil.close(conn);
        }
        return B01ValuateDBData_vt;
    }

    /**
     * �򰡳⵵ - �򰡰���� �򰡳⵵ ������ �͸� �����ش�.
     * @param hris.B.B01ValuateDBData
     * @exception com.sns.jdf.GeneralException
     */
    public String getYEAR() throws GeneralException {
        String year = "";
        Statement        stmt                = null;
        ResultSet        rs                  = null;
        try{

            Logger.debug.println(this, "##############getYEAR()  url:"+url  );
            Logger.debug.println(this, "##############getYEAR()  start user:"+user+" , password" + password);
            //conn = ds.getConnection(user, password);

        	//local
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            Logger.debug.println(this,  "##############getYEAR() : " + conn);
            StringBuffer query = new StringBuffer();
            query.append("  SELECT MAX(APYEAR) CODE_NAME     ");
            query.append("    FROM APP1020                   ");
            query.append("   WHERE APSTEPCD = '70'	     ");

            stmt = conn.createStatement();
            JDFStatement jdfStmt = new JDFStatement(this, stmt);
            rs = jdfStmt.executeQuery(query.toString());

            while( rs.next() ){
                year = rs.getString("CODE_NAME");
            }

        } catch( Exception e ){
            throw new GeneralException(e);
        } finally {
            DBUtil.close(rs, stmt);
            DBUtil.close(conn);
        }
        return year;
    }

    /**
     * �򰡱Ⱓ - �򰡰���� �򰡰����ȸ����(�ǵ���������) ������ �͸� �����ش�.
     * @param hris.B.B01ValuateDBData
     * @exception com.sns.jdf.GeneralException
     */
    public String getStartDate() throws GeneralException {
        String year = "";
        Statement        stmt                = null;
        ResultSet        rs                  = null;
        try{

            //conn = ds.getConnection(user, password);

        	//local
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            StringBuffer query = new StringBuffer();
            query.append("   SELECT MAX(SDATE) CODE_CHAR    ");
            query.append("     FROM APP1020 	            ");
            query.append("    WHERE APSTEPCD = '80'	    ");

            stmt = conn.createStatement();
            JDFStatement jdfStmt = new JDFStatement(this, stmt);
            rs = jdfStmt.executeQuery(query.toString());

            while( rs.next() ){
                year = rs.getString("CODE_CHAR");
            }

        } catch( Exception e ){
            throw new GeneralException(e);
        } finally {
            DBUtil.close(rs, stmt);
            DBUtil.close(conn);
        }
        return year;
    }
    /**
     * �򰡱Ⱓ - �򰡰���� ���ڰ����ȸ����(���ڽ�������) ������ �͸� �����ش�.
     * @param hris.B.B01ValuateDBData
     * @exception com.sns.jdf.GeneralException
     */
    public String getBossStartDate() throws GeneralException {
        String year = "";
        Statement        stmt                = null;
        ResultSet        rs                  = null;
        try{

           // conn = ds.getConnection(user, password);

        	//local
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            StringBuffer query = new StringBuffer();
            query.append("   SELECT MAX(SDATE) CODE_CHAR    ");
            query.append("     FROM APP1020 	            ");
            query.append("    WHERE APSTEPCD = '60'	    ");

            stmt = conn.createStatement();
            JDFStatement jdfStmt = new JDFStatement(this, stmt);
            rs = jdfStmt.executeQuery(query.toString());

            while( rs.next() ){
                year = rs.getString("CODE_CHAR");
            }

        } catch( Exception e ){
            throw new GeneralException(e);
        } finally {
            DBUtil.close(rs, stmt);
            DBUtil.close(conn);
        }
        return year;
    }

////////////////////////// TEST ////////////////////////////
    public void FileUpload(String filename) throws IOException {
        try {
            conn = ds.getConnection(user, password);

            File file = new java.io.File(filename);

            //�������� 1�� ����
            if( !file.getAbsolutePath().equals(file.getCanonicalPath())){
            	try {
            		throw new Exception("���ϰ�� �� ���ϸ��� Ȯ���Ͻʽÿ�.");
            	} catch (Exception e) {
            		Logger.debug.println(e.getMessage());
            	}
            }

            int fileLength = (int)file.length();
Logger.debug.println(this, "############## : " + fileLength);
            InputStream fin = new FileInputStream(file);

            PreparedStatement pstmt =
                conn.prepareStatement("INSERT INTO PDS (FILENAME, BINARY) VALUES ( ?, ?)");
            pstmt.setString(1, filename);
            pstmt.setBinaryStream(2, fin, fileLength);
            pstmt.executeUpdate();
        }
        catch(SQLException e) {
            Logger.error(e);
        }
        catch(FileNotFoundException e) {
            Logger.error(e);
        }
    }

}
