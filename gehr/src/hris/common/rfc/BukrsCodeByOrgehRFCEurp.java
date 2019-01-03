/********************************************************************************/
/*   System Name  : MSS                                                  	 */
/*   1Depth Name  :                           	 */
/*   2Depth Name  :                                  	 */
/*   Program Name :                         	 */
/*   Program ID   : BukrsCodeByOrgehRFCEurp                  	 */
/*   Description  : �μ��ڵ����� �����ڵ� ��ȸ�� ���� servlet[������] */
/*   Note         : ����                                                        			 	 */
/*   Creation     : 2010-07-30 yji                                             */
/********************************************************************************/
package hris.common.rfc;

import java.util.*;

import com.sap.mw.jco.*;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DataUtil;

/**
 * BukrsCodeByOrgehRFCEurp.java
 * �μ��ڵ�� �����ڵ带 ��ȸ�ϴ� RFC�� ȣ���Ѵ�.[����]
 *
 * @author yji
 * @version 1.0, 2010/07/30
 */
public class BukrsCodeByOrgehRFCEurp extends SAPWrap {

    private String functionName = "ZHR_GET_BUKRS_OF_ORGEH";

    /**
     * �μ��ڵ����� �����ڵ带 �������� RFC�� ȣ���ϴ� Method
     *
     * @param java.lang.String ����̸�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getBukrsCode( String i_orgCd) throws GeneralException {
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgCd);
            excute(mConnection, function);
            Vector ret = getOutput(function);

            Logger.warn.println("BukrsCodeByOrgehRFCEurp Result:: " + ret.toString());

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
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_orgeh) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);

        String fieldName1 = "I_DATUM";
        setField( function, fieldName1, DataUtil.getCurrentDate() );
    }


    /**
     * RFC ������ Export ���� String �� Return �Ѵ�.
     * �ݵ�� com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ����Ŀ� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.lang.String
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
    	String E_RETURN  = getField("E_RETURN", function );
    	String E_BUKRS  = getField("E_BUKRS", function );
        String E_BUTXT  = getField("E_BUTXT", function );
        Vector vt = new Vector(2);
        vt.addElement(E_RETURN);
        vt.addElement(E_BUKRS);
        vt.addElement(E_BUTXT);
        return vt;
    }
}
