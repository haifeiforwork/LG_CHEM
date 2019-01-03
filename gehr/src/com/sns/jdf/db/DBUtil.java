/**
  * DBUtil.java
  *
  **/

// PACKAGE
package com.sns.jdf.db;

import java.sql.*;
import java.util.*;
import javax.sql.*;
import javax.ejb.*;
import javax.naming.*;

import com.sns.jdf.*;

public class DBUtil
{
    public DBUtil()
    {

    }

    public static Connection getConnection() throws GeneralException
    {
        //connection을 생성 또는 얻어옴
        try
        {
            //private String dbName = "java:comp/env/jdbc/AccountDB";
            Config conf = new Configuration();
            /*지은 수정(local).
             * String dbName  = conf.getString("com.sns.jdf.defaultDB.dbname");
            String webuser = conf.getString("com.sns.jdf.defaultDB.webuser");
            String passwd  = conf.getString("com.sns.jdf.defaultDB.passwd");*/
            String dbName  = conf.getString("com.sns.jdf.defaultDB.dbname");
            String webuser = conf.getString("com.sns.jdf.defaultDB.webuser");
            String passwd  = conf.getString("com.sns.jdf.defaultDB.passwd");

            String url  = conf.getString("com.sns.jdf.defaultDB.url");

			// InitialContext ic = new InitialContext();
			// DataSource ds = (DataSource) ic.lookup(dbName);
            Class.forName("oracle.jdbc.driver.OracleDriver");

            Connection con = DriverManager.getConnection(url,webuser,passwd);
            Logger.dbwrap.println(con, "Connection created.");

        	//로컬설정으로 변경함
 /*           InitialContext ic = new InitialContext();
            Context env = (Context)ic.lookup("java:comp/env");
            DataSource ds = (DataSource)env.lookup("jdbc/sapdevDS");
            Connection con = DriverManager.getConnection(url,webuser,passwd);
            Logger.dbwrap.println(con, "Connection created.");

            */

           /*Logger.debug.println("db name : " + dbName);
            InitialContext ic = new InitialContext();
            Logger.debug.println("create InitialContext");
            Context env = (Context)ic.lookup("java:comp/env");
            DataSource ds = (DataSource)env.lookup(dbName);
            //DataSource ds = (DataSource)ic.lookup(dbName);
            Logger.debug.println("lookup datasource");
            Connection con = ds.getConnection(webuser, passwd);*/

            Logger.dbwrap.println(con, "Connection created.");
        //    return con;

            return con;
        } catch (Exception e) {
            Logger.err.println(e, e); //caller사용여부?
            throw new GeneralException(e, "Connection create fail.");
        }
    }
    public static Connection getConnection_prd() throws GeneralException
    {
        //connection을 생성 또는 얻어옴
        try
        {
            //private String dbName = "java:comp/env/jdbc/AccountDB";
            Config conf = new Configuration();
            String dbName  = conf.get("com.sns.jdf.defaultDB.dbname");
            String webuser = conf.get("com.sns.jdf.defaultDB.webuser");
            String passwd  = conf.get("com.sns.jdf.defaultDB.passwd");

            Logger.debug.println("db name : " + dbName);
            InitialContext ic = new InitialContext();
            Logger.debug.println("create InitialContext");
            DataSource ds = (DataSource) ic.lookup(dbName);
            Logger.debug.println("lookup datasource");
            Connection con = ds.getConnection(webuser,passwd);
            Logger.dbwrap.println(con, "Connection created.");
            return con;
        } catch (Exception e) {
            Logger.err.println(e, e); //caller사용여부?
            throw new GeneralException(e, "Connection create fail.");
        }
    }
//운영
    public static Connection getConnection_prd(String dataBaseName) throws GeneralException
    {
        //connection을 생성 또는 얻어옴
        try
        {
            Config conf = new Configuration();
            String dbName  = conf.get("com.sns.jdf."+ dataBaseName +".dbname");
            String webuser = conf.get("com.sns.jdf."+ dataBaseName +".webuser");
            String passwd  = conf.get("com.sns.jdf."+ dataBaseName +".passwd");

            Logger.debug.println("db name : " + dbName);
            InitialContext ic = new InitialContext();
            Logger.debug.println("create InitialContext");
            DataSource ds = (DataSource) ic.lookup(dbName);
            Logger.debug.println("lookup datasource");
            Connection con = ds.getConnection(webuser,passwd);
            Logger.dbwrap.println(con, "Connection created.");
            return con;
        } catch (Exception e) {
            Logger.err.println(e, e); //caller사용여부?
            throw new GeneralException(e, "Connection create fail.");
        }
    }
//로컬

