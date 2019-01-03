/********************************************************************************/
/*                                                                              */
/*   System Name  : MSS                                                         */
/*   1Depth Name  : MY HR ����                                                  */
/*   2Depth Name  : ������                                                      */
/*   Program Name : ������                                                      */
/*   Program ID   : E19CongLifnrRFC                                             */
/*   Description  : �μ����������� ��������  Class                              */
/*   Note         : [���� RFC] : ZHRA_RFC_GET_LIFNR                             */
/*   Creation     : 2005-03-25  ������                                          */
/*   Update       :                                                             */
/*                                                                              */
/********************************************************************************/

package hris.E.E19Congra.rfc;

import hris.E.E19Congra.E19CongcondData;

import java.util.*;

import com.sns.jdf.*;
import com.sns.jdf.sap.*;
import com.sap.mw.jco.*;

public class E19CongLifnrRFC extends SAPWrap {

    //private String functionName = "ZHRA_RFC_GET_LIFNR";
	private String functionName = "ZGHR_RFC_GET_LIFNR";

    /**
     * �μ����������� �������� RFC�� ȣ���ϴ� Method
     * @param companyCode java.lang.String ȸ���ڵ�
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getLifnr(String companyCode,  String empNo, String gubun) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, companyCode, empNo);
            excute(mConnection, function);
            Vector ret = new Vector();
            if( gubun == "2" ) {            // �μ����������ڵ�,�����
              ret = getTable(E19CongcondData.class, function, "T_RESULT");
			} else {
              ret = getCodeVector( function, "T_RESULT");
			}
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
     * @param companyCode java.lang.String ȸ���ڵ�
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String companyCode, String empNo) throws GeneralException {
        String fieldName = "I_BUKRS";
        setField( function, fieldName, companyCode );
		fieldName = "I_PERNR";
		setField( function, fieldName, empNo );
    }

}
