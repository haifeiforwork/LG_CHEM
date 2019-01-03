/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �μ��� ���� �������� ��ȸ                                   */
/*   Program ID   : F23DeptLanguageRFC                                          */
/*   Description  : �μ��� ���� �������� ��ȸ�� ���� RFC ����                   */
/*   Note         : ����                                                        */
/*   Creation     : 2005-01-28 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.F.F23DeptLanguageData;

import java.util.Vector;


/**
 * F23DeptLanguageRFC
 * �μ��� ���� ��ü �μ����� ���� �������� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F23DeptLanguageRFC extends SAPWrap {
 
    private String functionName = "ZGHR_RFC_GET_ORG_LANG_INFO";

    /** 
     * �μ��ڵ忡 ���� ��ü �μ����� �з������� �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<F23DeptLanguageData> getDeptLanguage(String I_ORGEH, String I_LOWERYN) throws GeneralException {

        JCO.Client mConnection = null;
        Vector ret = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);

            excute(mConnection, function);

            return getTable(F23DeptLanguageData.class, function, "T_EXPORTA");

        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }

}


