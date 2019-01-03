package hris.E.E31InfoStatus.rfc ;

import java.util.* ;
import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.E.E31InfoStatus.* ;

/**
 * E31InfoStatusRFC.java
 * ������ ������Ȳ RFC�� ȣ���ϴ� Class
 *
 * @author ������
 * @version 1.0, 2004/10/22
 */
public class E31InfoStatusRFC extends SAPWrap {

    private String functionName = "ZGHR_RFC_G_INFORMAL_LIST" ;

    /**
     * ������ ������Ȳ RFC ȣ���ϴ� Method
     * @return java.util.Vector
     * @param empno java.lang.String ���� ���
     * @param subty java.lang.String ������ �ڵ�
     * @param infty java.lang.String ������ ����(0:����, 1:Ż��, 2:��ü)
     * @param fdate java.lang.String ��ȸ���
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String empno, String subty, String infty, String fdate ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            empno = DataUtil.fixEndZero(empno, 8);

            setInput(function, empno, subty, infty, fdate);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            return ret;
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param empno java.lang.String ���� ���
     * @param subty java.lang.String ������ �ڵ�
     * @param infty java.lang.String ������ ����(0:����, 1:Ż��, 2:��ü)
     * @param fdate java.lang.String ��ȸ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empno, String subty, String infty, String fdate) throws GeneralException {
        String fieldName = "I_PERNR";
        setField( function, fieldName, empno );
        String fieldName1 = "I_SUBTY";
        setField( function, fieldName1, subty );
        String fieldName2 = "I_INFTY";
        setField( function, fieldName2, infty );
        String fieldName3 = "I_FDATE";
        setField( function, fieldName3, fdate );
    }

    /**
     * RFC ������ Export ���� Vector �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

        Vector P_IF1_T = getTable(hris.E.E31InfoStatus.E31InfoNameData.class, function, "T_IF1");
        Vector P_IF2_T = getTable(hris.E.E31InfoStatus.E31InfoMemberData.class, function, "T_IF2");

        ret.addElement(P_IF1_T);
        ret.addElement(P_IF2_T);

        return ret ;
    }
}
