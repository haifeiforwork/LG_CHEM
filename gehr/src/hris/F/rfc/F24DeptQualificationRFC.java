/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �μ��� �ڰ� ������ ��ȸ                                     */
/*   Program ID   : F24DeptQualificationRFC                                     */
/*   Description  : �μ��� �ڰ� ������ ��ȸ�� ���� RFC ����                     */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-31 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import hris.F.F24DeptQualificationData;

import java.util.*;

import com.sns.jdf.*;
import com.sap.mw.jco.*;
import com.sns.jdf.sap.*;


/**
 * F24DeptQualificationRFC
 * �μ��� ���� ��ü �μ����� �ڰ� ������ ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F24DeptQualificationRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_ORGEH_LICN";
    private String functionName = "ZGHR_RFC_GET_ORG_LICN_INFO";

    /**
     * �μ��ڵ忡 ���� ��ü �μ����� �ڰ� ������ ������ �������� RFC�� ȣ���ϴ� Method
     * @param java.lang.String �μ��ڵ�, �����μ���ȸ ����.
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getDeptQualification(String i_orgeh, String i_check) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, i_orgeh, i_check);
            excute(mConnection, function);
			ret =  getTable(F24DeptQualificationData.class,  function, "T_EXPORTA");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
        return ret;
    }

    /**
     * RFC �������� Import ���� setting �Ѵ�.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) �� ȣ��Ǳ� ���� ����Ǿ���ϴ� �޼ҵ�
     * @param function com.sap.mw.jco.JCO.Function
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String i_orgeh, String i_check) throws GeneralException {
        String fieldName  = "I_ORGEH";
        setField(function, fieldName, i_orgeh);
        String fieldName1 = "I_LOWERYN";
        setField(function, fieldName1, i_check);
    }


}