    public static Connection getConnection(String dataBaseName) throws GeneralException
    {
        // connection을 생성 또는 얻어옴
        try
        {
            Config conf = new Configuration();

            String dbName  = conf.get("com.sns.jdf."+ dataBaseName +".dbname");
            String webuser = conf.get("com.sns.jdf."+ dataBaseName +".webuser");
            String passwd  = conf.get("com.sns.jdf."+ dataBaseName +".passwd");
            String url  = conf.get("com.sns.jdf."+ dataBaseName +".url");

			// InitialContext ic = new InitialContext();
			// DataSource ds = (DataSource) ic.lookup(dbName);

            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection(url,webuser,passwd);
            Logger.dbwrap.println(con, "Connection created.");
            return con;

        } catch (Exception e) {
            Logger.err.println(e, e);
            throw new GeneralException(e, "Connection create fail.");
        }
    }
    public static Connection getTransaction( String dataBaseName ) throws GeneralException
    {
        try {
            Connection con = getConnection( dataBaseName );
            con.setAutoCommit(false);
            Logger.dbwrap.println(con, "Transaction created.");
            return con;
        } catch (Exception e) {
            Logger.err.println(e, e); //caller사용여부?
            throw new GeneralException(e, "Transaction create fail.");
        }
    }

    public static Connection getTransaction() throws GeneralException {
        try {
            Connection con = getConnection();
            con.setAutoCommit(false);
            Logger.dbwrap.println(con, "Transaction created.");
            return con;
        } catch (Exception e) {
            Logger.err.println(e, e); //caller사용여부?
            throw new GeneralException(e, "Transaction create fail.");
        }
    }

	public static void close(ResultSet rs)
	{
		if ( rs != null)
			try { rs.close(); } catch (Exception e) {}
	}

	public static void close(Statement stmt)
	{
		if ( stmt != null)
			try { stmt.close(); } catch (Exception e) {}
	}

    public static void close(Connection con ,boolean isCommit){
        if (con != null)
        {
            try
            {
                if (isCommit) {
                    con.commit();
                } else {
                    con.rollback();
                } // end if

                con.setAutoCommit(true);
                Logger.dbwrap.println(con, "Connection closed");
                con.close();
                con=null;
             } catch (Exception e) {}
        }

    }

    public static void close(Connection con){
        if (con != null)
        {
            try
            {
                con.rollback();
                con.setAutoCommit(true);
                Logger.dbwrap.println(con, "Connection closed");
                con.close();
                con=null;
             } catch (Exception e) {}
        }

    }

	public static void close(ResultSet rs, Statement stmt)
	{
		close(rs);
        close(stmt);
	}

	public static void close(PreparedStatement pstmt)
	{
		if ( pstmt != null)
			try { pstmt.close(); } catch (Exception e) {}
	}

	public static void close(ResultSet rs, PreparedStatement pstmt)
	{
		close(rs);
        close(pstmt);
	}

    public static void close(Statement stmt, Connection con)
	{
		close(stmt);
        close(con);
	}

    public static void close(PreparedStatement pstmt, Connection con)
	{
		close(pstmt);
        close(con);
	}

    public static void close(ResultSet rs, Statement stmt, Connection con)
	{
        close(rs);
		close(stmt);
        close(con);
	}

    public static void close(ResultSet rs, PreparedStatement pstmt, Connection con)
	{
		close(rs);
		close(pstmt);
        close(con);
	}


    // table의 owner를 가져오는 메소드
    public static String getOwner() throws GeneralException {
        try
        {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            //return conf.getString("com.sns.jdf.defaultDB.owner");sapdev local에서 변경함.
            return conf.getString("com.sns.jdf.defaultDB.owner");
        } catch (Exception e) {
            Logger.err.println(e, e); //caller사용여부?
            throw new GeneralException(e, "get Owner fail.");
        }
    }

    public static String getOwner( String dataBaseName ) throws GeneralException {
        try
        {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            return conf.getString("com.sns.jdf."+dataBaseName+".owner");

        } catch (Exception e) {
            Logger.err.println(e, e); //caller사용여부?
            throw new GeneralException(e, "get Owner fail.");
        }
    }

	public static String fromDB(String data)   {                     // 한글로 컨버팅
		try {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            if( conf.getBoolean("com.sns.jdf.util.DBConversion") ){
                Logger.debug.println(data);
                data = new String(data.getBytes("8859_1"));
                Logger.debug.println(data);
                return data;
            }else{
                return data;
            }
		}catch(Exception e) {
			Logger.error(e);
			return data;
		}
	}

	public static String toDB(String data)   {                     // 한글로 컨버팅
		try {
            com.sns.jdf.Config conf = new com.sns.jdf.Configuration();
            if( conf.getBoolean("com.sns.jdf.util.DBConversion") ){
                Logger.debug.println("before toDB" + data);
                data = new String(data.getBytes("8859_1"));
                Logger.debug.println("after toDB" +data);
                return data;
            }else{
                return data;
            }
		}catch(Exception e) {
            Logger.debug.println("exception toDB" + data + "e :" + e.getMessage());
			Logger.error(e);
			return data;
		}
	}
}
