/**
 * C03LearnDetailDB.java
 * ����� ���� �̷� ������ ��ȸ�� �� �ֵ��� �ϴ� Class
 * Global Academy db ����
 * @author ������
 * @version 1.0, 2017/10/16
 *  [CSR ID:3504688] Global Academy �����̷� I/F ���� ��û
 *  update [CSR ID:3525660] ���� �ùķ��̼� Logic ���� �� ȭ�鱸�� ��û ��  20171115 eunha
 */
package hris.C.db;

import hris.B.B04Promotion.B04PromotionAData;
import hris.C.C03LearnDetailData;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Locale;
import java.util.Vector;

import com.common.Global;
import com.common.Utils;
import com.sns.jdf.Config;
import com.sns.jdf.Configuration;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.db.DBUtil;
import com.sns.jdf.db.JDFPreparedStatement;
import com.sns.jdf.sap.SAPType;
import com.sns.jdf.util.DataUtil;
import com.sns.jdf.util.WebUtil;

public class C03LearnDetailDB {

    Connection conn = null;


    String user     = "";
    String password = "";
    String source   = ""; // ����Ÿ�ҽ��̸�
    String url   = ""; // local
    protected Global g;
    private SAPType sapType;
    String I_LANG = "ko";

    public C03LearnDetailDB() throws GeneralException
    {
        try {
        Config conf   = new Configuration();

        user     = conf.getString("com.sns.jdf.LGACADEMY.webuser");
        password = conf.getString("com.sns.jdf.LGACADEMY.passwd");
        url  = conf.get("com.sns.jdf.LGACADEMY.url");

        g = Utils.getBean("global");
        sapType  = g.getSapType();
        Logger.debug("-------------- sapwrap created ---------------- " + sapType);

        if(Locale.KOREAN.equals(g.getLocale())) I_LANG = "ko";
        else if(Locale.ENGLISH.equals(g.getLocale())) I_LANG = "en";
        else if(Locale.CHINESE.equals(g.getLocale())) I_LANG = "zh-cn";

    } catch (Exception e) {
        Logger.debug.println(e.toString());
    }
}

    /**
     * �����̼�����(ESS,MSS), ������ĺ�����õ
     * @param String I_PERNR, String I_BEGDA, String I_ENDDA
     * @exception com.sns.jdf.GeneralException
     */

    public Vector<C03LearnDetailData> getTrainingList( String I_PERNR, String I_BEGDA, String I_ENDDA) throws GeneralException {
        ResultSet        rs                  = null;
        CallableStatement cstmt		= null;
        Vector           C03LearnDetailData_vt = new Vector();
        try{

            Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            cstmt = conn.prepareCall("{call inno.SLP_HRPORTAL_EDU_HIST_SEL(?,?,?,?)}");


            cstmt.setString(1,I_PERNR);
            cstmt.setString(2,DataUtil.removeStructur(I_BEGDA,"."));
            cstmt.setString(3,DataUtil.removeStructur(I_ENDDA,"."));
            cstmt.setString(4,I_LANG);

            Logger.debug.println(I_PERNR+"|"+DataUtil.removeStructur(I_BEGDA,".")+"|"+DataUtil.removeStructur(I_ENDDA,".")+"|"+I_LANG);
            rs =  cstmt.executeQuery();

            while( rs.next() ){
            	C03LearnDetailData data                = new C03LearnDetailData();
            	data.LVSTX =  rs.getString("CAT_NAME")	;
            	data.DVSTX= rs.getString("COURSE_NAME")	;//	CHAR	40	�������� �̸�
            	data.BEGDA	= WebUtil.printDate(rs.getString("EDU_START_DATE"));//	DATS	8	������
            	data.ENDDA	= WebUtil.printDate(rs.getString("EDU_END_DATE"));//	DATS	8	������
            	data.PERIOD=data.BEGDA+"~"+	data.ENDDA;//	CHAR	40	�Ⱓ
            	data.TESTX	= rs.getString("MANAGEMENT_DEPT_NAME");//	CHAR	40	�������
            	data.STATE_ID= rs.getString("PASS_YN_CODE")	;//	CHAR	1	�̼�����
                data.TASTX= rs.getString("TOTAL_SCORE")	;//	CHAR	 10 	�����򰡰��
                data.ATTXT= rs.getString("REQUIRED_COURSE")	;//	CHAR	 40 	�ʼ����� ������Ī
                data.TFORM= rs.getString("ON_OFF")	;//	CHAR	 40 	��������
                DataUtil.fixNullAndTrim(data);
                C03LearnDetailData_vt.addElement(data);
            }

        } catch( Exception e ){
        	 Logger.debug.println(e.toString());
        } finally {
            DBUtil.close(rs, cstmt);
            DBUtil.close(conn);
        }
        return C03LearnDetailData_vt;

    }

