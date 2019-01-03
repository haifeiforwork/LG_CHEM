/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : Manager's Desk                                              */
/*   2Depth Name  : �ο���Ȳ                                                    */
/*   Program Name : �μ��� 4���� ���ȭ ��                                    */
/*   Program ID   : F31Dept4YearValuationRFC                                    */
/*   Description  : �μ��� 4���� ���ȭ �� ��ȸ�� ���� RFC ����               */
/*   Note         : ����                                                        */
/*   Creation     : 2005-02-01 �����                                           */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.F.rfc;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import hris.F.F31Dept4YearValuationData;

import java.util.Vector;


/**
 * F31Dept4YearValuationRFC
 * �μ��� ���� ��ü �μ����� 4���� ���ȭ �� ������ �������� RFC�� ȣ���ϴ� Class
 *
 * @author  �����
 * @version 1.0
 */
public class F31Dept4YearValuationRFC extends SAPWrap {


    private String functionName = "ZGHR_RFC_GET_ORG_APPR_INFO";

    /** 
     * �μ��ڵ忡 ���� ��ü �μ����� 4���� ���ȭ �� ������ �������� RFC�� ȣ���ϴ� Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector<F31Dept4YearValuationData> getDept4YearValuation(String I_ORGEH, String I_LOWERYN) throws GeneralException {
         
        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setField(function, "I_ORGEH", I_ORGEH);
            setField(function, "I_LOWERYN", I_LOWERYN);
            //I_AYEAR ���س⵵

            excute(mConnection, function);

            return getTable(F31Dept4YearValuationData.class, function, "T_EXPORTA");
			
        } catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        } 
    }
}


