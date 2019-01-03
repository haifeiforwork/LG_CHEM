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
 * sms발송
 * DB Table Name : "경조화환 신청시 sms발송"
 *
 * @author lsa
 * @version 1.0, 2014/04/28
 */
public class UplusSmsDB {
	
	Connection conn = null;

    private DataSource ds = null;

    String user     = "";
    String password = "";
    String source   = ""; // 데이타소스이름

    
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
     * SMS TABLE insert 하는  Method 
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
            
            pStmt.setString(1, data.TR_SENDSTAT);		//발송상태 0:발송대기,1: 전송완료,2:결과수신완료	
            pStmt.setString(2, data.TR_SENDSTAT);		//문자전송형태 0:일반,1:콜백URL 메세지
            pStmt.setString(3, data.TR_PHONE);			//수신할 핸드폰번호
            pStmt.setString(4, data.TR_CALLBACK); 	 	//송신자 전화번호
            pStmt.setString(5, data.TR_MSG); 				//메세지 

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