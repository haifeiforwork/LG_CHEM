package hris.common.db;

import java.util.*;
import java.sql.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import com.sns.jdf.*;
import com.sns.jdf.db.*;
 
import hris.common.UplusSmsData;
import hris.common.util.*;

import java.io.Reader;
import java.io.Writer;
import java.io.CharArrayReader;

import oracle.sql.CLOB;
/**
 * UplusSmsDB.java
 * sms�߼�
 * DB Table Name : "����ȭȯ ��û�� sms�߼�"
 *
 * @author lsa
 * @version 1.0, 2014/04/28
 */
public class UplusSmsDB {
	
	Connection conn = null;

    private DataSource ds = null;

    String user     = "";
    String password = "";
    String source   = ""; // ����Ÿ�ҽ��̸�

    
    public UplusSmsDB() throws GeneralException
    {
        try {
            Config conf   = new Configuration();
            source   = conf.getString("com.sns.jdf.EHRAPP.dbname");
            user     = conf.getString("com.sns.jdf.EHRAPP.webuser");
            password = conf.getString("com.sns.jdf.EHRAPP.passwd");
            java.util.Hashtable props = new java.util.Hashtable();
            props.put(Context.INITIAL_CONTEXT_FACTORY, "jeus.jndi.JNSContextFactory");
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
    }
  
    
    /**                                   
     * SMS TABLE insert �ϴ�  Method 
     * @param java.util.Vector
     * @param String path
     * @param String serverName
     * @return java.util.Vector           
     * @exception com.sns.jdf.GeneralException
     */
    public String buildSms(UplusSmsData data) throws GeneralException, SQLException {         
    	Statement stmt  = null;
        ResultSet rs = null;
        PreparedStatement pStmt = null;
        String result  = "";                                     
        try {                                                                
        	conn = ds.getConnection(user, password);
        	conn.setAutoCommit(false);
        	
            StringBuffer sqlBuf = new StringBuffer();
            
            sqlBuf.append("INSERT INTO  SC_TRAN ");
            sqlBuf.append("(TR_NUM , TR_SENDDATE, TR_SENDSTAT, TR_MSGTYPE, TR_PHONE, TR_CALLBACK, TR_MSG)  ");
            sqlBuf.append("VALUES (SC_TRAN_SEQ.NEXTVAL, SYSDATE, ?, ?, ?, ?, ?)");
                            
            pStmt = conn.prepareStatement(sqlBuf.toString());
            
            pStmt.setString(1, data.TR_SENDSTAT);		//�߼ۻ��� 0:�߼۴��,1: ���ۿϷ�,2:������ſϷ�	
            pStmt.setString(2, data.TR_SENDSTAT);		//������������ 0:�Ϲ�,1:�ݹ�URL �޼���
            pStmt.setString(3, data.TR_PHONE);			//������ �ڵ�����ȣ
            pStmt.setString(4, data.TR_CALLBACK); 	 	//�۽��� ��ȭ��ȣ
            pStmt.setString(5, data.TR_MSG); 				//�޼��� 

            Logger.debug.println(this, " pStmt = " + pStmt.toString());
            
            JDFPreparedStatement jdfPstmt = new JDFPreparedStatement(this, sqlBuf.toString(), pStmt);
            jdfPstmt.executeUpdate();
            
            conn.commit();
            result = "Y";       
                                                    
        } catch (Exception e) { 
        	conn.rollback();
            throw new GeneralException(e);
        } finally {                                                           
        	 DBUtil.close(rs, stmt);
             DBUtil.close(conn);                                          
        }
        return result;
    }
     
}