    /**
     * ���ް����̼�����
     * @param String I_PERNR, String I_PROM_CODE
     * @exception com.sns.jdf.GeneralException
     * [CSR ID:3525660] ���� �ùķ��̼� Logic ���� �� ȭ�鱸�� ��û ��  20171115 eunha
     */
    public Vector<B04PromotionAData> getPromotionCheck( String I_PERNR, String I_PROM_CODE) throws GeneralException {
        ResultSet        rs                  = null;
        CallableStatement cstmt		= null;
        Vector           B04PromotionAData_vt = new Vector();
        try{

            Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            cstmt = conn.prepareCall("{call inno.SLP_HRPORTAL_JINGUP_SIMUL_EDU_HIST_SEL(?,?)}");


            cstmt.setString(1,I_PERNR);
            cstmt.setString(2,I_PROM_CODE);


            rs =  cstmt.executeQuery();
            Logger.debug.println(I_PERNR+"|"+I_PROM_CODE);

           while( rs.next() ){
            	B04PromotionAData data                = new B04PromotionAData();
                data.EDU_NAME = rs.getString("COURSE_NAME")	;
                data.EDU_FLAG = rs.getString("PASS_YN");
                DataUtil.fixNullAndTrim(data);
                B04PromotionAData_vt.addElement(data);
            }


        } catch( Exception e ){
        	 Logger.debug.println(e.toString());
        } finally {
            DBUtil.close(rs, cstmt);
            DBUtil.close(conn);
        }
        return B04PromotionAData_vt;

    }
    /**
     * �λ��Ϻ� �����̷�
     * @param String I_PERNR, String I_BEGDA, String I_CFMAN
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<C03LearnDetailData> getPersonalCardTrainingList( String I_PERNR, String I_BEGDA, String I_CFMAN ) throws GeneralException {
        ResultSet        rs                  = null;
        CallableStatement cstmt		= null;
        Vector           C03LearnDetailData_vt = new Vector();
        try{

            Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            cstmt = conn.prepareCall("{call inno.SLP_HRPORTAL_EDU_HIST_PERSONNEL_CARD_SEL(?,?,?,?)}");


            cstmt.setString(1,I_PERNR);
            cstmt.setString(2,DataUtil.removeStructur(I_BEGDA,"."));
            cstmt.setString(3,I_CFMAN);
            cstmt.setString(4,I_LANG);

            Logger.debug.println(I_PERNR+"|"+DataUtil.removeStructur(I_BEGDA,".")+"|"+I_CFMAN+"|"+I_LANG);
            rs =  cstmt.executeQuery();

            while( rs.next() ){
            	C03LearnDetailData data                = new C03LearnDetailData();
            	data.LVSTX =  rs.getString("CAT_NAME2")	;
            	data.DVSTX= rs.getString("COURSE_NAME")	;//	CHAR	40	�������� �̸�
            	data.BEGDA	= rs.getString("EDU_START_DATE");//	DATS	8	������
            	data.ENDDA	= rs.getString("EDU_END_DATE");//	DATS	8	������
            	data.PERIOD=WebUtil.printDate(data.BEGDA)+"~"+	WebUtil.printDate(data.ENDDA);//	CHAR	40	�Ⱓ
            	data.TESTX	= rs.getString("MANAGEMENT_DEPT_NAME");//	CHAR	40	�������

            	DataUtil.fixNullAndTrim(data);
                C03LearnDetailData_vt.addElement(data);
            }

        } catch( Exception e ){
        	 Logger.debug.println(e.toString());
        } finally {
            DBUtil.close(rs, cstmt);
            DBUtil.close(conn);
        }
        return C03LearnDetailData_vt;

    }

    /**
     * �ӿ���������
     * @param String I_PERNR
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<C03LearnDetailData> getImwonEduList( String I_PERNR) throws GeneralException {
        ResultSet        rs                  = null;
        CallableStatement cstmt		= null;
        Vector           C03LearnDetailData_vt = new Vector();
        try{

            Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");

            cstmt = conn.prepareCall("{call inno.SLP_HRPORTAL_IMWON_EDU_HIST_SEL(?)}");
            cstmt.setString(1,I_PERNR);

            Logger.debug.println(I_PERNR);
            rs =  cstmt.executeQuery();

            while( rs.next() ){
            	C03LearnDetailData data                = new C03LearnDetailData();
            	data.DVSTX= rs.getString("COURSE_NAME")	;//	CHAR	40	�������� �̸�
            	data.BEGDA	= rs.getString("EDU_START_DATE");//	DATS	8	������
            	DataUtil.fixNullAndTrim(data);
            	C03LearnDetailData_vt.addElement(data);
            }

        } catch( Exception e ){
        	 Logger.debug.println(e.toString());
        } finally {
            DBUtil.close(rs, cstmt);
            DBUtil.close(conn);
        }
        return C03LearnDetailData_vt;

    }


    public String getTest() throws GeneralException
    {
        Statement        stmt                = null;
        ResultSet        rs                  = null;
        PreparedStatement pstmt = null; //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ
        String msg="���ӽõ�";
        try{


            Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");


            Connection conn = DriverManager.getConnection(url,user,password);
            Logger.dbwrap.println(conn, "Connection created.");


            StringBuffer query = new StringBuffer();
            query.append("SELECT GETDATE() AS CURRENTDATETIME");

            pstmt = conn.prepareStatement(query.toString());

            Logger.debug.println("Connection �ǳ�? " + (conn == null ? "�ȵ�.�Ф�" : "�ȴ�!!! ����"));

            JDFPreparedStatement jdfPstmt = new JDFPreparedStatement(this, query.toString(), pstmt);
            rs = jdfPstmt.executeQuery();

          //[CSR ID:3390354] �λ�ý��� �������� ���ؼ� ���� ��ġ end
            if (rs.next()) {

                Logger.debug.println("���� �ð��� '" + rs.getString("CURRENTDATETIME") +"'�̰� �� ���ӵȴ�.");
                msg = "���� �ð��� '" + rs.getString("CURRENTDATETIME") +"'�̰� �� ���ӵȴ�.";

               } else {

            	   Logger.debug.println("������ ������ ����!! ��");
            	   msg = "������ ������ ����!! ��";

               }


        } catch( Exception e ){
        	 Logger.debug.println(e.toString());
        	 msg = e.toString();
        } finally {

            DBUtil.close(rs, stmt);
            DBUtil.close(conn);
        }
return msg;
    }


}
