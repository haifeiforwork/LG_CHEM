/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manaer's Desk                                               */
/*   2Depth Name  : �ؿܰ���                                                    */
/*   Program Name : �ؿܰ��� ��ȸ                                               */
/*   Program ID   : A19OverseasCareerRFC                                        */
/*   Description  : �ؿܰ��� ������ �������� RFC�� ȣ���ϴ� Class               */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-10  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/
 
package hris.A.rfc;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;

public class A19OverseasCareerRFC extends SAPWrap {

    private String functionName = "ZHRA_RFC_GET_TRIP_LIST";

    /** 
     * ������ �ؿܰ��� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getOverseasDetail( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;

        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);

            Vector ret = null;

            ret = getOutput(function);

            return ret;

        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String ���
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName  = "PERNR";
        setField(function, fieldName, empNo);
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

        // Export ���� ��ȸ
        String fieldName1 = "E_RETURN";      // �����ڵ�
        String E_RETURN   = getField(fieldName1, function) ;

        String fieldName2 = "E_MESSAGE";     // ���̾�α� �������̽��� ���� �޼����ؽ�Ʈ
        String E_MESSAGE  = getField(fieldName2, function) ;

        // Table ��� ��ȸ
        String entityName = "hris.A.A19OverseasCareerData";
        Vector T_EXPORT   = getTable(entityName,  function, "T_EXPORT");

        ret.addElement(E_RETURN);
        ret.addElement(E_MESSAGE);
        ret.addElement(T_EXPORT);

        return ret;
    }
}
